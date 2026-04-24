import UIKit
import YandexMobileAdsInstream

final class YandexAdBreaksAdapter: NSObject, UnifiedAdProtocol {
    var onEvent: ((UnifiedAdEvent) -> Void)?
    var inlineView: UIView? { containerView }

    // MARK: Private

    private let pageID: String
    private let loader = InstreamAdLoader()
    private var adBreaksController: AdBreaksPlaybackController?

    private lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var instreamAdView: InstreamAdView = {
        let view = InstreamAdView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var playerView: PlayerView = {
        let view = PlayerView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var startButton = makeButton(
        title: "Start playback",
        id: YandexInstreamAccessibility.startPlaybackButton
    ) { [weak self] in
        guard let self else { return }
        self.contentPlayer.resumeVideo()
        self.adBreaksController?.startPlayback()
    }

    private lazy var playInrollButton = makeButton(
        title: "Play inroll",
        id: YandexInstreamAccessibility.playInrollButton
    ) { [weak self] in
        self?.adBreaksController?.playInroll()
    }

    private lazy var pauseInrollButton = makeButton(
        title: "Pause",
        id: YandexInstreamAccessibility.pauseInrollButton
    ) { [weak self] in
        self?.adBreaksController?.pauseInroll()
    }

    private lazy var resumeInrollButton = makeButton(
        title: "Resume",
        id: YandexInstreamAccessibility.resumeInrollButton
    ) { [weak self] in
        self?.adBreaksController?.resumeInroll()
    }

    private lazy var adPlayer: AdPlayer = {
        let provider = VideoPlayerProvider<AdPlayer>(maxSize: 1)
        let player = AdPlayer(playerProvider: provider)
        player.bind(to: playerView)
        return player
    }()

    private lazy var contentPlayer: ContentPlayer = {
        let provider = VideoPlayerProvider<ContentPlayer>(maxSize: 1)
        let player = ContentPlayer(playerProvider: provider, url: InstreamContent.sampleVideoUrl)
        player.bind(to: playerView)
        player.prepareVideo()
        return player
    }()

    // MARK: Init

    init(pageID: String) {
        self.pageID = pageID
        super.init()
        buildUI()
    }

    func load() {
        let config = InstreamAdRequestConfiguration(pageID: pageID)
        loader.loadInstreamAd(configuration: config) { [weak self] result in
            switch result {
            case .success(let ad):
                self?.handleAdLoaded(ad)
            case .failure(let info):
                self?.handleAdLoadingFailed(info)
            }
        }
        print("InrollsAdapter: loading started for pageID: \(pageID)")
    }
    
    private func handleAdLoaded(_ ad: InstreamAd) {
        let controller = AdBreaksPlaybackController(
            adView: instreamAdView,
            videoPlayer: contentPlayer,
            adPlayer: adPlayer,
            adBreaks: ad.adBreaks
        )
        controller.delegate = self
        adBreaksController = controller

        [startButton, playInrollButton, pauseInrollButton, resumeInrollButton].forEach { $0.isEnabled = true }
        onEvent?(.loaded)
        print(makeMessageDescription("ad loaded successfully"))
    }
    
    private func handleAdLoadingFailed(_ info: InstreamAdLoadingFailureInfo) {
        let error = NSError(domain: "Inroll", code: 0,
                            userInfo: [NSLocalizedDescriptionKey: info.reason])
        onEvent?(.failedToLoad(error))
        print(makeMessageDescription("failed to load ad. Reason: \(info.reason)"))
    }

    func tearDown() {
        adBreaksController = nil
        for item in [startButton, playInrollButton, pauseInrollButton, resumeInrollButton] {
            item.isEnabled = false
        }
        print("InrollsAdapter: torn down")
    }

    // MARK: Helpers

    private func makeButton(title: String, id: String, action: @escaping () -> Void) -> UIButton {
        var config = UIButton.Configuration.tinted()
        config.title = title
        let button = UIButton(configuration: config, primaryAction: UIAction { _ in action() })
        button.isEnabled = false
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.accessibilityIdentifier = id
        return button
    }

    private func buildUI() {
        containerView.addSubview(instreamAdView)
        instreamAdView.addSubview(playerView)

        let topRow = UIStackView(arrangedSubviews: [startButton, playInrollButton])
        topRow.axis = .horizontal
        topRow.spacing = 8
        topRow.distribution = .fillEqually

        let bottomRow = UIStackView(arrangedSubviews: [pauseInrollButton, resumeInrollButton])
        bottomRow.axis = .horizontal
        bottomRow.spacing = 8
        bottomRow.distribution = .fillEqually

        let buttonsColumn = UIStackView(arrangedSubviews: [topRow, bottomRow])
        buttonsColumn.axis = .vertical
        buttonsColumn.spacing = 8
        buttonsColumn.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(buttonsColumn)

        NSLayoutConstraint.activate([
            instreamAdView.topAnchor.constraint(equalTo: containerView.topAnchor),
            instreamAdView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            instreamAdView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            instreamAdView.heightAnchor.constraint(equalTo: instreamAdView.widthAnchor, multiplier: 9.0 / 16.0),

            playerView.topAnchor.constraint(equalTo: instreamAdView.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: instreamAdView.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: instreamAdView.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: instreamAdView.bottomAnchor),

            buttonsColumn.topAnchor.constraint(equalTo: instreamAdView.bottomAnchor, constant: 12),
            buttonsColumn.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            buttonsColumn.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            buttonsColumn.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -12),
        ])
    }

    private func makeMessageDescription(_ context: String) -> String {
        return "InrollsAdapter: \(context)"
    }
}

// MARK: - AdBreaksPlaybackControllerDelegate

extension YandexAdBreaksAdapter: AdBreakPlaybackControllerDelegate {
    func adBreaksPlaybackController(_: AdBreaksPlaybackController, didPrepare _: InstreamAdBreak) {
        onEvent?(.impression)
        print(makeMessageDescription("ad break prepared"))
    }

    func adBreaksPlaybackController(_: AdBreaksPlaybackController, didStart _: InstreamAdBreak) {
        onEvent?(.shown)
        print(makeMessageDescription("ad break started"))
    }

    func adBreaksPlaybackController(_: AdBreaksPlaybackController, didComplete _: InstreamAdBreak) {
        onEvent?(.dismissed)
        print(makeMessageDescription("ad break completed"))
    }

    func adBreaksPlaybackController(_: AdBreaksPlaybackController, didFail _: InstreamAdBreak) {
        let error = NSError(domain: "Inroll", code: 1)
        onEvent?(.failedToShow(error))
        print(makeMessageDescription("ad break failed to show"))
    }
}
