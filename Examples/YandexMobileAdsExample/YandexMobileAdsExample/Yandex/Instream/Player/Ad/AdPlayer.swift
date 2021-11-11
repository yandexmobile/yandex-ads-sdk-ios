/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAdsInstream

class AdPlayer: NSObject {
    weak var delegate: InstreamAdPlayerDelegate?
    var invalidateCallback: (() -> ())?

    var isPlayingObservation: ((_ isPlaying: Bool) -> ())?

    private var playerView: PlayerView?
    private var player: VideoAVPlayer?
    private var playerProvider: VideoPlayerProvider<AdPlayer>?
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
            delegate?.instreamAdPlayer(self, didError: videoAd)
            return
        }

        self.videoAd = videoAd
        if let player = player {
            player.prepare(url: mediaFileUrl)
        } else {
            delegate?.instreamAdPlayer(self, didError: videoAd)
        }
    }

    func playAd() {
        guard let player = player else { return }
        if let playerView = playerView {
            player.setPlayerView(playerView)
        }
        player.play()
        isPlayingObservation?(true)
    }

    func pauseAd() {
        player?.pause()
        isPlayingObservation?(false)
    }

    func resumeAd() {
        if let playerView = playerView {
            player?.setPlayerView(playerView)
        }
        player?.play()
        isPlayingObservation?(true)
    }

    func stopAd() {
        player?.stopAd()
        isPlayingObservation?(false)
    }

    func setVolume(_ level: Double) {
        player?.setVolume(level)
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
        isPlayingObservation?(false)
    }

    func playerDidResume(_ player: VideoAVPlayer) {
        guard let videoAd = videoAd else { return }
        delegate?.instreamAdPlayer(self, didResume: videoAd)
    }

    func playerDidPause(_ player: VideoAVPlayer) {
        guard let videoAd = videoAd else { return }
        delegate?.instreamAdPlayer(self, didPause: videoAd)
    }

    func playerDidFailToPlay(_ player: VideoAVPlayer) {
        guard let videoAd = videoAd else { return }
        delegate?.instreamAdPlayer(self, didError: videoAd)
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
