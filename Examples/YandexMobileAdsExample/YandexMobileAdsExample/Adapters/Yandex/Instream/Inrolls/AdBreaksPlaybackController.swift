/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import YandexMobileAdsInstream

protocol AdBreakPlaybackControllerDelegate: AnyObject {
    func adBreaksPlaybackController(_ adBreaksController: AdBreaksPlaybackController, didPrepare adBreak: InstreamAdBreak)
    func adBreaksPlaybackController(_ adBreaksController: AdBreaksPlaybackController, didStart adBreak: InstreamAdBreak)
    func adBreaksPlaybackController(_ adBreaksController: AdBreaksPlaybackController, didComplete adBreak: InstreamAdBreak)
    func adBreaksPlaybackController(_ adBreaksController: AdBreaksPlaybackController, didFail adBreak: InstreamAdBreak)
}

@MainActor
class AdBreaksPlaybackController {
    weak var delegate: AdBreakPlaybackControllerDelegate?

    private let adView: InstreamAdView
    private let videoPlayer: VideoPlayer
    private let adPlayer: InstreamAdPlayer

    private var currentAdBreak: InstreamAdBreak?
    private var isPrepared = false
    private var shouldStartAfterPrepared = false
    private var isPlaying = false
    private var adBreaks: [InstreamAdBreak]

    init(adView: InstreamAdView, videoPlayer: VideoPlayer, adPlayer: InstreamAdPlayer, adBreaks: [InstreamAdBreak]) {
        self.adView = adView
        self.videoPlayer = videoPlayer
        self.adPlayer = adPlayer
        self.adBreaks = adBreaks
    }

    func startPlayback() {
        if currentAdBreak == nil {
            moveNext()
        }
    }

    func playInroll() {
        if let adBreak = currentAdBreak {
            videoPlayer.pauseVideo()
            play(adBreak: adBreak)
        } else {
            moveNext()
        }
    }

    func pauseInroll() {
        currentAdBreak?.pause()
    }

    func resumeInroll() {
        currentAdBreak?.resume()
    }

    // MARK: - Private

    private func play(adBreak: InstreamAdBreak) {
        if !isPlaying {
            if isPrepared {
                adBreak.play(with: adView)
            } else {
                shouldStartAfterPrepared = true
            }
        }
    }

    private func moveNext() {
        stopCurrentInroll()
        currentAdBreak = adBreaks.first
        currentAdBreak?.delegate = self
        currentAdBreak?.prepare(with: adPlayer)
    }

    private func stopCurrentInroll() {
        currentAdBreak?.invalidate()
        currentAdBreak?.delegate = nil
        resetCurrentState()
    }

    private func resetCurrentState() {
        currentAdBreak = nil
        isPrepared = false
        shouldStartAfterPrepared = false
        isPlaying = false
    }
}

extension AdBreaksPlaybackController: InstreamAdBreakDelegate {
    func instreamAdBreakDidPrepare(_ adBreak: InstreamAdBreak) {
        isPrepared = true
        if shouldStartAfterPrepared {
            currentAdBreak?.play(with: adView)
            shouldStartAfterPrepared = false
        }
        delegate?.adBreaksPlaybackController(self, didPrepare: adBreak)
    }

    func instreamAdBreakDidStart(_ adBreak: InstreamAdBreak) {
        isPlaying = true
        videoPlayer.pauseVideo()
        delegate?.adBreaksPlaybackController(self, didStart: adBreak)
    }

    func instreamAdBreakDidComplete(_ adBreak: InstreamAdBreak) {
        handleDidComplete()
        delegate?.adBreaksPlaybackController(self, didComplete: adBreak)
    }

    func instreamAdBreakDidError(_ adBreak: InstreamAdBreak) {
        handleDidComplete()
        delegate?.adBreaksPlaybackController(self, didFail: adBreak)
    }

    // MARK: - Private

    private func handleDidComplete() {
        resetCurrentState()
        videoPlayer.resumeVideo()
        moveNext()
    }
}
