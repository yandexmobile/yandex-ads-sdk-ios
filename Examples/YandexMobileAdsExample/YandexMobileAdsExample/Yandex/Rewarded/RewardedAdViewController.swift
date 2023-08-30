/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class RewardedAdViewController: UIViewController {
    private var rewardedAd: YMARewardedAd?
    private lazy var rewardedAdLoader: YMARewardedAdLoader = {
        let loader = YMARewardedAdLoader()
        loader.delegate = self
        return loader
    }()

    private lazy var presentButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Present ad") { [weak self] _ in
                guard let self else { return }
                self.rewardedAd?.show(from: self)
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

                // Replace demo-rewarded-yandex with actual Ad Unit ID
                let configuration = YMAAdRequestConfiguration(adUnitID: "demo-rewarded-yandex")
                self.rewardedAdLoader.loadAd(with: configuration)

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
        title = "Rewarded Ad"
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

    private func makeMessageDescription(_ rewardedAd: YMARewardedAd) -> String {
        "Rewarded Ad with Unit ID: \(String(describing: rewardedAd.adInfo?.adUnitId))"
    }
}

// MARK: - YMARewardedAdLoaderDelegate

extension RewardedAdViewController: YMARewardedAdLoaderDelegate {
    func rewardedAdLoader(_ adLoader: YMARewardedAdLoader, didLoad rewardedAd: YMARewardedAd) {
        self.rewardedAd = rewardedAd
        self.rewardedAd?.delegate = self
        presentButton.isEnabled = true
        print("\(makeMessageDescription(rewardedAd))) loaded")
    }

    func rewardedAdLoader(_ adLoader: YMARewardedAdLoader, didFailToLoadWithError error: YMAAdRequestError) {
        let id = error.adUnitId
        let error = error.error
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
    }
}

// MARK: - YMARewardedAdDelegate

extension RewardedAdViewController: YMARewardedAdDelegate {
    func rewardedAd(_ rewardedAd: YMARewardedAd, didReward reward: YMAReward) {
        let message = "\(makeMessageDescription(rewardedAd)) did reward: \(reward.amount) \(reward.type)"
        let alertController = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        presentedViewController?.present(alertController, animated: true, completion: nil)
        print(message)
    }

    func rewardedAd(_ rewardedAd: YMARewardedAd, didFailToShowWithError error: Error) {
        print("\(makeMessageDescription(rewardedAd)) failed to show. Error: \(error)")
    }

    func rewardedAdDidShow(_ rewardedAd: YMARewardedAd) {
        print("\(makeMessageDescription(rewardedAd)) did show")
    }

    func rewardedAdDidDismiss(_ rewardedAd: YMARewardedAd) {
        print("\(makeMessageDescription(rewardedAd)) did dismiss")
    }

    func rewardedAdDidClick(_ rewardedAd: YMARewardedAd) {
        print("\(makeMessageDescription(rewardedAd)) did click")
    }

    func rewardedAd(_ rewardedAd: YMARewardedAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print("\(makeMessageDescription(rewardedAd)) did track impression")
    }
}
