/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import SwiftUI

struct QRScannerView: View {
    let onScanned: (String) -> Void
    @StateObject private var scanner = QRScannerViewModel()

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 0) {
                QRCameraView(session: scanner.session)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .overlay { scanFrame }
                    .padding(.horizontal, 24)
                    .frame(height: geo.size.height * 0.65)
                    .padding(.top, 20)

                Text("Point camera at a QR code\nto load a playable creative")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.top, 24)

                Spacer()
            }
        }
        .onChange(of: scanner.scannedCode) { code in
            guard let code else { return }
            onScanned(code)
        }
    }

    private var scanFrame: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height) * 0.6
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
                .frame(width: size, height: size)
                .position(x: geo.size.width / 2, y: geo.size.height / 2)
        }
    }
}

#Preview {
    QRScannerView { _ in }
}
