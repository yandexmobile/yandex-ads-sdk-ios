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
    var onSelect: (SwiftUIAdType) -> Void

    var body: some View {
        List(SwiftUIAdType.allCases) { adType in
            Button {
                onSelect(adType)
            } label: {
                HStack {
                    Text(adType.rawValue)
                        .foregroundStyle(.primary)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.tertiary)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .navigationTitle("SwiftUI Examples")
        .navigationBarTitleDisplayMode(.inline)
    }
}
