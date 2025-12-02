/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

enum StateUtils {
    static let loaded = "Loaded"
    static let prepared = "Prepared"
    static let shown = "Shown"
    static let dismissed = "Dismissed"
    static let clicked = "Clicked"
    static let impression = "Impression"
    static let loadErrorPrefix = "Load error"
    static let showErrorPrefix = "Show error"
    
    static func loadError(_ error: String) -> String {
        "\(loadErrorPrefix): \(error)"
    }
    
    static func loadError(_ error: Error) -> String {
        loadError("\(error)")
    }
    
    static func showError(_ error: String) -> String {
        "\(showErrorPrefix): \(error)"
    }
    
    static func showError(_ error: Error) -> String {
        showError("\(error)")
    }
}
