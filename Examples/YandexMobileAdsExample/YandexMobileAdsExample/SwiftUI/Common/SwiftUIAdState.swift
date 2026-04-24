/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

enum SwiftUIAdState: Equatable {
    case idle
    case loading
    case readyToPresent   // Fullscreen ad loaded, waiting for present()
    case appOpenReady     // App open ad loaded, will show on next foreground
    case error(String)
}
