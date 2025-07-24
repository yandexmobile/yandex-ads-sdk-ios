/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import UIKit

class NavigationTableViewController<T: NavigationScreenDataSource>: UITableViewController where T: CaseIterable {
    private var dataSource = Array(T.allCases)

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let cellModel = dataSource[indexPath.row]
        cell.textLabel?.text = cellModel.title
        cell.accessibilityIdentifier = cellModel.accessibilityId
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cellModel = dataSource[indexPath.row]
        navigationController?.pushViewController(cellModel.destinationViewController, animated: true)
    }
}
