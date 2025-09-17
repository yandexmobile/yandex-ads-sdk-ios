/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAdsInstream

class AdPlayer: NSObject {
    weak var delegate: InstreamAdPlayerDelegate?
    var invalidateCallback: (() -> ())?
    var errorConverter = AdPlayerErrorConverter()

    private var playerView: PlayerView?
    private var player: VideoAVPlayer?
    private weak var playerProvider: VideoPlayerProvider<AdPlayer>?
    private var videoAd: VideoAd?

    init(playerProvider: VideoPlayerProvider<AdPlayer>) {
        self.playerProvider = playerProvider
    }

    func bind(to playerView: PlayerView) {
        self.playerView = playerView

        player = playerProvider?.player(for: self)
        player?.delegate = self
    }
}

// MARK: - InstreamAdPlayer

extension AdPlayer: InstreamAdPlayer {
    var isPlaying: Bool {
        return player?.isPlaying ?? false
    }

    var duration: Double {
        return player?.duration ?? 0
    }

    var position: Double {
        return player?.position ?? 0
    }

    func prepareAd(with videoAd: VideoAd) {
        let mediaFile = videoAd.mediaFile
        guard let mediaFileUrl = URL(string: mediaFile.url) else {
            didFailVideoAd(videoAd, withReason: .fileNotFound)
            return
        }
        self.videoAd = videoAd
        if let player = player {
            player.prepare(url: mediaFileUrl)
        } else {
            didFailVideoAd(videoAd, withReason: .unknown)
        }
    }

    func playAd() {
        if let playerView = playerView {
            player!.setPlayerView(playerView)
        }
        player!.play()
    }

    func pauseAd() {
        player?.pause()
    }

    func resumeAd() {
        if let playerView = playerView {
            player?.setPlayerView(playerView)
        }
        player?.play()
    }

    func stopAd() {
        player?.stopAd()
    }

    func setVolume(_ level: Double) {
        player?.setVolume(level)
    }

    private final func didFailVideoAd(_ videoAd: VideoAd, withReason reason: InstreamAdPlayerErrorReason) {
        delegate?.instreamAdPlayer(self, didFailVideoAd: videoAd, withError: errorConverter.convert(reason))
    }
}

// MARK: - VideoAVPlayerDelegate

extension AdPlayer: VideoAVPlayerDelegate {
    func playerDidPrepare(_ player: VideoAVPlayer) {
        guard let videoAd = videoAd else { return }
        delegate?.instreamAdPlayer(self, didPrepare: videoAd)
    }

    func playerDidStart(_ player: VideoAVPlayer) {
        guard let videoAd = videoAd else { return }
        delegate?.instreamAdPlayer(self, didStart: videoAd)
    }

    func playerDidComplete(_ player: VideoAVPlayer) {
        guard let videoAd = videoAd else { return }
        delegate?.instreamAdPlayer(self, didComplete: videoAd)
    }

    func playerDidResume(_ player: VideoAVPlayer) {
        guard let videoAd = videoAd else { return }
        delegate?.instreamAdPlayer(self, didResume: videoAd)
    }

    func playerDidPause(_ player: VideoAVPlayer) {
        guard let videoAd = videoAd else { return }
        delegate?.instreamAdPlayer(self, didPause: videoAd)
    }

    func playerDidFailToPlay(_ player: VideoAVPlayer, error: Error?) {
        guard let videoAd = videoAd else { return }
        delegate?.instreamAdPlayer(self, didFailVideoAd: videoAd, withError: errorConverter.convert(error))
    }

    func playerDidStop(_ player: VideoAVPlayer) {
        guard let videoAd = videoAd else { return }
        delegate?.instreamAdPlayer(self, didStop: videoAd)
    }

    func playerDidUpdateVolume(_ player: VideoAVPlayer, _ volume: Double) {
        guard let videoAd = videoAd else { return }
        delegate?.instreamAdPlayer(self, videoAd: videoAd, didUpdated: volume)
    }
}

extension AdPlayer: ReusablePlayer {
    func free() {
        invalidateCallback?()
        player?.cancelPrepare()
        player?.delegate = nil
        player?.pause()
        player = nil
    }
}
