/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import SwiftUI
import YandexMobileAds

@MainActor
final class PlayablePreviewViewModel: ObservableObject {
    @Published var withVideo = false
    @Published var adRequest: AdRequest? = nil
    @Published var isPresented = false
    @Published private(set) var history: [PlayableItem] = []
    @Published private(set) var selectedItem: PlayableItem?
    @Published private(set) var adState: SwiftUIAdState = .idle

    private let historyKey = "playable_preview_history"

    init() { loadHistory() }

    var adUnitID: String {
        withVideo
            ? "demo-interstitial-playable-video"
            : "demo-interstitial-playable"
    }

    func select(_ item: PlayableItem) {
        selectedItem = item
        resetAdState()
        load()
    }

    func resetAdState() {
        adState = .idle
        adRequest = nil
    }

    func addItem(scannedCode: String) {
        guard let id = extractPlayableId(from: scannedCode) else { return }
        let item = PlayableItem(id: id)
        history.insert(item, at: 0)
        selectedItem = item
        resetAdState()
        saveHistory()
        load()
    }

    func deleteItems(at offsets: IndexSet) {
        for index in offsets where history[index].id == selectedItem?.id {
            selectedItem = nil
            resetAdState()
        }
        history.remove(atOffsets: offsets)
        saveHistory()
    }

    func load() {
        guard let item = selectedItem, adState != .loading else { return }
        adState = .loading
        adRequest = AdRequest(adUnitID: adUnitID, parameters: ["playable_url": item.id])
    }

    func present() { isPresented = true }

    func handleEvent(_ event: InterstitialAdEvent) {
        switch event {
        case .didLoad:
            adState = .readyToPresent
            present()
        case .didShow:
            break
        case .didDismiss:
            adState = .idle
            adRequest = nil
        case .didClick:
            break
        case .didFailToLoad:
            adState = .error("Failed to load. Tap an item to retry.")
        case .didFailToShow:
            adState = .idle
        case .didTrackImpression:
            break
        }
    }

    private func extractPlayableId(from code: String) -> String? {
        if let lastComponent = code.split(separator: "/").last.map(String.init),
           UUID(uuidString: lastComponent) != nil {
            return lastComponent
        }
        if UUID(uuidString: code) != nil {
            return code
        }
        return nil
    }

    private func saveHistory() {
        guard let data = try? JSONEncoder().encode(history) else { return }
        UserDefaults.standard.set(data, forKey: historyKey)
    }

    private func loadHistory() {
        guard let data = UserDefaults.standard.data(forKey: historyKey),
              let items = try? JSONDecoder().decode([PlayableItem].self, from: data) else { return }
        history = items
    }
}
