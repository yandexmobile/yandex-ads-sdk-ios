/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit

class IronSourceManager: NSObject {
    static let shared = IronSourceManager()

    private override init() {
        super.init()
    }

    func initializeSDK() {
        // Replace 199eacc45 with app key generated at https://www.is.com/
        IronSource.initWithAppKey("199eacc45", adUnits: [IS_INTERSTITIAL, IS_REWARDED_VIDEO])
    }
}
