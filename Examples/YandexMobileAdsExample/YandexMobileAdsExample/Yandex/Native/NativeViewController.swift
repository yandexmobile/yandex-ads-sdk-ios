/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import UIKit

enum NativeCellModel: NavigationScreenDataSource, CaseIterable {
    case template
    case custom
    case bulk

    var destinationViewController: UIViewController {
        switch self {
        case .template:
            return NativeTemplateViewController()
        case .custom:
            return NativeCustomViewController()
        case .bulk:
            return NativeBulkViewController()
        }
    }

    var title: String {
        String(describing: self).camelCaseToWords()
    }
    
    var accessibilityId: String? {
        switch self {
        case .template:
            YandexNativeAccessibility.template
        case .custom:
            YandexNativeAccessibility.custom
        case .bulk:
            YandexNativeAccessibility.bulk
        }
    }
}

final class NativeViewController: NavigationTableViewController<NativeCellModel> { }
