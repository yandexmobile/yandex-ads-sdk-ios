/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class AppOpenAdController: UIViewController {
    private var appOpenAd: YMAAppOpenAd?
    private lazy var interstitialAdLoader: YMAAppOpenAdLoader = {
        let loader = YMAAppOpenAdLoader()
        loader.delegate = self
        return loader
    }()

    private lazy var showButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Show ad") { [weak self] _ in
                guard let self else { return }
                self.appOpenAd?.show(from: self)
                self.showButton.isEnabled = false
                self.statusLabel.text = "Ad is ready for presentation. Leave the application, then return to see the ad."
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Show ad", for: .normal)
        button.isEnabled = false
        return button
    }()

    private lazy var loadButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Load ad") { [weak self] _ in
                guard let self else { return }

                // Replace demo-appopenad-direct with actual Ad Unit ID
                let configuration = YMAAdRequestConfiguration(adUnitID: "demo-appopenad-direct")
                self.appOpenAdLoader.loadAd(with: configuration)
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Load ad", for: .normal)
        return button
    }()

    private lazy var statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.numberOfLines = 0
        label.text = "Ad is not loaded."
        return label
    }()

    private var messageDescription: String {
        "AppOpenAd with Unit ID: \(String(describing: appOpenAd?.adInfo?.adUnitId))"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupConstraints()
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .white
        title = "AppOpenAd"
    }

    private func addSubviews() {
        view.addSubview(loadButton)
        view.addSubview(showButton)
        view.addSubview(statusLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            loadButton.trailingAnchor.constraint(equalTo: view.centerXAnchor, constant: -20),

            showButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            showButton.leadingAnchor.constraint(equalTo: view.centerXAnchor, constant: 20),

            statusLabel.topAnchor.constraint(equalTo: showButton.bottomAnchor, constant: 50),
            statusLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - YMAAppOpenAdLoaderDelegate

extension AppOpenAdController: YMAAppOpenAdLoaderDelegate {
    func appOpenAdLoader(_ adLoader: YMAAppOpenAdLoader, didLoad appOpenAd: YMAAppOpenAd) {
        self.appOpenAd = appOpenAd
        self.appOpenAd.delegate = self
        showButton.isEnabled = true
        statusLabel.text = "Ad is loaded."
        print("\(messageDescription) loaded")
    }

    func appOpenAdLoader(_ adLoader: YMAAppOpenAdLoader, didFailToLoadWithError error: YMAAdRequestError) {
        let id = error.adUnitId
        let error = error.error
        statusLabel.text = "Ad failed to load."
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
    }
}

// MARK: - YMAAppOpenAdDelegate

extension AppOpenAdController: YMAAppOpenAdDelegate {
    func appOpenAd(_ appOpenAd: YMAAppOpenAd, didFailToShowWithError error: Error) {
        statusLabel.text = "Ad failed to show."
        print("\(messageDescription) failed to show. Error: \(error)")
    }

    func appOpenAdDidShow(_ appOpenAd: YMAAppOpenAd) {
        print("\(messageDescription) did show")
    }

    func appOpenAdDidDismiss(_ appOpenAd: YMAAppOpenAd) {
        statusLabel.text = "Ad is not loaded."
        print("\(messageDescription) did dismiss")
    }

    func appOpenAdDidClick(_ appOpenAd: YMAAppOpenAd) {
        print("\(messageDescription) did click")
    }

    func appOpenAd(_ appOpenAd: YMAAppOpenAd, didTrackImpressionWithData impressionData: YMAImpressionData?) {
        print("\(messageDescription) did track impression")
    }
}
