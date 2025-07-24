/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation

extension String {
    func camelCaseToWords() -> String {
        map { ($0.isUppercase ? " " : "") + String($0) }
            .joined(separator: "")
            .trimmingCharacters(in: .whitespaces)
            .localizedCapitalized
    }
}
