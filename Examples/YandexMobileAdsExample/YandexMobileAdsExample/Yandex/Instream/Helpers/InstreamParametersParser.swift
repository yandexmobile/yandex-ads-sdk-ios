/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation

class InstreamParametersParser {
    func parseParameters(from string: String) -> [String: String]? {
        var parameters = [String: String]()
        for pair in string.split(separator: ";") {
            let keyAndValue = pair.split(separator: ":").map(String.init)
            guard keyAndValue.count == 2 else { return nil }
            parameters[keyAndValue.first!] = keyAndValue.last
        }
        return parameters
    }
}
