/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import SwiftUI
import YandexMobileAds

struct PlayablePreviewView: View {
    @StateObject private var viewModel = PlayablePreviewViewModel()
    @State private var isScannerPresented = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                historyList
                Divider()
                bottomBar
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
            }
            .navigationTitle("Playable")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbarContent }
            .sheet(isPresented: $isScannerPresented) { scannerSheet }
            .interstitialAd(
                isPresented: $viewModel.isPresented,
                request: $viewModel.adRequest,
                onEvent: viewModel.handleEvent
            )
            .overlay { adStateOverlay }
        }
        .navigationViewStyle(.stack)
    }

    @ToolbarContentBuilder
    private var toolbarContent: some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            EditButton()
        }
        ToolbarItem(placement: .navigationBarTrailing) {
            Button { isScannerPresented = true } label: {
                Image(systemName: "qrcode.viewfinder")
            }
        }
    }

    @ViewBuilder
    private var adStateOverlay: some View {
        switch viewModel.adState {
        case .loading:
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                ProgressView("Loading…")
                    .padding(20)
                    .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        case .error(let message):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundStyle(.orange)
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(24)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        default:
            EmptyView()
        }
    }

    // MARK: Bottom Bar

    private var bottomBar: some View {
        HStack(spacing: 16) {
            Toggle("With video", isOn: $viewModel.withVideo)
                .fixedSize()
            Spacer()
            Button {
                isScannerPresented = true
            } label: {
                Label("Scan QR", systemImage: "qrcode.viewfinder")
            }
            .buttonStyle(.borderedProminent)
        }
    }

    // MARK: History List

    private var historyList: some View {
        Group {
            if viewModel.history.isEmpty {
                emptyState
            } else {
                List {
                    ForEach(viewModel.history) { item in
                        historyRow(item)
                            .contentShape(Rectangle())
                            .onTapGesture { viewModel.select(item) }
                            .listRowBackground(
                                viewModel.selectedItem?.id == item.id
                                    ? Color.blue.opacity(0.1)
                                    : Color(.systemBackground)
                            )
                    }
                    .onDelete { viewModel.deleteItems(at: $0) }
                }
                .listStyle(.plain)
            }
        }
    }

    private func historyRow(_ item: PlayableItem) -> some View {
        let selected = viewModel.selectedItem?.id == item.id
        return HStack {
            Text(item.id)
                .font(.body.monospaced())
                .foregroundStyle(selected ? Color.blue : Color.primary)
                .lineLimit(1)
            Spacer()
            if selected {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.blue)
            }
        }
        .padding(.vertical, 2)
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "qrcode")
                .font(.system(size: 52))
                .foregroundStyle(.tertiary)
            Text("No playables yet")
                .font(.headline)
                .foregroundStyle(.secondary)
            Text("Scan a QR code to add a playable creative")
                .font(.subheadline)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }

    // MARK: Scanner Sheet

    private var scannerSheet: some View {
        NavigationView {
            QRScannerView { code in
                viewModel.addItem(scannedCode: code)
                isScannerPresented = false
            }
            .navigationTitle("Scan QR Code")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { isScannerPresented = false }
                }
            }
        }
        .navigationViewStyle(.stack)
    }
}

#Preview {
    PlayablePreviewView()
}
