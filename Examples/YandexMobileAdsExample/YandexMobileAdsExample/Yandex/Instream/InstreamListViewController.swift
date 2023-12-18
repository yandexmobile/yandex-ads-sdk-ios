/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import UIKit

enum InstreamListCellModel: NavigationScreenDataSource, CaseIterable {
    case singleInstream
    case inroll

    var destinationViewController: UIViewController {
        switch self {
        case .singleInstream:
            return InstreamSingleViewController()
        case .inroll:
            return InstreamInrollsViewController()
        }
    }

    var title: String {
        String(describing: self).camelCaseToWords()
    }
    
    var accessibilityId: String? {
        switch self {
        case .singleInstream:
            return YandexInstreamListAccessibility.singleInstream
        case .inroll:
            return YandexInstreamListAccessibility.inroll
        }
    }
}

final class InstreamListViewController: NavigationTableViewController<InstreamListCellModel> { }
