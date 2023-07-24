/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class NativeTemplateViewController: UIViewController {
    private let adView: YMANativeBannerView = {
        let adView = YMANativeBannerView()
        adView.translatesAutoresizingMaskIntoConstraints = false
        return adView
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
        return button
    }()

    private lazy var adLoader: YMANativeAdLoader = {
        let adLoader = YMANativeAdLoader()
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
        // Replace demo-native-content-yandex with actual Ad Unit ID
        let requestConfiguration = YMANativeAdRequestConfiguration(adUnitID: "demo-native-content-yandex")
        adLoader.loadAd(with: requestConfiguration)
    }

    private func bindNativeAd(_ ad: YMANativeAd) {
        ad.delegate = self
        adView.ad = ad
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .white
        title = "Native Template Ad"
    }

    private func addSubviews() {
        view.addSubview(adView)
        view.addSubview(loadButton)
    }

    private func setupConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            adView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            adView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            adView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -10)
        ])
    }
}

// MARK: - YMANativeAdLoaderDelegate

extension NativeTemplateViewController: YMANativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: YMANativeAdLoader, didLoad ad: YMANativeAd) {
        print(#function)
        bindNativeAd(ad)
    }

    func nativeAdLoader(_ loader: YMANativeAdLoader, didFailLoadingWithError error: Error) {
        print(#function + "Error: \(error)")
    }
}

// MARK: - YMANativeAdDelegate

extension NativeTemplateViewController: YMANativeAdDelegate {
    func nativeAdDidClick(_ ad: YMANativeAd) {
        print(#function)
    }

    func nativeAdWillLeaveApplication(_ ad: YMANativeAd) {
        print(#function)
    }

    func nativeAd(_ ad: YMANativeAd, willPresentScreen viewController: UIViewController?) {
        print(#function)
    }

    func nativeAd(_ ad: YMANativeAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print(#function)
    }

    func nativeAd(_ ad: YMANativeAd, didDismissScreen viewController: UIViewController?) {
        print(#function)
    }

    func close(_ ad: YMANativeAd) {
        print(#function)
    }
}

