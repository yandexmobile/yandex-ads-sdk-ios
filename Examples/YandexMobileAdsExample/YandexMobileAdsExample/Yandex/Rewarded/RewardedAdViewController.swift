/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class RewardedAdViewController: UIViewController {
    private var rewardedAd: YMARewardedAd?
    private var presentButton: UIButton?

    override func viewDidLayoutSubviews() {
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        createRewardedAd()
    }

    // MARK: - Ad

    private func createRewardedAd() {
        // Replace demo-rewarded-yandex with actual Ad Unit ID
        rewardedAd = YMARewardedAd(adUnitID: "demo-rewarded-yandex")
        rewardedAd?.delegate = self
    }

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

        setupLoadButton()
        setupPresentButton()
    }

    private func setupLoadButton() {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Load ad") { [weak self] _ in
                self?.rewardedAd?.load()
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
                self.rewardedAd?.present(from: self)
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

extension RewardedAdViewController: YMARewardedAdDelegate {
    func rewardedAd(_ rewardedAd: YMARewardedAd, didReward reward: YMAReward) {
        print(#function)
        giveReward(reward)
    }

    func rewardedAdDidLoad(_ rewardedAd: YMARewardedAd) {
        print(#function)
        presentButton?.isEnabled = true
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
