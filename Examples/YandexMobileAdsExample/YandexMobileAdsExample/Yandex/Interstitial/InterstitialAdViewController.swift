/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class InterstitialAdViewController: UIViewController {
    private var interstitialAd: YMAInterstitialAd?
    private var presentButton: UIButton?

    override func viewDidLayoutSubviews() {
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        createRewardedAd()
    }

    // MARK: - Ad

    private func createRewardedAd() {
        // Replace demo-interstitial-yandex with actual Ad Unit ID
        interstitialAd = YMAInterstitialAd(adUnitID: "demo-interstitial-yandex")
        interstitialAd?.delegate = self
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .white
        title = "Interstitial Ad"

        setupLoadButton()
        setupPresentButton()
    }

    private func setupLoadButton() {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Load ad") { [weak self] _ in
                self?.interstitialAd?.load()
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Load ad", for: .normal)
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            button.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: -20)
        ])
    }

    private func setupPresentButton() {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Present ad") { [weak self] _ in
                guard let self else { return }
                self.interstitialAd?.present(from: self)
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Present ad", for: .normal)
        button.isEnabled = false
        view.addSubview(button)

        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 100),
            button.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor, constant: 20)
        ])
        presentButton = button
    }
}

extension InterstitialAdViewController: YMAInterstitialAdDelegate {
    func interstitialAdDidLoad(_ interstitialAd: YMAInterstitialAd) {
        print(#function)
        presentButton?.isEnabled = true
    }

    func interstitialAdDidFail(toLoad interstitialAd: YMAInterstitialAd, error: Error) {
        print(#function + "Error: \(error)")
    }

    func interstitialAdDidClick(_ interstitialAd: YMAInterstitialAd) {
        print(#function)
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print(#function)
    }

    func interstitialAdWillLeaveApplication(_ interstitialAd: YMAInterstitialAd) {
        print(#function)
    }

    func interstitialAdDidFail(toPresent interstitialAd: YMAInterstitialAd, error: Error) {
        print(#function + "Error: \(error)")
    }

    func interstitialAdWillAppear(_ interstitialAd: YMAInterstitialAd) {
        print(#function)
    }

    func interstitialAdDidAppear(_ interstitialAd: YMAInterstitialAd) {
        print(#function)
    }

    func interstitialAdWillDisappear(_ interstitialAd: YMAInterstitialAd) {
        print(#function)
    }

    func interstitialAdDidDisappear(_ interstitialAd: YMAInterstitialAd) {
        print(#function)
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, willPresentScreen webBrowser: UIViewController?) {
        print(#function)
    }
}
