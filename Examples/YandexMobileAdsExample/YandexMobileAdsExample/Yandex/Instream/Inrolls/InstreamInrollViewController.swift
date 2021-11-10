/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAdsInstream

private let numberOfPlayers = 1

class InstreamInrollViewController: UIViewController {
    @IBOutlet private var pageIdTextField: UITextField!
    @IBOutlet private var categoryIdTextField: UITextField!
    @IBOutlet private var parametersTextField: UITextField!
    @IBOutlet private var playerView: PlayerView!
    @IBOutlet private var adView: InstreamAdView!
    @IBOutlet private var contentProgressSlider: UISlider!
    @IBOutlet private var contentTimeLabel: UILabel!
    @IBOutlet private var toastLabel: UILabel!
    @IBOutlet private var playbackButton: UIButton!
    @IBOutlet private var playInrollButton: UIButton!
    @IBOutlet private var pauseInrollButton: UIButton!
    @IBOutlet private var resumeInrollButton: UIButton!

    private let loader = InstreamAdLoader()
    private let parametersParser = InstreamParametersParser()
    private let positionFormatter = InstreamAdBreakPositionFormatter()
    private let contentPlayerProvider = VideoPlayerProvider<ContentPlayer>(maxSize: numberOfPlayers)
    private let adPlayerProvider = VideoPlayerProvider<AdPlayer>(maxSize: numberOfPlayers)

    private var inrollsPlaybackController: InrollsPlaybackController?

    private var adPlayer: AdPlayer?
    private var contentPlayer: ContentPlayer?
    private var contentControlsController: ContentControlsController?

    override func viewDidLoad() {
        super.viewDidLoad()

        adPlayer = AdPlayer(playerProvider: adPlayerProvider)
        adPlayer?.bind(to: playerView)
        let contentPlayer = ContentPlayer(playerProvider: contentPlayerProvider, url: InstreamContent.sampleVideoUrl)
        self.contentPlayer = contentPlayer
        contentPlayer.bind(to: playerView)
        contentControlsController = ContentControlsController(
            player: contentPlayer,
            progressSlider: contentProgressSlider,
            timeLabel: contentTimeLabel
        )
        prepareVideo()
    }

    @IBAction func loadAd(_ sender: Any) {
        guard let pageId = pageIdTextField.text,
              let categoryId = categoryIdTextField.text,
              let parametersString = parametersTextField.text,
              let parameters = parametersParser.parseParameters(from: parametersString) else {
            presentAlert(title: "Error", message: "Can't parse request parameters")
            return
        }

        playInrollButton.isEnabled = false
        resumeInrollButton.isEnabled = false
        pauseInrollButton.isEnabled = false
        let configuration = InstreamAdRequestConfiguration(pageID: pageId,
                                                           categoryID: categoryId,
                                                           parameters: parameters)
        loader.delegate = self
        loader.loadInstreamAd(configuration: configuration)
    }

    @IBAction func startPlayback(_ sender: Any) {
        contentPlayer?.resumeVideo()
        inrollsPlaybackController?.startPlayback()
        view.endEditing(true)
        contentControlsController?.setupContentControls()
    }

    @IBAction func contentProgressDidChange(_: Any) {
        contentControlsController?.handleProgressChange()
    }

    @IBAction func playInroll(_ sender: Any) {
        inrollsPlaybackController?.playInroll()
    }

    @IBAction func pauseInroll(_ sender: Any) {
        inrollsPlaybackController?.pauseInroll()
        resumeInrollButton.isEnabled = true
        pauseInrollButton.isEnabled = false
    }

    @IBAction func resumeInroll(_ sender: Any) {
        inrollsPlaybackController?.resumeInroll()
        resumeInrollButton.isEnabled = false
        pauseInrollButton.isEnabled = true
    }

    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel))
        self.present(alertController, animated: true)
    }

    // MARK: - Private

    private func prepareVideo() {
        contentPlayer?.delegate = self
        contentPlayer?.prepareVideo()
    }
}

// MARK: - InstreamAdLoaderDelegate

extension InstreamInrollViewController: InstreamAdLoaderDelegate {
    func instreamAdLoader(_ instreamAdLoader: InstreamAdLoader, didLoad ad: InstreamAd) {
        let adBreakTypes = ad.adBreaks.map { $0.type + "(\(positionFormatter.positionDescription(for: $0.position)))" }
            .joined(separator: ", ")
        let message = "\(ad.adBreaks.count) adBreaks loaded successfully:\n" + adBreakTypes
        presentAlert(title: "Loaded", message: message)
        let inrollQueue = InrollQueueProvider(ad: ad).queue()
        guard let contentPlayer = contentPlayer, let adPlayer = adPlayer else { return }
        inrollsPlaybackController = InrollsPlaybackController(
            adView: adView,
            videoPlayer: contentPlayer,
            adPlayer: adPlayer,
            inrollQueue: inrollQueue
        )
        inrollsPlaybackController?.delegate = self
        playInrollButton.isEnabled = true
    }

    func instreamAdLoader(_ instreamAdLoader: InstreamAdLoader, didFailToLoad reason: String) {
        presentAlert(title: "Error", message: reason)
    }
}

// MARK: - InrollsPlaybackControllerDelegate
extension InstreamInrollViewController: InrollsPlaybackControllerDelegate {
    func inrollsPlaybackController(_ inrollsController: InrollsPlaybackController, didPrepare adBreak: InstreamAdBreak) {
        // do nothing
    }

    func inrollsPlaybackController(_ inrollsController: InrollsPlaybackController, didStart adBreak: InstreamAdBreak) {
        pauseInrollButton.isEnabled = true
    }

    func inrollsPlaybackController(_ inrollsController: InrollsPlaybackController, didComplete adBreak: InstreamAdBreak) {
        resumeInrollButton.isEnabled = false
        pauseInrollButton.isEnabled = false
        playInrollButton.isEnabled = true
    }

    func inrollsPlaybackController(_ inrollsController: InrollsPlaybackController, didFail adBreak: InstreamAdBreak) {
        resumeInrollButton.isEnabled = false
        pauseInrollButton.isEnabled = false
        playInrollButton.isEnabled = true
    }
}

// MARK: - VideoPlayerDelegate

extension InstreamInrollViewController: VideoPlayerDelegate {
    func videoPlayerDidPrepare(_ videoPlayer: VideoPlayer) {
        playbackButton.isEnabled = true
    }

    func videoPlayerDidComplete(_ videoPlayer: VideoPlayer) {
        // do nothing
    }

    func videoPlayerDidResume(_ videoPlayer: VideoPlayer) {
        // do nothing
    }

    func videoPlayerDidPause(_ videoPlayer: VideoPlayer) {
        // do nothing
    }

    func videoPlayerDidFail(_ videoPlayer: VideoPlayer) {
        // do nothing
    }
}
