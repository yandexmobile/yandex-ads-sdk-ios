/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import SwiftUI
import UIKit

struct UIKitExamplesTab: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UINavigationController {
        let rootVC = UnifiedAdViewController()
        let navController = UINavigationController(rootViewController: rootVC)
        navController.navigationBar.prefersLargeTitles = false
        rootVC.navigationItem.largeTitleDisplayMode = .never
        return navController
    }

    func updateUIViewController(_ uiViewController: UINavigationController, context: Context) {}
}
