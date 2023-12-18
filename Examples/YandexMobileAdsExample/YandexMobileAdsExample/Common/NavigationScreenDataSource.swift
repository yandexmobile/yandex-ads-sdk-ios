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
