/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class InterstitialAdViewController: UIViewController {
    private var interstitialAd: YMAInterstitialAd?
    private lazy var interstitialAdLoader: YMAInterstitialAdLoader = {
        let loader = YMAInterstitialAdLoader()
        loader.delegate = self
        return loader
    }()

    private lazy var presentButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Present ad") { [weak self] _ in
                guard let self else { return }
                self.interstitialAd?.show(from: self)
                self.presentButton.isEnabled = false
                self.presentedViewController?.view.accessibilityIdentifier = CommonAccessibility.bannerView
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Present ad", for: .normal)
        button.isEnabled = false
        button.accessibilityIdentifier = CommonAccessibility.presentButton
        return button
    }()

    private lazy var loadButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Load ad") { [weak self] _ in
                guard let self else { return }
                
                // Replace demo-interstitial-yandex with actual Ad Unit ID
                let configuration = YMAAdRequestConfiguration(adUnitID: "demo-interstitial-yandex")
                self.interstitialAdLoader.loadAd(with: configuration)
                self.stateLabel.text = nil
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
        title = "Interstitial Ad"
    }

    private func addSubviews() {
        view.addSubview(loadButton)
        view.addSubview(presentButton)
        view.addSubview(stateLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            loadButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),
            presentButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            presentButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),
            stateLabel.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 10),
            stateLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            stateLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
        ])
    }

    private func makeMessageDescription(_ interstitialAd: YMAInterstitialAd) -> String {
        "Interstitial Ad with Unit ID: \(String(describing: interstitialAd.adInfo?.adUnitId))"
    }
}

// MARK: - YMAInterstitialAdLoaderDelegate

extension InterstitialAdViewController: YMAInterstitialAdLoaderDelegate {
    func interstitialAdLoader(_ adLoader: YMAInterstitialAdLoader, didLoad interstitialAd: YMAInterstitialAd) {
        self.interstitialAd = interstitialAd
        self.interstitialAd?.delegate = self
        presentButton.isEnabled = true
        stateLabel.text = StateUtils.loaded()
        print("\(makeMessageDescription(interstitialAd)) loaded")
    }

    func interstitialAdLoader(_ adLoader: YMAInterstitialAdLoader, didFailToLoadWithError error: YMAAdRequestError) {
        let id = error.adUnitId
        let error = error.error
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
        stateLabel.text = StateUtils.loadError(error)
    }
}

// MARK: - YMARewardedAdDelegate

extension InterstitialAdViewController: YMAInterstitialAdDelegate {
    func interstitialAd(_ interstitialAd: YMAInterstitialAd, didFailToShowWithError error: Error) {
        print("\(makeMessageDescription(interstitialAd)) failed to show. Error: \(error)")
    }

    func interstitialAdDidShow(_ interstitialAd: YMAInterstitialAd) {
        print("\(makeMessageDescription(interstitialAd)) did show")
    }

    func interstitialAdDidDismiss(_ interstitialAd: YMAInterstitialAd) {
        print("\(makeMessageDescription(interstitialAd)) did dismiss")
    }

    func interstitialAdDidClick(_ interstitialAd: YMAInterstitialAd) {
        print("\(makeMessageDescription(interstitialAd)) did click")
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print("\(makeMessageDescription(interstitialAd)) did track impression")
    }
}
