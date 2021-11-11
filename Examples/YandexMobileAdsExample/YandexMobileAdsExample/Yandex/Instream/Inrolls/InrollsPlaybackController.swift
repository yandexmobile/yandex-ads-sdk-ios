/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import YandexMobileAdsInstream

protocol InrollsPlaybackControllerDelegate: AnyObject {
    func inrollsPlaybackController(_ inrollsController: InrollsPlaybackController, didPrepare adBreak: InstreamAdBreak)
    func inrollsPlaybackController(_ inrollsController: InrollsPlaybackController, didStart adBreak: InstreamAdBreak)
    func inrollsPlaybackController(_ inrollsController: InrollsPlaybackController, didComplete adBreak: InstreamAdBreak)
    func inrollsPlaybackController(_ inrollsController: InrollsPlaybackController, didFail adBreak: InstreamAdBreak)
}

class InrollsPlaybackController {
    weak var delegate: InrollsPlaybackControllerDelegate?

    private let adView: InstreamAdView
    private let videoPlayer: VideoPlayer
    private let adPlayer: InstreamAdPlayer
    private let inrollQueue: InrollQueue

    private var currentInroll: Inroll?
    private var isPrepared = false
    private var shouldStartAfterPrepared = false
    private var isPlaying = false

    init(adView: InstreamAdView, videoPlayer: VideoPlayer, adPlayer: InstreamAdPlayer, inrollQueue: InrollQueue) {
        self.adView = adView
        self.videoPlayer = videoPlayer
        self.adPlayer = adPlayer
        self.inrollQueue = inrollQueue
    }

    func startPlayback() {
        if currentInroll == nil {
            moveNext()
        }
    }

    func stopPlayback() {
        stopCurrentInroll()
    }

    func playInroll() {
        if let inroll = currentInroll {
            videoPlayer.pauseVideo()
            play(inroll: inroll)
        } else {
            moveNext()
        }
    }

    func pauseInroll() {
        currentInroll?.pause()
    }

    func resumeInroll() {
        currentInroll?.resume()
    }

    // MARK: - Private

    private func play(inroll: Inroll) {
        if !isPlaying {
            if isPrepared {
                inroll.play(with: adView)
            } else {
                shouldStartAfterPrepared = true
            }
        }
    }

    private func moveNext() {
        stopCurrentInroll()
        currentInroll = inrollQueue.poll()
        currentInroll?.delegate = self
        currentInroll?.prepare(with: adPlayer)
    }

    private func stopCurrentInroll() {
        currentInroll?.invalidate()
        currentInroll?.delegate = nil
        resetCurrentState()
    }

    private func resetCurrentState() {
        currentInroll = nil
        isPrepared = false
        shouldStartAfterPrepared = false
        isPlaying = false
    }
}

extension InrollsPlaybackController: InstreamAdBreakDelegate {
    func instreamAdBreakDidPrepare(_ adBreak: InstreamAdBreak) {
        isPrepared = true
        if shouldStartAfterPrepared {
            currentInroll?.play(with: adView)
            shouldStartAfterPrepared = false
        }
        delegate?.inrollsPlaybackController(self, didPrepare: adBreak)
    }

    func instreamAdBreakDidStart(_ adBreak: InstreamAdBreak) {
        isPlaying = true
        videoPlayer.pauseVideo()
        delegate?.inrollsPlaybackController(self, didStart: adBreak)
    }

    func instreamAdBreakDidComplete(_ adBreak: InstreamAdBreak) {
        handleDidComplete()
        delegate?.inrollsPlaybackController(self, didComplete: adBreak)
    }

    func instreamAdBreakDidError(_ adBreak: InstreamAdBreak) {
        handleDidComplete()
        delegate?.inrollsPlaybackController(self, didFail: adBreak)
    }

    // MARK: - Private

    private func handleDidComplete() {
        resetCurrentState()
        videoPlayer.resumeVideo()
        moveNext()
    }
}
