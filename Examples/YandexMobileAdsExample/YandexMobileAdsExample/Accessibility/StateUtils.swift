/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

enum StateUtils {
    static func loaded() -> String {
        "Loaded"
    }
    
    static func prepared() -> String {
        "Prepared"
    }
    
    static let loadErrorPrefix = "Load error"
    
    static func loadError(_ error: String) -> String {
        "\(loadErrorPrefix): \(error)"
    }
    
    static func loadError(_ error: Error) -> String {
        loadError("\(error)")
    }
}
