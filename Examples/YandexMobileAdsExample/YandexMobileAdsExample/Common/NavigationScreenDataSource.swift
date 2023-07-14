import Foundation

protocol NavigationScreenDataSource {
    var destinationViewController: UIViewController { get }
    var title: String { get }
}
