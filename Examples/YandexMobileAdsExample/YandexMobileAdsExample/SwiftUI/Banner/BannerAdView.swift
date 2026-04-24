/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import SwiftUI
import YandexMobileAds

struct BannerContentView: View {
    @StateObject private var viewModel = BannerViewModel()

    var body: some View {
        VStack(spacing: 12) {
            AdLogsView(logs: viewModel.logs)

            Picker("Size", selection: $viewModel.selectedSize) {
                ForEach(BannerSizeType.allCases) { size in
                    Text(size.rawValue).tag(size)
                }
            }
            .pickerStyle(.segmented)
            .onChange(of: viewModel.selectedSize) { _ in
                viewModel.bannerState = nil
                viewModel.isBannerVisible = false
                viewModel.adState = .idle
            }

            Spacer()

            ZStack {
                if !viewModel.isBannerVisible {
                    AdPlaceholderView(state: viewModel.adState)
                }
                if let state = viewModel.bannerState {
                    Banner(state: state)
                        .onAdLoad { _ in viewModel.handleLoad() }
                        .onAdFailure { viewModel.handleError($0) }
                        .onAdClick { viewModel.appendLog("didClick") }
                        .onAdImpression { _ in viewModel.appendLog("didTrackImpression") }
                        .opacity(viewModel.isBannerVisible ? 1 : 0)
                }
            }
            .accessibilityIdentifier(CommonAccessibility.bannerView)

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
        .navigationTitle("Banner")
        .navigationBarTitleDisplayMode(.inline)
    }
}
