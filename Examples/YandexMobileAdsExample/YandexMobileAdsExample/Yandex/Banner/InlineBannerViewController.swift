/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class InlineBannerViewController: UIViewController {
    private lazy var adView: AdView = {
        let adSize = BannerAdSize.inlineSize(withWidth: 320, maxHeight: 320)
        
        // Replace demo demo-banner-yandex with actual Ad Unit ID
        let adView = AdView(adUnitID: "demo-banner-yandex", adSize: adSize)
        adView.delegate = self
        adView.translatesAutoresizingMaskIntoConstraints = false
        adView.accessibilityIdentifier = CommonAccessibility.bannerView
        return adView
    }()

    private lazy var loadButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Load ad") { [weak self] _ in
                self?.adView.loadAd()
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupConstraints()
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .white
        title = "Inline Banner"
    }

    private func addSubviews() {
        view.addSubview(adView)
        view.addSubview(loadButton)
        view.addSubview(stateLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            adView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            adView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            loadButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            loadButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stateLabel.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 10),
            stateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
}

extension InlineBannerViewController: AdViewDelegate {
    func adViewDidLoad(_ adView: AdView) {
        stateLabel.text = StateUtils.loaded()
        print(#function)
    }

    func adViewDidClick(_ adView: AdView) {
        print(#function)
    }

    func adView(_ adView: AdView, didTrackImpression impressionData: ImpressionData?) {
        print(#function)
    }

    func adViewDidFailLoading(_ adView: AdView, error: Error) {
        let text = StateUtils.loadError(error)
        stateLabel.text = text
        print(#function + text)
    }

    func adViewWillLeaveApplication(_ adView: AdView) {
        print(#function)
    }

    func adView(_ adView: AdView, willPresentScreen viewController: UIViewController?) {
        print(#function)
    }

    func adView(_ adView: AdView, didDismissScreen viewController: UIViewController?) {
        print(#function)
    }
}
