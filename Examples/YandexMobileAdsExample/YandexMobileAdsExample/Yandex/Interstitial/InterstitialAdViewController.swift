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
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Present ad", for: .normal)
        button.isEnabled = false
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
        title = "Interstitial Ad"
    }

    private func addSubviews() {
        view.addSubview(loadButton)
        view.addSubview(presentButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            loadButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),

            presentButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            presentButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20)
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
        print("\(makeMessageDescription(interstitialAd)) loaded")
    }

    func interstitialAdLoader(_ adLoader: YMAInterstitialAdLoader, didFailToLoadWithError error: YMAAdRequestError) {
        let id = error.adUnitId
        let error = error.error
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
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
