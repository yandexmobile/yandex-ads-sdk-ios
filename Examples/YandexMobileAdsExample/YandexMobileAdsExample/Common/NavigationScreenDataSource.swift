/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import UIKit

protocol NavigationScreenDataSource {
    var destinationViewController: UIViewController { get }
    var title: String { get }
    var accessibilityId: String? { get }
}

extension NavigationScreenDataSource {
    var accessibilityId: String? { nil }
}
