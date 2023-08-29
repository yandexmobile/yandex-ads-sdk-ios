/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAdsInstream

final class InstreamInrollsViewController: UIViewController {
    private enum Constants {
        static let smallMargin: CGFloat = 8
        static let bigMargin: CGFloat = 20
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

    private lazy var startButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Start playback") { [weak self] _ in
                self?.startPlayback()
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start playback", for: .normal)
        return button
    }()

    private lazy var playInrollButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Play inroll") { [weak self] _ in
                self?.inrollsPlaybackController?.playInroll()
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Play inroll", for: .normal)
        return button
    }()

    private lazy var pauseInrollButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Pause inroll") { [weak self] _ in
                self?.inrollsPlaybackController?.pauseInroll()
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Pause inroll", for: .normal)
        return button
    }()

    private lazy var resumeInrollButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Resume inroll") { [weak self] _ in
                self?.inrollsPlaybackController?.resumeInroll()
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Resume inroll", for: .normal)
        return button
    }()

    private let topButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constants.smallMargin
        return stack
    }()

    private let bottomButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constants.smallMargin
        stack.distribution = .fillProportionally
        return stack
    }()

    private let buttonsStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.smallMargin
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
        adPlayer.prepareVideo()
        return adPlayer
    }()

    private var inrollsPlaybackController: InrollsPlaybackController?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupConstraints()
    }

    // MARK: - Ad

    private func loadAd() {
        // Replace demo-instream-yandex with actual Ad Unit ID
        let configuration = InstreamAdRequestConfiguration(pageID: "demo-instream-yandex")
        loader.loadInstreamAd(configuration: configuration)
    }

    private func startPlayback() {
        contentPlayer.resumeVideo()
        inrollsPlaybackController?.startPlayback()
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .white
        title = "Instream Inrolls"
    }

    private func addSubviews() {
        view.addSubview(buttonsStack)
        buttonsStack.addArrangedSubview(topButtonsStack)
        buttonsStack.addArrangedSubview(bottomButtonsStack)
        topButtonsStack.addArrangedSubview(loadButton)
        topButtonsStack.addArrangedSubview(startButton)
        bottomButtonsStack.addArrangedSubview(playInrollButton)
        bottomButtonsStack.addArrangedSubview(pauseInrollButton)
        bottomButtonsStack.addArrangedSubview(resumeInrollButton)
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
            buttonsStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.bigMargin),
            buttonsStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -Constants.bigMargin),

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

extension InstreamInrollsViewController: InstreamAdLoaderDelegate {
    func instreamAdLoader(_ instreamAdLoader: InstreamAdLoader, didLoad ad: InstreamAd) {
        print(#function)
        let inrollQueue = InrollQueueProvider(ad: ad).queue()
        inrollsPlaybackController = InrollsPlaybackController(
            adView: instreamAdView,
            videoPlayer: contentPlayer,
            adPlayer: adPlayer,
            inrollQueue: inrollQueue
        )
    }

    func instreamAdLoader(_ instreamAdLoader: InstreamAdLoader, didFailToLoad reason: String) {
        print(#function + "Error: \(reason)")
    }
}
