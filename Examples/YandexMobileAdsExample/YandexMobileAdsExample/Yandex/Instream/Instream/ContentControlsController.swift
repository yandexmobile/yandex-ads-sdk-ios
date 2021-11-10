/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit

class ContentControlsController {
    private let player: ContentPlayer
    private let progressSlider: UISlider
    private let timeLabel: UILabel

    private var progressTimer: Timer?

    init(player: ContentPlayer, progressSlider: UISlider, timeLabel: UILabel) {
        self.player = player
        self.progressSlider = progressSlider
        self.timeLabel = timeLabel
    }

    func setupContentControls() {
        progressTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            guard let contentPlayer = self?.player else { return }
            let progress = Float(contentPlayer.position / contentPlayer.duration)
            self?.progressSlider.setValue(progress, animated: false)
            self?.updateTimeLabel()
        }
        player.onIsPlayingChangeCallback = { [weak self] isContentPlaying in
            self?.progressSlider.isHidden = !isContentPlaying
            self?.timeLabel.isHidden = !isContentPlaying
        }
    }

    func handleProgressChange() {
        let contentPosition = Double(progressSlider.value) * player.duration
        player.position = contentPosition
        player.resumeVideo()
        updateTimeLabel()
    }

    deinit {
        progressTimer?.invalidate()
    }

    // MARK: - Private

    private func updateTimeLabel() {
        guard player.position.isFinite else { return }
        let positionInSeconds = Int(player.position)
        let numberOfSeconds = positionInSeconds % 60
        let numberOfMinutes = positionInSeconds / 60 % 60
        timeLabel.text = String(format:"%02i:%02i", numberOfMinutes, numberOfSeconds)
    }
}
