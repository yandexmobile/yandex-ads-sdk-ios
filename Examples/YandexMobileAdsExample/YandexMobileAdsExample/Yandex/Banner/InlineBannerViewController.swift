/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class InlineBannerViewController: UIViewController {
    private lazy var adView: YMAAdView = {
        let adSize = YMABannerAdSize.inlineSize(withWidth: 320, maxHeight: 320)
        
        // Replace demo demo-banner-yandex with actual Ad Unit ID
        let adView = YMAAdView(adUnitID: "demo-banner-yandex", adSize: adSize)
        adView.delegate = self
        adView.translatesAutoresizingMaskIntoConstraints = false
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
        return button
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
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 100),
            adView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            loadButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}

extension InlineBannerViewController: YMAAdViewDelegate {
    func adViewDidLoad(_ adView: YMAAdView) {
        print(#function)
    }

    func adViewDidClick(_ adView: YMAAdView) {
        print(#function)
    }

    func adView(_ adView: YMAAdView, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print(#function)
    }

    func adViewDidFailLoading(_ adView: YMAAdView, error: Error) {
        print(#function + "Error: \(error)")
    }

    func adViewWillLeaveApplication(_ adView: YMAAdView) {
        print(#function)
    }

    func adView(_ adView: YMAAdView, willPresentScreen viewController: UIViewController?) {
        print(#function)
    }

    func adView(_ adView: YMAAdView, didDismissScreen viewController: UIViewController?) {
        print(#function)
    }
}
