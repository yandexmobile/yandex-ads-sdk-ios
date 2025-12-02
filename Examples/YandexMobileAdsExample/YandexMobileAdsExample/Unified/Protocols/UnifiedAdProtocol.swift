import UIKit
import YandexMobileAds

protocol UnifiedAdProtocol: AnyObject {
    var inlineView: UIView? { get }
    var onEvent: ((UnifiedAdEvent) -> Void)? { get set }
    func load()
    func tearDown()
}
