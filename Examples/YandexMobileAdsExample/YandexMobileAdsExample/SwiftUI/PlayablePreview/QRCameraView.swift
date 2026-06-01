/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import AVFoundation
import SwiftUI

struct QRCameraView: UIViewRepresentable {
    let session: AVCaptureSession

    func makeUIView(context: Context) -> PreviewUIView {
        let view = PreviewUIView()
        view.session = session
        return view
    }

    func updateUIView(_ uiView: PreviewUIView, context: Context) {}

    final class PreviewUIView: UIView {
        var session: AVCaptureSession? {
            didSet { (layer as? AVCaptureVideoPreviewLayer)?.session = session }
        }

        override class var layerClass: AnyClass { AVCaptureVideoPreviewLayer.self }

        override func layoutSubviews() {
            super.layoutSubviews()
            (layer as? AVCaptureVideoPreviewLayer)?.videoGravity = .resizeAspectFill
        }
    }
}

#Preview {
    QRCameraView(session: AVCaptureSession())
        .frame(width: 300, height: 300)
}
