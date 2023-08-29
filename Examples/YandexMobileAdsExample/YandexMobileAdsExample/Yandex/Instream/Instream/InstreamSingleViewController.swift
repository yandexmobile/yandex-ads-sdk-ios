/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAdsInstream

final class InstreamSingleViewController: UIViewController {
    private enum Constants {
        static let margin: CGFloat = 8
        static let playerAspectRatio: CGFloat = 9 / 16
        static let numberOfPlayers = 1
    }

    private lazy var loadButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Load") { [weak self] _ in
                self?.loadAd()
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Load", for: .normal)
        return button
    }()

    private lazy var prepareButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Prepare ad") { [weak self] _ in
                self?.adBinder?.prepareAd()
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Prepare ad", for: .normal)
        return button
    }()

    private lazy var presentButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Present ad") { [weak self] _ in
                guard let self else { return }
                self.adBinder?.bind(with: self.instreamAdView)
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Present ad", for: .normal)
        return button
    }()

    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constants.margin
        return stack
    }()

    private let instreamAdView: InstreamAdView = {
        let view = InstreamAdView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let playerView: PlayerView = {
        let view = PlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var loader: InstreamAdLoader = {
        let loader = InstreamAdLoader()
        loader.delegate = self
        return loader
    }()

    private lazy var adPlayer: AdPlayer = {
        let provider = VideoPlayerProvider<AdPlayer>(maxSize: Constants.numberOfPlayers)
        let adPlayer = AdPlayer(playerProvider: provider)
        adPlayer.bind(to: playerView)
        return adPlayer
    }()

    private lazy var contentPlayer: ContentPlayer = {
        let provider = VideoPlayerProvider<ContentPlayer>(maxSize: Constants.numberOfPlayers)
        let adPlayer = ContentPlayer(playerProvider: provider, url: InstreamContent.sampleVideoUrl)
        adPlayer.bind(to: playerView)
        return adPlayer
    }()

    private var ad: InstreamAd?
    private var adBinder: InstreamAdBinder?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupConstraints()
    }

    deinit {
        adBinder?.unbind()
    }

    // MARK: - Ad

    private func loadAd() {
        // Replace demo-instream-yandex with actual Ad Unit ID
        let configuration = InstreamAdRequestConfiguration(pageID: "demo-instream-yandex")
        loader.loadInstreamAd(configuration: configuration)
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .white
        title = "Instream Single"
    }

    private func addSubviews() {
        view.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(loadButton)
        buttonsStack.addArrangedSubview(prepareButton)
        buttonsStack.addArrangedSubview(presentButton)
        view.addSubview(instreamAdView)
        instreamAdView.addSubview(playerView)
    }

    private func setupConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            buttonsStack.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: 100
            ),
            buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            instreamAdView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            instreamAdView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            instreamAdView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            instreamAdView.heightAnchor.constraint(
                equalTo: instreamAdView.widthAnchor,
                multiplier: Constants.playerAspectRatio
            ),
            playerView.leadingAnchor.constraint(equalTo: instreamAdView.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: instreamAdView.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: instreamAdView.bottomAnchor),
            playerView.topAnchor.constraint(equalTo: instreamAdView.topAnchor),
        ])
    }
}

// MARK: - InstreamAdLoaderDelegate

extension InstreamSingleViewController: InstreamAdLoaderDelegate {
    func instreamAdLoader(_ instreamAdLoader: InstreamAdLoader, didLoad ad: InstreamAd) {
        print(#function)
        self.ad = ad
        adBinder = InstreamAdBinder(ad: ad, adPlayer: adPlayer, videoPlayer: contentPlayer)
        adBinder?.delegate = self
    }

    func instreamAdLoader(_ instreamAdLoader: InstreamAdLoader, didFailToLoad reason: String) {
        print(#function + "Error: \(reason)")
    }
}

// MARK: - InstreamAdBinderDelegate

extension InstreamSingleViewController: InstreamAdBinderDelegate {
    func instreamAdBinder(
        _ binder: InstreamAdBinder,
        didComplete instreamAd: InstreamAd
    ) {
        print(#function)
    }

    func instreamAdBinder(
        _ binder: InstreamAdBinder,
        didPrepare instreamAd: InstreamAd
    ) {
        print(#function)
    }

    func instreamAdBinder(
        _ binder: InstreamAdBinder,
        didFailToPlay instreamAd: InstreamAd,
        with error: Error
    ) {
        print(#function + "Error: \(error)")
    }
}
