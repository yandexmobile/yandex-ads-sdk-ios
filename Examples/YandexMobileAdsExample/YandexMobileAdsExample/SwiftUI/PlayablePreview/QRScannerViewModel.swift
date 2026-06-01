/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import AVFoundation
import SwiftUI

@MainActor
final class QRScannerViewModel: NSObject, ObservableObject {
    @Published var scannedCode: String?

    let session = AVCaptureSession()
    private let output = AVCaptureMetadataOutput()

    override init() {
        super.init()
        output.setMetadataObjectsDelegate(self, queue: .main)
        let session = self.session
        let output = self.output
        Task.detached(priority: .userInitiated) {
            guard let device = AVCaptureDevice.default(for: .video),
                  let input = try? AVCaptureDeviceInput(device: device),
                  session.canAddInput(input) else { return }

            session.addInput(input)

            if session.canAddOutput(output) {
                session.addOutput(output)
                output.metadataObjectTypes = [.qr]
            }

            session.startRunning()
        }
    }
}

extension QRScannerViewModel: AVCaptureMetadataOutputObjectsDelegate {
    nonisolated func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard let object = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let code = object.stringValue else { return }

        Task { @MainActor [weak self] in
            guard let self, self.scannedCode == nil else { return }
            self.session.stopRunning()
            self.scannedCode = code
        }
    }
}
