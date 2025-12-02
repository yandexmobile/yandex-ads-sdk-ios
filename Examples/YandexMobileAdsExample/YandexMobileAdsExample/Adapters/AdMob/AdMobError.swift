#if COCOAPODS
import Foundation

enum AdMobError: Error {
    case attachNotCalled(adType: String)
    case adNotReady(adType: String)
    case templateNotFound(adType: String)
}
#endif
