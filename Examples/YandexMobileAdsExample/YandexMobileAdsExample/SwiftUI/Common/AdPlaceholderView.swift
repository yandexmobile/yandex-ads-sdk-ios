/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import SwiftUI

struct AdPlaceholderView: View {
    let state: SwiftUIAdState

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: iconName)
                .font(.system(size: 48, weight: .regular))
                .foregroundStyle(.tertiary)
            Text(message)
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var iconName: String {
        switch state {
        case .idle:           return "rectangle.and.hand.point.up.left"
        case .loading:        return "arrow.triangle.2.circlepath"
        case .readyToPresent: return "arrow.up.left.and.arrow.down.right"
        case .appOpenReady:   return "checkmark.circle"
        case .error:          return "exclamationmark.triangle"
        }
    }

    private var message: String {
        switch state {
        case .idle:           return "Tap Load to view an ad."
        case .loading:        return "Loading…"
        case .readyToPresent: return "Press Present Ad to view the fullscreen ad."
        case .appOpenReady:   return "Loaded. Leave the app, then return to see the ad."
        case .error(let msg): return msg
        }
    }
}
