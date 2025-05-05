/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */
import Foundation
import UIKit

private let yandex = ("Yandex Ads", "show-yandex-ads", RootAccessibility.yandex)
private let mobileMediation = ("Mobile mediation", "show-mobile-mediation", RootAccessibility.mobileMediation)
private let thirdPartyMediation = ("Third-Party mediation", "show-third-party-mediation", RootAccessibility.thirdPartyMediation)
private let gdpr = ("GDPR", "show-gdpr", RootAccessibility.gdpr)
private let adFox = ("AdFox", "show-adfox", RootAccessibility.adFox)
private let consentManagement = ("Consent Management Platform", "show-cmp", RootAccessibility.cmp)

final class YandexAdsExampleViewController: UITableViewController {
    private let cellIdentifier = "cell"
    private typealias Item = (title: String, segueIdentifier: String, accessibilityId: String)
#if COCOAPODS
    private let items: [Item] = [
        yandex,
        mobileMediation,
        thirdPartyMediation,
        gdpr,
        adFox,
        consentManagement
    ]
#else
    private let items: [Item] = [
        yandex,
        mobileMediation,
        gdpr,
        adFox,
    ]
#endif

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        var configuration = cell.defaultContentConfiguration()
        let item = items[indexPath.row]
        configuration.text = item.title
        cell.contentConfiguration = configuration
        cell.accessibilityIdentifier = item.accessibilityId
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: items[indexPath.row].segueIdentifier, sender: nil)
    }
}
