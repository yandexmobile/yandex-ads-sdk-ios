/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class RewardedAdViewController: UIViewController {
    private var rewardedAd: RewardedAd?
    private lazy var rewardedAdLoader: RewardedAdLoader = {
        let loader = RewardedAdLoader()
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

                // Replace demo-rewarded-yandex with actual Ad Unit ID
                let configuration = AdRequestConfiguration(adUnitID: "demo-rewarded-yandex")
                self.rewardedAdLoader.loadAd(with: configuration)

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
        title = "Rewarded Ad"
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

    private func makeMessageDescription(_ rewardedAd: RewardedAd) -> String {
        "Rewarded Ad with Unit ID: \(String(describing: rewardedAd.adInfo?.adUnitId))"
    }
}

// MARK: - YMARewardedAdLoaderDelegate

extension RewardedAdViewController: RewardedAdLoaderDelegate {
    func rewardedAdLoader(_ adLoader: RewardedAdLoader, didLoad rewardedAd: RewardedAd) {
        self.rewardedAd = rewardedAd
        self.rewardedAd?.delegate = self
        presentButton.isEnabled = true
        stateLabel.text = StateUtils.loaded()
        print("\(makeMessageDescription(rewardedAd))) loaded")
    }

    func rewardedAdLoader(_ adLoader: RewardedAdLoader, didFailToLoadWithError error: AdRequestError) {
        let id = error.adUnitId
        let error = error.error
        print("Loading failed for Ad with Unit ID: \(String(describing: id)). Error: \(String(describing: error))")
        stateLabel.text = StateUtils.loadError(error)
    }
}

// MARK: - YMARewardedAdDelegate

extension RewardedAdViewController: RewardedAdDelegate {
    func rewardedAd(_ rewardedAd: RewardedAd, didReward reward: Reward) {
        let message = "\(makeMessageDescription(rewardedAd)) did reward: \(reward.amount) \(reward.type)"
        let alertController = UIAlertController(title: "Reward", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel, handler: nil))
        presentedViewController?.present(alertController, animated: true, completion: nil)
        print(message)
    }

    func rewardedAd(_ rewardedAd: RewardedAd, didFailToShowWithError error: Error) {
        print("\(makeMessageDescription(rewardedAd)) failed to show. Error: \(error)")
    }

    func rewardedAdDidShow(_ rewardedAd: RewardedAd) {
        print("\(makeMessageDescription(rewardedAd)) did show")
    }

    func rewardedAdDidDismiss(_ rewardedAd: RewardedAd) {
        print("\(makeMessageDescription(rewardedAd)) did dismiss")
    }

    func rewardedAdDidClick(_ rewardedAd: RewardedAd) {
        print("\(makeMessageDescription(rewardedAd)) did click")
    }

    func rewardedAd(_ rewardedAd: RewardedAd, didTrackImpressionWith impressionData: ImpressionData?) {
        print("\(makeMessageDescription(rewardedAd)) did track impression")
    }
}
