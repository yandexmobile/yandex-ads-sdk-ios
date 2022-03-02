/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import AVKit

class VideoAVPlayer: NSObject {
    weak var delegate: VideoAVPlayerDelegate?

    private let avPlayer = AVPlayer()

    private var playerContext = 0
    private var playerItemContext = 0

    var isPlaying: Bool {
        return avPlayer.rate > 0
    }

    var duration: Double {
        let cmTime = avPlayer.currentItem?.duration ?? CMTime.zero
        return CMTimeGetSeconds(cmTime)
    }

    var position: Double {
        get {
            return CMTimeGetSeconds(avPlayer.currentTime())
        }
        set {
            avPlayer.seek(to: CMTime(seconds: newValue, preferredTimescale: avPlayer.currentTime().timescale))
        }
    }

    override init() {
        super.init()
        subscribeToPlayerRateChanges()
    }

    deinit {
        unsubscribeCurrentPlayerItem()
        avPlayer.removeObserver(
            self,
            forKeyPath: #keyPath(AVPlayer.rate)
        )
    }

    func prepare(url: URL) {
        let newItem = AVPlayerItem(url: url)
        replaceCurrentObservedItem(newItem: newItem)
        avPlayer.replaceCurrentItem(with: newItem)
    }

    func setPlayerView(_ playerView: PlayerView) {
        playerView.player = avPlayer
    }

    func play() {
        avPlayer.play()
    }

    func pause() {
        avPlayer.pause()
    }

    func stopAd() {
        unsubscribeCurrentPlayerItem()
        avPlayer.pause()
        avPlayer.replaceCurrentItem(with: nil)
        delegate?.playerDidStop(self)
    }

    func setVolume(_ volume: Double) {
        avPlayer.volume = Float(volume)
        delegate?.playerDidUpdateVolume(self, volume)
    }

    func cancelPrepare() {
        avPlayer.replaceCurrentItem(with: nil)
    }

    override func observeValue(forKeyPath keyPath: String?,
                               of object: Any?,
                               change: [NSKeyValueChangeKey : Any]?,
                               context: UnsafeMutableRawPointer?) {
        if context == &playerItemContext {
            handlePlayerItemChange(forKeyPath: keyPath, of: object, change: change)
        } else if context == &playerContext {
            handlePlayerChange(forKeyPath: keyPath, change: change)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }

    // MARK: - Private

    private func subscribeToPlayerRateChanges() {
        avPlayer.addObserver(self,
                             forKeyPath: #keyPath(AVPlayer.rate),
                             options: [.old, .new],
                             context: &playerContext)
    }

    private func replaceCurrentObservedItem(newItem: AVPlayerItem) {
        unsubscribeCurrentPlayerItem()
        newItem.addObserver(
            self,
            forKeyPath: #keyPath(AVPlayerItem.status),
            options: [.new],
            context: &playerItemContext
        )
    }

    private func unsubscribeCurrentPlayerItem() {
        avPlayer.currentItem?.removeObserver(
            self,
            forKeyPath: #keyPath(AVPlayerItem.status)
        )
    }

    private func handlePlayerChange(forKeyPath keyPath: String?, change: [NSKeyValueChangeKey : Any]?) {
        guard keyPath == #keyPath(AVPlayer.rate),
              let oldRateNumber = change?[.oldKey] as? NSNumber,
              let newRateNumber = change?[.newKey] as? NSNumber else {
                  return
              }
        let oldRate = oldRateNumber.doubleValue
        let newRate = newRateNumber.doubleValue
        let isResumed = oldRate == 0 && newRate > 0
        if isResumed {
            if avPlayer.currentTime().seconds == 0 {
                delegate?.playerDidStart(self)
            } else {
                delegate?.playerDidResume(self)
            }
        } else if oldRate > 0 && newRate == 0 {
            handlePause()
        }
    }

    private func handlePause() {
        guard let currentItem = avPlayer.currentItem else { return }

        if currentItem.currentTime() < currentItem.duration {
            delegate?.playerDidPause(self)
        } else if currentItem.currentTime() == currentItem.duration {
            delegate?.playerDidComplete(self)
        }
    }

    private func handlePlayerItemChange(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?) {
        guard keyPath == #keyPath(AVPlayerItem.status),
              let statusNumber = change?[.newKey] as? NSNumber,
              let status = AVPlayerItem.Status(rawValue: statusNumber.intValue) else {
                  return
              }

        switch status {
        case .readyToPlay:
            delegate?.playerDidPrepare(self)
            break
        case .failed:
            avPlayer.rate = 0
            let error = avPlayer.currentItem?.error ?? avPlayer.error
            delegate?.playerDidFailToPlay(self, error: error)
        case .unknown:
            break
        @unknown default:
            break
        }
    }
}
