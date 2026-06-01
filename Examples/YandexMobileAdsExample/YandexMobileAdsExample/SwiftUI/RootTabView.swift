/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            UIKitExamplesTab()
                .tabItem { Label("UIKit", systemImage: "square.grid.2x2") }

            SwiftUIExamplesTab()
                .tabItem { Label("SwiftUI", systemImage: "swift") }

            PlayablePreviewView()
                .tabItem { Label("Playable", systemImage: "qrcode.viewfinder") }
        }
    }
}
