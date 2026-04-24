/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import YandexMobileAds

@MainActor
final class AppOpenViewModel: ObservableObject {
    @Published var logs: [String] = []
    @Published var adState: SwiftUIAdState = .idle
    @Published var adRequest: AdRequest? = nil

    private let adUnitID = "demo-appopenad-yandex"

    func load() {
        guard adState != .loading else { return }
        adState = .loading
        adRequest = AdRequest(adUnitID: adUnitID)
        appendLog("Loading...")
    }

    func handleEvent(_ event: AppOpenAdEvent) {
        switch event {
        case .didLoad:
            adState = .appOpenReady
            appendLog("didLoad")
        case .didShow:
            adState = .idle
            appendLog("didShow")
        case .didDismiss:
            adState = .idle
            appendLog("didDismiss")
        case .didClick:
            appendLog("didClick")
        case .didFailToLoad(let error):
            adState = .error("Failed to load. Tap Load to retry.")
            appendLog("didFailToLoad: \(error.localizedDescription)")
        case .didFailToShow(let error):
            adState = .idle
            appendLog("didFailToShow: \(error.localizedDescription)")
        case .didTrackImpression:
            appendLog("didTrackImpression")
        }
    }

    func appendLog(_ message: String) {
        logs.append(message)
    }
}
