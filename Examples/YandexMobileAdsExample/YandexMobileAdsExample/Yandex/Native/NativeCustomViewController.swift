/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class NativeCustomViewController: UIViewController {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let adView: NativeCustomAdView = {
        let adView = NativeCustomAdView()
        adView.translatesAutoresizingMaskIntoConstraints = false
        adView.isHidden = true
        adView.accessibilityIdentifier = CommonAccessibility.bannerView
        return adView
    }()

    private lazy var loadButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Load ad") { [weak self] _ in
                self?.loadNativeAd()
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Load ad", for: .normal)
        button.accessibilityIdentifier = CommonAccessibility.loadButton
        return button
    }()
    
    private lazy var setCustomControlsButton: UIButton = {
        let button = UIButton(
            configuration: .tinted(),
            primaryAction: UIAction(title: "Set custom controls") { [weak self] _ in
                self?.setCustomControls()
            }
        )
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Set custom controls", for: .normal)
        return button
    }()
    
    private lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.accessibilityIdentifier = CommonAccessibility.stateLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var adLoader: NativeAdLoader = {
        let adLoader = NativeAdLoader()
        adLoader.delegate = self
        return adLoader
    }()
    
    private lazy var videoProgressControl: NativeVideoProgressControlView = {
        let progressControl = NativeVideoProgressControlView()
        progressControl.translatesAutoresizingMaskIntoConstraints = false
        return progressControl
    }()
    
    private lazy var videoMuteControl: NativeVideoMuteControlView = {
        let muteControl = NativeVideoMuteControlView()
        muteControl.translatesAutoresizingMaskIntoConstraints = false
        return muteControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        addSubviews()
        setupConstraints()
    }

    // MARK: - Ad

    private func loadNativeAd() {
        // Replace demo-native-video-yandex with actual Ad Unit ID
        let requestConfiguration = NativeAdRequestConfiguration(adUnitID: "demo-native-video-yandex")
        adLoader.loadAd(with: requestConfiguration)
        stateLabel.text = nil
    }

    private func bindNativeAd(_ ad: NativeAd) {
        ad.delegate = self
        do {
            try ad.bind(with: adView)
            adView.isHidden = false
            adView.callToActionButton?.accessibilityIdentifier = "call"
        } catch {
            print("Binding error: \(error)")
        }
    }

    // MARK: - UI

    private func setupUI() {
        view.backgroundColor = .white
        title = "Native Custom Ad"
    }

    private func addSubviews() {
        view.addSubview(scrollView)
        
        scrollView.addSubview(contentView)
        contentView.addSubview(loadButton)
        contentView.addSubview(setCustomControlsButton)
        contentView.addSubview(stateLabel)
        contentView.addSubview(adView)
    }

    private func setupConstraints() {
        let layoutGuide = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            loadButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            loadButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            setCustomControlsButton.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 10),
            setCustomControlsButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

            stateLabel.topAnchor.constraint(equalTo: setCustomControlsButton.bottomAnchor, constant: 10),
            stateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            stateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            adView.topAnchor.constraint(greaterThanOrEqualTo: stateLabel.bottomAnchor, constant: 50),
            adView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            adView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            adView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
        ])

        let contentViewHeightConstraint = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        contentViewHeightConstraint.priority = .defaultLow
        contentViewHeightConstraint.isActive = true
    }
    
    private func setCustomControls() {
        guard let mediaView = adView.mediaView else {
            return
        }
        let playbackControls = NativeVideoPlaybackControls(
            progressControl: videoProgressControl,
            muteControl: videoMuteControl
        )
        playbackControls.setupVideoPlaybackControls(to: mediaView)
        addPlaybackControlView(mediaView: mediaView)
    }
    
    private func addPlaybackControlView(mediaView: UIView) {
        mediaView.addSubview(videoMuteControl)
        mediaView.addSubview(videoProgressControl)
        
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            videoProgressControl.leadingAnchor.constraint(equalTo: mediaView.leadingAnchor),
            videoProgressControl.trailingAnchor.constraint(equalTo: mediaView.trailingAnchor),
            videoProgressControl.bottomAnchor.constraint(equalTo: mediaView.bottomAnchor),
            videoProgressControl.heightAnchor.constraint(equalToConstant: 6),
            
            videoMuteControl.leadingAnchor.constraint(equalTo: mediaView.leadingAnchor),
            videoMuteControl.topAnchor.constraint(equalTo: mediaView.topAnchor),
        ])
    }
}

// MARK: - YMANativeAdLoaderDelegate

extension NativeCustomViewController: NativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: NativeAdLoader, didLoad ad: NativeAd) {
        print(#function)
        bindNativeAd(ad)
        stateLabel.text = StateUtils.loaded()
    }

    func nativeAdLoader(_ loader: NativeAdLoader, didFailLoadingWithError error: Error) {
        print(#function + "Error: \(error)")
        stateLabel.text = StateUtils.loadError(error)
    }
}

// MARK: - YMANativeAdDelegate

extension NativeCustomViewController: NativeAdDelegate {
    func nativeAdDidClick(_ ad: NativeAd) {
        print(#function)
    }

    func nativeAdWillLeaveApplication(_ ad: NativeAd) {
        print(#function)
    }

    func nativeAd(_ ad: NativeAd, willPresentScreen viewController: UIViewController?) {
        print(#function)
    }

    func nativeAd(_ ad: NativeAd, didTrackImpressionWith impressionData: ImpressionData?) {
        print(#function)
    }

    func nativeAd(_ ad: NativeAd, didDismissScreen viewController: UIViewController?) {
        print(#function)
    }

    func close(_ ad: NativeAd) {
        print(#function)
    }
}
