/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import SwiftUI
import YandexMobileAds

struct RewardedContentView: View {
    @StateObject private var viewModel = RewardedViewModel()

    var body: some View {
        VStack(spacing: 12) {
            AdLogsView(logs: viewModel.logs)

            Spacer()

            AdPlaceholderView(state: viewModel.adState)

            Spacer()

            HStack(spacing: 16) {
                Button {
                    viewModel.load()
                } label: {
                    Label("Load", systemImage: "arrow.down.circle")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .tint(.blue)
                .disabled(viewModel.adState == .loading)
                .accessibilityIdentifier(CommonAccessibility.loadButton)

                Button {
                    viewModel.present()
                } label: {
                    Label("Present Ad", systemImage: "play.fill")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(!viewModel.isLoaded)
                .accessibilityIdentifier(CommonAccessibility.presentButton)
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 20)
        .navigationTitle("Rewarded")
        .navigationBarTitleDisplayMode(.inline)
        .rewardedAd(isPresented: $viewModel.isPresented, request: $viewModel.adRequest, onEvent: viewModel.handleEvent)
        .alert("Reward", isPresented: Binding(
            get: { viewModel.pendingReward != nil && !viewModel.isPresented },
            set: { if !$0 { viewModel.pendingReward = nil } }
        )) {
            Button("OK") { viewModel.pendingReward = nil }
        } message: {
            if let reward = viewModel.pendingReward {
                let text = reward.type.isEmpty
                    ? "You earned \(reward.amount)"
                    : "You earned \(reward.amount) \(reward.type)"
                Text(text)
            }
        }
    }
}
