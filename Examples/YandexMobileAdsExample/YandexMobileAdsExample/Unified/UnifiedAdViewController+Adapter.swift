import UIKit
import YandexMobileAds

extension UnifiedAdViewController {
    func didSelect(format: UnifiedFormat) {
        guard format != currentFormat else { return }
        currentFormat = format
        swapAdapter(source: currentSource, format: format)
    }

    func swapAdapter(source: AdSource, format: UnifiedFormat) {
        if let inline = currentInlineView {
            NSLayoutConstraint.deactivate(currentInlineConstraints)
            inline.removeFromSuperview()
            currentInlineConstraints.removeAll()
            currentInlineView = nil
        }

        if adapter is NativeBulkProviding {
            bulkAds.removeAll()
            bulkTableView.reloadData()
            if bulkTableView.superview != nil {
                NSLayoutConstraint.deactivate(bulkTableConstraints)
                bulkTableConstraints.removeAll()
                bulkTableView.removeFromSuperview()
            }
        }

        if adapter is FeedAdProviding {
            if feedAdCollectionView.superview != nil {
                NSLayoutConstraint.deactivate(feedAdCollectionViewConstraints)
                feedAdCollectionViewConstraints.removeAll()
                feedAdCollectionView.dataSource = nil
                feedAdCollectionView.delegate = nil
                feedAdCollectionView.removeFromSuperview()
            }
        }

        adapter?.tearDown()
        hasLoadedCurrentAd = false
        logsView.clearLogs()

        updatePlaceholder(state: .idle, visible: true, animated: false)
        adapter = UnifiedAdFactory.makeAdapter(source: source, format: format, hostViewController: self)

        if let appOpenAdapter = adapter as? YandexAppOpenAdapter {
            appOpenAdapter.setPresentingViewController(self)
        }

        wireEvents()

        if let bulk = adapter as? NativeBulkProviding {
            if bulkTableView.superview == nil {
                view.addSubview(bulkTableView)
                bulkTableConstraints = [
                    bulkTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                    bulkTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                    bulkTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                    bulkTableView.bottomAnchor.constraint(equalTo: headerStack.topAnchor, constant: -16)
                ]
                NSLayoutConstraint.activate(bulkTableConstraints)
            }

            bulkAds.removeAll()
            bulkTableView.reloadData()
            bulkTableView.isHidden = true

            updatePlaceholder(state: .idle, visible: true, animated: false)
            view.bringSubviewToFront(placeholderView)

            bulk.onAdsChange = { [weak self] ads in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.bulkAds = ads
                    self.bulkTableView.reloadData()
                    let hasAds = !ads.isEmpty
                    self.bulkTableView.isHidden = !hasAds
                    self.setPlaceholder(visible: !hasAds, animated: true)
                }
            }
        } else if let feedAd = adapter as? FeedAdProviding {
            feedAd.collectionViewAdapter.registerCells(in: feedAdCollectionView)
            feedAdCollectionView.dataSource = feedAd.collectionViewAdapter.dataSource
            feedAdCollectionView.delegate = feedAd.collectionViewAdapter.delegate
            feedAdCollectionView.isHidden = false

            view.addSubview(feedAdCollectionView)
            feedAdCollectionViewConstraints = [
                feedAdCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                feedAdCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                feedAdCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                feedAdCollectionView.heightAnchor.constraint(equalToConstant: Layout.bulkHeight)
            ]
            NSLayoutConstraint.activate(feedAdCollectionViewConstraints)

            updatePlaceholder(state: .idle, visible: true, animated: false)
            view.bringSubviewToFront(placeholderView)
            feedAd.onLoad = { [weak self] in
                guard let self else { return }
                self.setPlaceholder(visible: false, animated: true)
            }
            feedAd.onUpdate = { [weak self] in
                guard let self else { return }
                self.feedAdCollectionView.reloadData()
            }
        } else {
            guard let adapter = self.adapter else { return }
            if let inline = adapter.inlineView {
                inline.accessibilityIdentifier = CommonAccessibility.bannerView
                inline.translatesAutoresizingMaskIntoConstraints = false
                view.addSubview(inline)
                currentInlineView = inline
                currentInlineConstraints = [
                    inline.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Layout.side),
                    inline.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Layout.side),
                    inline.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                    inline.bottomAnchor.constraint(equalTo: headerStack.topAnchor, constant: -16)
                ]
                NSLayoutConstraint.activate(currentInlineConstraints)
                setPlaceholder(visible: true, animated: false)
            }
        }

        (adapter as? AttachableAdProtocol)?.attachIfNeeded(to: self)
        updatePresentAvailability()
        configureLayoutForAdType()
    }
}
