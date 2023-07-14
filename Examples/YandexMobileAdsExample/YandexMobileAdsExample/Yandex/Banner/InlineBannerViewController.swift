/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class InlineBannerViewController: UIViewController {
    private var adView: YMAAdView?
    private var loadButton: UIButton?

    override func viewDidLayoutSubviews() {
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        createAdView()
        setupAdView()
    }

    // MARK: - Ad

    private func createAdView() {
        let adSize = YMAAdSize.inlineSize(withWidth: 320, maxHeight: 320)
        // Replace demo demo-banner-yandex with actual Ad Unit ID
        adView = YMAAdView(adUnitID: "demo-banner-yandex", adSize: adSize)
        adView?.delegate = self
    }

    private func setupAdView() {
        guard let adView, let loadButton else { return }
        adView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adView)

        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: loadButton.layoutMarginsGuide.bottomAnchor, constant: 100),
            adView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
        ])
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .white
        title = "Inline Banner"

        setupLoadButton()
    }

    private func setupLoadButton() {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Load ad") { [weak self] _ in
                self?.adView?.loadAd()
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Load ad", for: .normal)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            button.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor),
        ])
        loadButton = button
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
