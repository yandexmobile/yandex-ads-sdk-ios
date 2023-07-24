/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class RewardedAdViewController: UIViewController {
    private lazy var rewardedAd: YMARewardedAd = {
        // Replace demo-rewarded-yandex with actual Ad Unit ID
        let rewardedAd = YMARewardedAd(adUnitID: "demo-rewarded-yandex")
        rewardedAd.delegate = self
        return rewardedAd
    }()

    private lazy var presentButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Present ad") { [weak self] _ in
                guard let self else { return }
                self.rewardedAd.present(from: self)
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
                self?.rewardedAd.load()
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

    // MARK: - Ad

    private func giveReward(_ reward: YMAReward) {
        let alertController = UIAlertController(
            title: "Reward",
            message: "Rewarded ad did reward: \(reward.amount) \(reward.type)",
            preferredStyle: .alert)
        alertController.addAction(.init(title: "Ok", style: .default))
        presentedViewController?.present(alertController, animated: true, completion: nil)
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
}

extension RewardedAdViewController: YMARewardedAdDelegate {
    func rewardedAd(_ rewardedAd: YMARewardedAd, didReward reward: YMAReward) {
        print(#function)
        giveReward(reward)
    }

    func rewardedAdDidLoad(_ rewardedAd: YMARewardedAd) {
        print(#function)
        presentButton.isEnabled = true
    }

    func rewardedAdDidFail(toLoad rewardedAd: YMARewardedAd, error: Error) {
        print(#function + "Error: \(error)")
    }

    func rewardedAdDidClick(_ rewardedAd: YMARewardedAd) {
        print(#function)
    }

    func rewardedAd(_ rewardedAd: YMARewardedAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print(#function)
    }

    func rewardedAdWillLeaveApplication(_ rewardedAd: YMARewardedAd) {
        print(#function)
    }

    func rewardedAdDidFail(toPresent rewardedAd: YMARewardedAd, error: Error) {
        print(#function + "Error: \(error)")
    }

    func rewardedAdWillAppear(_ rewardedAd: YMARewardedAd) {
        print(#function)
    }

    func rewardedAdDidAppear(_ rewardedAd: YMARewardedAd) {
        print(#function)
    }

    func rewardedAdWillDisappear(_ rewardedAd: YMARewardedAd) {
        print(#function)
    }

    func rewardedAdDidDisappear(_ rewardedAd: YMARewardedAd) {
        print(#function)
    }

    func rewardedAd(_ rewardedAd: YMARewardedAd, willPresentScreen viewController: UIViewController?) {
        print(#function)
    }
}
