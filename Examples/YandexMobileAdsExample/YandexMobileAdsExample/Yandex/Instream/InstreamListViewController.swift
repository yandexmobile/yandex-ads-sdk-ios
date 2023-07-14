/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation

enum InstreamListCellModel: NavigationScreenDataSource, CaseIterable {
    case singleInstream
    case inroll

    var destinationViewController: UIViewController {
        switch self {
        case .singleInstream:
            return InstreamViewController()
        case .inroll:
            return InstreamInrollViewController()
        }
    }

    var title: String {
        String(describing: self).camelCaseToWords()
    }
}

final class InstreamListViewController: NavigationTableViewController<InstreamListCellModel> { }
