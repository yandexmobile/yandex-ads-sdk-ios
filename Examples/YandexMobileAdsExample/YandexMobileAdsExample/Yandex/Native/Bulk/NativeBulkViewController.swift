/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class NativeBulkViewController: UIViewController {
    private var ads: [NativeAd] = []
    
    private lazy var adView: UITableView = {
        let tableView = UITableView()
        tableView.isHidden = true
        tableView.accessibilityIdentifier = CommonAccessibility.bannerView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            NativeBulkTableViewCell.self,
            forCellReuseIdentifier: NativeBulkTableViewCell.reuseIdentifier
        )
        tableView.dataSource = self
        return tableView
    }()

    private lazy var loadButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Load ad") { [weak self] _ in
                self?.loadNativeAd()
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Load ad", for: .normal)
        button.accessibilityIdentifier = CommonAccessibility.loadButton
        return button
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = CommonAccessibility.stateLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var adLoader: NativeBulkAdLoader = {
        let adLoader = NativeBulkAdLoader()
        adLoader.delegate = self
        return adLoader
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupConstraints()
    }

    // MARK: - Ad

    private func loadNativeAd() {
        // Replace demo-native-bulk-yandex with actual Ad Unit ID
        let requestConfiguration = NativeAdRequestConfiguration(adUnitID: "demo-native-bulk-yandex")
        adLoader.loadAds(with: requestConfiguration, adsCount: 3)
        stateLabel.text = nil
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .white
        title = "Native Custom Ad"
    }

    private func addSubviews() {
        view.addSubview(adView)
        view.addSubview(loadButton)
        view.addSubview(stateLabel)
    }

    private func setupConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            adView.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: -10),
            adView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            adView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            adView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -10),
            
            stateLabel.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 10),
            stateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            stateLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}

// MARK: - YMANativeAdDelegate

extension NativeBulkViewController: NativeAdDelegate {
    func nativeAdDidClick(_ ad: NativeAd) {
        print(#function)
    }

    func nativeAdWillLeaveApplication(_ ad: NativeAd) {
        print(#function)
    }

    func nativeAd(_ ad: NativeAd, willPresentScreen viewController: UIViewController?) {
        print(#function)
    }

    func nativeAd(_ ad: NativeAd, didTrackImpressionWith impressionData: ImpressionData?) {
        print(#function)
    }

    func nativeAd(_ ad: NativeAd, didDismissScreen viewController: UIViewController?) {
        print(#function)
    }

    func close(_ ad: NativeAd) {
        print(#function)
    }
}

extension NativeBulkViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NativeBulkTableViewCell.reuseIdentifier, for: indexPath) as? NativeBulkTableViewCell else {
            return UITableViewCell()
        }
        cell.accessibilityIdentifier = CommonAccessibility.bannerCellView + "\(indexPath.row)"
        cell.bindNativeAd(ads[indexPath.row])
        return cell
    }
}

// MARK: - YMANativeAdDelegate

extension NativeBulkViewController: NativeBulkAdLoaderDelegate {
    func nativeBulkAdLoader(_ nativeBulkAdLoader: YandexMobileAds.NativeBulkAdLoader, didLoad ads: [YandexMobileAds.NativeAd]) {
        stateLabel.text = StateUtils.loaded()
        self.ads = ads
        adView.isHidden = false
        adView.reloadData()
    }
    
    func nativeBulkAdLoader(_ nativeBulkAdLoader: YandexMobileAds.NativeBulkAdLoader, didFailLoadingWithError error: Error) {
        stateLabel.text = StateUtils.loadError(error)
        print(#function)
    }
}
