/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import YandexMobileAds

@MainActor
final class RewardedViewModel: ObservableObject {
    @Published var logs: [String] = []
    @Published var adState: SwiftUIAdState = .idle
    @Published var adRequest: AdRequest? = nil
    @Published var isPresented = false
    @Published var isLoaded = false
    @Published var pendingReward: Reward? = nil

    private let adUnitID = "demo-rewarded-yandex"

    func load() {
        guard adState != .loading else { return }
        isLoaded = false
        adState = .loading
        adRequest = AdRequest(adUnitID: adUnitID)
        appendLog("Loading...")
    }

    func present() {
        isPresented = true
    }

    func handleEvent(_ event: RewardedAdEvent) {
        switch event {
        case .didLoad:
            isLoaded = true
            adState = .readyToPresent
            appendLog("didLoad")
        case .didShow:
            appendLog("didShow")
        case .didDismiss:
            isLoaded = false
            adState = .idle
            appendLog("didDismiss")
        case .didClick:
            appendLog("didClick")
        case .didFailToLoad(let error):
            isLoaded = false
            adState = .error("Failed to load. Tap Load to retry.")
            appendLog("didFailToLoad: \(error.localizedDescription)")
        case .didFailToShow(let error):
            isLoaded = false
            adState = .idle
            appendLog("didFailToShow: \(error.localizedDescription)")
        case .didTrackImpression:
            appendLog("didTrackImpression")
        case .didReward(let reward):
            pendingReward = reward
            let text = reward.type.isEmpty
                ? "\(reward.amount)"
                : "\(reward.amount) \(reward.type)"
            appendLog("didReward: \(text)")
        }
    }

    func appendLog(_ message: String) {
        logs.append(message)
    }
}
