/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class AppOpenAdViewController: UIViewController {
    private lazy var loadButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Load Ad") { [weak self] _ in
                guard let self else { return }
                AppOpenAdController.shared.loadAd()
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Load Ad", for: .normal)
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

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupConstraints()
        AppOpenAdController.shared.delegate = self
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .white
        title = "App Open Ad"
    }

    private func addSubviews() {
        view.addSubview(loadButton)
        view.addSubview(statusLabel)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            loadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            statusLabel.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 50),
            statusLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            statusLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
}

// MARK: - AppOpenAdControllerDelegate

extension AppOpenAdViewController: AppOpenAdControllerDelegate {
    func appOpenAdControllerDidLoad(_ appOpenAdController: AppOpenAdController) {
        statusLabel.text = "Ad is ready for presentation. Leave the application, then return to see the ad."
    }

    func appOpenAdControllerDidDismiss(_ appOpenAdController: AppOpenAdController) {
        statusLabel.text = "Ad is not loaded."
    }

    func appOpenAdController(_ appOpenAdController: AppOpenAdController, didFailToLoadWithError error: Error) {
        statusLabel.text = "Ad failed to load."
    }

    func appOpenAdController(_ appOpenAdController: AppOpenAdController, didFailToShowWithError error: Error) {
        statusLabel.text = "Ad failed to show."
    }
}
