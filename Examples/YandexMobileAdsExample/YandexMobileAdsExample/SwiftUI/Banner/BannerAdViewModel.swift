/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import YandexMobileAds

enum BannerSizeType: String, CaseIterable, Identifiable {
    case fixed  = "Fixed"
    case sticky = "Sticky"
    case inline = "Inline"

    var id: String { rawValue }

    var bannerSize: BannerSize {
        switch self {
        case .fixed:  return .fixed(width: 320, height: 50)
        case .sticky: return .sticky()
        case .inline: return .inline(width: 320, maxHeight: 320)
        }
    }
}

@MainActor
final class BannerViewModel: ObservableObject {
    @Published var logs: [String] = []
    @Published var adState: SwiftUIAdState = .idle
    @Published var bannerState: BannerState? = nil
    @Published var isBannerVisible = false
    @Published var selectedSize: BannerSizeType = .fixed

    let adUnitID = "demo-banner-yandex"

    func load() {
        guard adState != .loading else { return }
        reset()
        adState = .loading
        bannerState = BannerState(
            size: selectedSize.bannerSize,
            request: AdRequest(adUnitID: adUnitID)
        )
        appendLog("Loading \(selectedSize.rawValue)...")
    }

    func handleLoad() {
        isBannerVisible = true
        adState = .idle
        appendLog("didLoad")
    }

    func handleError(_ error: Error) {
        isBannerVisible = false
        adState = .error("Failed to load. Tap Load to retry.")
        appendLog("didFailToLoad: \(error.localizedDescription)")
    }

    func appendLog(_ message: String) {
        logs.append(message)
    }

    private func reset() {
        isBannerVisible = false
        bannerState = nil
    }
}
