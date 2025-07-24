/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import YandexMobileAdsInstream

class ContentPlayer: NSObject, VideoPlayer {
    weak var delegate: VideoPlayerDelegate?
    weak var controlsDelegate: ContentPlayerControlsDelegate?

    var invalidateCallback: (() -> ())?
    var onIsPlayingChangeCallback: ((Bool) -> ())?

    var position: Double {
        get {
            return player?.position ?? 0
        }
        set {
            player?.position = newValue
        }
    }

    var duration: Double {
        return player?.duration ?? .infinity
    }

    func setVolume(_ level: Double) {
        player?.setVolume(level)
    }

    private let url: URL
    private let visibilityManager = VideoPlayerVisibilityTracker()

    private var playerView: PlayerView?
    private var player: VideoAVPlayer?
    private var playerProvider: VideoPlayerProvider<ContentPlayer>?
    private var isResumeButtonVisible = false {
        didSet { controlsDelegate?.contentPlayer(self, didChangePlayControlVisibility: isResumeButtonVisible) }
    }

    init(playerProvider: VideoPlayerProvider<ContentPlayer>, url: URL) {
        self.playerProvider = playerProvider
        self.url = url
        super.init()

        visibilityManager.delegate = self
    }

    func isPlaying() -> Bool {
        return player?.isPlaying ?? false
    }

    private func startTracking() {
        visibilityManager.startTracking()
    }

    private func stopTracking() {
        visibilityManager.stopTracking()
    }

    func bind(to playerView: PlayerView) {
        configureResumeButton()
        player = playerProvider?.player(for: self)
        player?.delegate = self
        self.playerView = playerView
        visibilityManager.playerView = playerView
        player?.setPlayerView(playerView)
    }

    func prepareVideo() {
        player?.prepare(url: url)
    }

    func pauseVideo() {
        stopTracking()
        player?.pause()
        onIsPlayingChangeCallback?(false)
    }

    func resumeVideo() {
        startTracking()
        if let playerView = playerView {
            player?.setPlayerView(playerView)
        }
        player?.play()
        isResumeButtonVisible = false
        onIsPlayingChangeCallback?(true)
    }

    func handlePlayButtonClick() {
        isResumeButtonVisible = false
        player?.play()
    }

    // MARK: - Private

    private func configureResumeButton() {
        controlsDelegate?.contentPlayer(self, didChangePlayControlVisibility: isResumeButtonVisible)
    }
}

extension ContentPlayer: VideoAVPlayerDelegate {
    func playerDidPrepare(_ player: VideoAVPlayer) {
        delegate?.videoPlayerDidPrepare(self)
    }

    func playerDidStart(_ player: VideoAVPlayer) {
        delegate?.videoPlayerDidResume(self)
    }

    func playerDidComplete(_ player: VideoAVPlayer) {
        stopTracking()
        delegate?.videoPlayerDidComplete(self)
    }

    func playerDidResume(_ player: VideoAVPlayer) {
        delegate?.videoPlayerDidResume(self)
    }

    func playerDidPause(_ player: VideoAVPlayer) {
        delegate?.videoPlayerDidPause(self)
    }

    func playerDidFailToPlay(_ player: VideoAVPlayer, error: Error?) {
        delegate?.videoPlayerDidFail(self)
    }

    func playerDidStop(_ player: VideoAVPlayer) {
        // do nothing
    }

    func playerDidUpdateVolume(_ player: VideoAVPlayer, _ volume: Double) {
        // do nothing
    }
}

extension ContentPlayer: ReusablePlayer {
    func free() {
        invalidateCallback?()
        player?.delegate = nil
        player?.cancelPrepare()
        visibilityManager.stopTracking()

        player?.pause()
        player = nil
    }
}

extension ContentPlayer: VideoPlayerVisibilityTrackerDelegate {
    func visibilityTracker(_ visibilityTracker: VideoPlayerVisibilityTracker, didChangeVisibility isVisible: Bool) {
        if let player = player,
           player.isPlaying,
           !isVisible {
            player.pause()
            isResumeButtonVisible = true
        }
    }
}
