import UIKit

protocol AttachableAdProtocol: AnyObject {
    func attachIfNeeded(to viewController: UIViewController)
}