import Foundation

@objc(MACInstreamBundleProvider)
class MACInstreamBundleProvider: NSObject {

    @objc func provideBundle() -> Bundle {
        Bundle.module
    }
}