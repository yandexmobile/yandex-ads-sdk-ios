/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class NativeTemplateViewController: UIViewController {
    private let adView: NativeBannerView = {
        let adView = NativeBannerView()
        adView.translatesAutoresizingMaskIntoConstraints = false
        adView.accessibilityIdentifier = CommonAccessibility.bannerView
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

    private lazy var adLoader: NativeAdLoader = {
        let adLoader = NativeAdLoader()
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
        let requestConfiguration = NativeAdRequestConfiguration(adUnitID: "demo-native-content-yandex")
        adLoader.loadAd(with: requestConfiguration)
        stateLabel.text = nil
    }

    private func bindNativeAd(_ ad: NativeAd) {
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
        view.addSubview(stateLabel)
    }

    private func setupConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            adView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            adView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            adView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -10),
            
            stateLabel.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 10),
            stateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }
}

// MARK: - YMANativeAdLoaderDelegate

extension NativeTemplateViewController: NativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: NativeAdLoader, didLoad ad: NativeAd) {
        print(#function)
        bindNativeAd(ad)
        stateLabel.text = StateUtils.loaded()
    }

    func nativeAdLoader(_ loader: NativeAdLoader, didFailLoadingWithError error: Error) {
        print(#function + "Error: \(error)")
        stateLabel.text = StateUtils.loadError(error)
    }
}

// MARK: - YMANativeAdDelegate

extension NativeTemplateViewController: NativeAdDelegate {
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

