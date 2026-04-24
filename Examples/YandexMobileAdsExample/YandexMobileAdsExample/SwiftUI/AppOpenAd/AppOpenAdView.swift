/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import SwiftUI
import YandexMobileAds

struct AppOpenContentView: View {
    @StateObject private var viewModel = AppOpenViewModel()

    var body: some View {
        VStack(spacing: 12) {
            AdLogsView(logs: viewModel.logs)

            Spacer()

            AdPlaceholderView(state: viewModel.adState)

            Spacer()

            Button {
                viewModel.load()
            } label: {
                Label("Load", systemImage: "arrow.down.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .disabled(viewModel.adState == .loading)
            .accessibilityIdentifier(CommonAccessibility.loadButton)
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .navigationTitle("App Open Ad")
        .navigationBarTitleDisplayMode(.inline)
        .appOpenAd(request: $viewModel.adRequest, onEvent: viewModel.handleEvent)
    }
}
