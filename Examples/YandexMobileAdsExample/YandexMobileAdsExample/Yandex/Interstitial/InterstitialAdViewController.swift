/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class InterstitialAdViewController: UIViewController {
    private lazy var interstitialAd: YMAInterstitialAd = {
        // Replace demo-interstitial-yandex with actual Ad Unit ID
        let ad = YMAInterstitialAd(adUnitID: "demo-interstitial-yandex")
        ad.delegate = self
        return ad
    }()

    private lazy var presentButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Present ad") { [weak self] _ in
                guard let self else { return }
                self.interstitialAd.present(from: self)
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
                self?.interstitialAd.load()
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
}

extension InterstitialAdViewController: YMAInterstitialAdDelegate {
    func interstitialAdDidLoad(_ interstitialAd: YMAInterstitialAd) {
        print(#function)
        presentButton.isEnabled = true
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
