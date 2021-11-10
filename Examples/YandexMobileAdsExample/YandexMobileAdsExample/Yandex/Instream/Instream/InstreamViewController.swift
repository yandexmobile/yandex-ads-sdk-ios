/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAdsInstream

private let numberOfPlayers = 1

class InstreamViewController: UIViewController {
    @IBOutlet private var pageIdTextField: UITextField!
    @IBOutlet private var categoryIdTextField: UITextField!
    @IBOutlet private var parametersTextField: UITextField!
    @IBOutlet private var playerView: PlayerView!
    @IBOutlet private var instreamAdView: InstreamAdView!
    @IBOutlet private var contentProgressSlider: UISlider!
    @IBOutlet private var contentTimeLabel: UILabel!
    @IBOutlet private var toastLabel: UILabel!

    private let loader = InstreamAdLoader()
    private let parametersParser = InstreamParametersParser()
    private let positionFormatter = InstreamAdBreakPositionFormatter()
    private let contentPlayerProvider = VideoPlayerProvider<ContentPlayer>(maxSize: numberOfPlayers)
    private let adPlayerProvider = VideoPlayerProvider<AdPlayer>(maxSize: numberOfPlayers)

    private var ad: InstreamAd?
    private var adBinder: InstreamAdBinder?

    private var adPlayer: AdPlayer?
    private var contentPlayer: ContentPlayer?
    private var contentControlsController: ContentControlsController?

    private var binderDelegate: InstreamAdBinderToastDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        binderDelegate = InstreamAdBinderToastDelegate(toastLabel: toastLabel)
    }

    @IBAction func loadAd(_ sender: Any) {
        guard let pageId = pageIdTextField.text,
              let categoryId = categoryIdTextField.text,
              let parametersString = parametersTextField.text,
              let parameters = parametersParser.parseParameters(from: parametersString) else {
            presentAlert(title: "Error", message: "Can't parse request parameters")
            return
        }

        let configuration = InstreamAdRequestConfiguration(pageID: pageId,
                                                           categoryID: categoryId,
                                                           parameters: parameters)
        loader.delegate = self
        loader.loadInstreamAd(configuration: configuration)

        let adPlayer = AdPlayer(playerProvider: adPlayerProvider)
        self.adPlayer = adPlayer
        adPlayer.invalidateCallback = { [weak self] in self?.adBinder?.invalidateAdPlayer() }
        adPlayer.bind(to: playerView)

        let contentPlayer = ContentPlayer(playerProvider: contentPlayerProvider, url: InstreamContent.sampleVideoUrl)
        self.contentPlayer = contentPlayer
        contentPlayer.invalidateCallback = { [weak self] in self?.adBinder?.invalidateVideoPlayer() }
        contentPlayer.bind(to: playerView)
        contentControlsController = ContentControlsController(
            player: contentPlayer,
            progressSlider: contentProgressSlider,
            timeLabel: contentTimeLabel
        )
    }

    @IBAction func prepareAd(_ sender: Any) {
        adBinder?.prepareAd()
    }

    @IBAction func presentAd(_ sender: Any) {
        adBinder?.bind(with: instreamAdView)
        view.endEditing(true)
        contentControlsController?.setupContentControls()
    }

    @IBAction func contentProgressDidChange(_: Any) {
        let contentPosition = Double(contentProgressSlider.value) * (contentPlayer?.duration ?? 0)
        contentPlayer?.position = contentPosition
        contentPlayer?.resumeVideo()
        contentControlsController?.handleProgressChange()
    }

    func presentAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel))
        self.present(alertController, animated: true)
    }

    deinit {
        adBinder?.unbind()
    }
}

// MARK: - InstreamAdLoaderDelegate

extension InstreamViewController: InstreamAdLoaderDelegate {
    func instreamAdLoader(_ instreamAdLoader: InstreamAdLoader, didLoad ad: InstreamAd) {
        self.ad = ad
        let adBreakTypes = ad.adBreaks.map { $0.type + "(\(positionFormatter.positionDescription(for: $0.position)))" }
            .joined(separator: ", ")
        let message = "\(ad.adBreaks.count) adBreaks loaded successfully:\n" + adBreakTypes
        presentAlert(title: "Loaded", message: message)
        adBinder = InstreamAdBinder(ad: ad, adPlayer: adPlayer!, videoPlayer: contentPlayer!)
        adBinder?.delegate = binderDelegate
    }

    func instreamAdLoader(_ instreamAdLoader: InstreamAdLoader, didFailToLoad reason: String) {
        presentAlert(title: "Error", message: reason)
    }
}
