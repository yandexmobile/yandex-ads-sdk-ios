/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit

private let visibilityPercent = 50.0
private let visibilityTrackingInterval = 0.2

protocol VideoPlayerVisibilityTrackerDelegate: AnyObject {
    func visibilityTracker(_ visibilityTracker: VideoPlayerVisibilityTracker, didChangeVisibility isVisible: Bool)
}

class VideoPlayerVisibilityTracker {
    weak var delegate: VideoPlayerVisibilityTrackerDelegate?
    weak var playerView: UIView?

    private let visibilityValidator = ViewVisibilityValidator()
    private var visibilityTimer: Timer?

    func startTracking() {
        let timer = Timer.scheduledTimer(withTimeInterval: visibilityTrackingInterval, repeats: true) { [weak self] _ in
            guard let self = self  else { return }
            let isVisible = self.visibilityValidator.validateVisible(self.playerView, for: visibilityPercent)
            self.delegate?.visibilityTracker(self, didChangeVisibility: isVisible)
        }
        RunLoop.main.add(timer, forMode: .common)
        visibilityTimer = timer
    }

    func stopTracking() {
        visibilityTimer?.invalidate()
        visibilityTimer = nil
    }
}
