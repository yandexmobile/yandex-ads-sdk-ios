/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import SwiftUI

enum SwiftUIAdType: String, CaseIterable, Identifiable {
    case appOpenAd = "App Open Ad"
    case banner = "Banner"
    case interstitial = "Interstitial"
    case rewarded = "Rewarded"

    var id: String { rawValue }
}

struct SwiftUIMenuView: View {
    var body: some View {
        List(SwiftUIAdType.allCases) { adType in
            NavigationLink(adType.rawValue, destination: destination(for: adType))
        }
        .navigationTitle("SwiftUI Examples")
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func destination(for adType: SwiftUIAdType) -> some View {
        switch adType {
        case .appOpenAd: AppOpenContentView()
        case .banner: BannerContentView()
        case .interstitial: InterstitialContentView()
        case .rewarded: RewardedContentView()
        }
    }
}
