import Foundation

@objc(MACSwiftBundleProvider)
class MACSwiftBundleProvider: NSObject {

    @objc func provideBundle() -> Bundle {
        Bundle.module
    }
}