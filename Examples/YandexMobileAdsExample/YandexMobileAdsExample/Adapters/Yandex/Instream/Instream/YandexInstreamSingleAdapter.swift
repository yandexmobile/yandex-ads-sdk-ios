import UIKit
import YandexMobileAdsInstream

final class YandexInstreamSingleAdapter: NSObject, UnifiedAdProtocol {
    
    var onEvent: ((UnifiedAdEvent) -> Void)?
    var inlineView: UIView? { containerView }
    
    // MARK: Private
    
    private let pageID: String
    private let loader = InstreamAdLoader()
    private var adBinder: InstreamAdBinder?
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    private lazy var prepareButton: UIButton = makeButton(
        title: "Prepare ad",
        id: YandexInstreamAccessibility.prepareButton
    ) { [weak self] in
        self?.adBinder?.prepareAd()
        self?.printLog("prepareAd tapped")
    }
    
    private lazy var presentButton: UIButton = makeButton(
        title: "Present ad",
        id: YandexInstreamAccessibility.presentButton
    ) { [weak self] in
        guard let self else { return }
        self.adBinder?.bind(with: self.instreamAdView)
        self.printLog("bind (present) tapped")
        self.onEvent?(.shown)
    }
    
    private lazy var bottomStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [prepareButton, presentButton])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var adPlayer: AdPlayer = {
        let videoProvider = VideoPlayerProvider<AdPlayer>(maxSize: 1)
        let adProvider = AdPlayer(playerProvider: videoProvider)
        adProvider.bind(to: playerView)
        return adProvider
    }()
    
    private lazy var contentPlayer: ContentPlayer = {
        let videoProvider = VideoPlayerProvider<ContentPlayer>(maxSize: 1)
        let adProvider = ContentPlayer(playerProvider: videoProvider, url: InstreamContent.sampleVideoUrl)
        adProvider.bind(to: playerView)
        adProvider.prepareVideo()
        return adProvider
    }()
    
    // MARK: Init
    
    init(pageID: String) {
        self.pageID = pageID
        super.init()
        loader.delegate = self
        buildUI()
    }
    
    func load() {
        let config = InstreamAdRequestConfiguration(pageID: pageID)
        loader.loadInstreamAd(configuration: config)
        printLog("load started, pageID=\(pageID)")
        setButtonsEnabled(false)
    }
    
    func tearDown() {
        adBinder?.unbind()
        adBinder?.invalidateAdPlayer()
        adBinder?.invalidateVideoPlayer()
        adBinder = nil
        setButtonsEnabled(false)
        printLog("torn down")
    }
    
    private func buildUI() {
        containerView.addSubview(instreamAdView)
        instreamAdView.addSubview(playerView)
        containerView.addSubview(bottomStack)
        
        NSLayoutConstraint.activate([
            instreamAdView.topAnchor.constraint(equalTo: containerView.topAnchor),
            instreamAdView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            instreamAdView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            instreamAdView.heightAnchor.constraint(equalTo: instreamAdView.widthAnchor, multiplier: 9.0/16.0),
            
            playerView.topAnchor.constraint(equalTo: instreamAdView.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: instreamAdView.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: instreamAdView.trailingAnchor),
            playerView.bottomAnchor.constraint(equalTo: instreamAdView.bottomAnchor),
            
            bottomStack.topAnchor.constraint(equalTo: instreamAdView.bottomAnchor, constant: 12),
            bottomStack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 12),
            bottomStack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -12),
            bottomStack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
        
        setButtonsEnabled(false)
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
    
    private func setButtonsEnabled(_ enabled: Bool) {
        prepareButton.isEnabled = enabled
        presentButton.isEnabled = enabled
    }
    
    private func printLog(_ message: String) {
        print("InstreamSingleAdapter: \(message)")
    }
}

// MARK: - InstreamAdLoaderDelegate

extension YandexInstreamSingleAdapter: InstreamAdLoaderDelegate {
    func instreamAdLoader(_ instreamAdLoader: InstreamAdLoader, didLoad ad: InstreamAd) {
        let binder = InstreamAdBinder(ad: ad, adPlayer: adPlayer, videoPlayer: contentPlayer)
        binder.delegate = self
        adBinder = binder
        setButtonsEnabled(true)
        onEvent?(.loaded)
        printLog("ad loaded successfully")
    }
    
    func instreamAdLoader(_ instreamAdLoader: InstreamAdLoader, didFailToLoad reason: String) {
        let err = NSError(domain: "Instream", code: 0, userInfo: [NSLocalizedDescriptionKey: reason])
        onEvent?(.failedToLoad(err))
        setButtonsEnabled(false)
        printLog("failed to load ad. reason=\(reason)")
    }
}

// MARK: - InstreamAdBinderDelegate

extension YandexInstreamSingleAdapter: InstreamAdBinderDelegate {
    func instreamAdBinder(_ binder: InstreamAdBinder, didPrepare instreamAd: InstreamAd) {
        onEvent?(.impression)
        printLog("ad prepared")
    }
    
    func instreamAdBinder(_ binder: InstreamAdBinder, didComplete instreamAd: InstreamAd) {
        onEvent?(.dismissed)
        printLog("ad completed")
    }
    
    func instreamAdBinder(_ binder: InstreamAdBinder, didFailToPlay instreamAd: InstreamAd, with error: Error) {
        onEvent?(.failedToShow(error))
        printLog("failed to play. error=\(error.localizedDescription)")
    }
}
