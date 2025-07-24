/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import YandexMobileAds

final class NativeVideoProgressControlView: UIProgressView, NativeVideoPlaybackProgressControl {
    func configure(withPosition position: TimeInterval, duration: TimeInterval) {
        progress = Float(duration == 0 ? 0 : (position / duration))
    }
    
    func reset() {
        progress = 0
    }
}
