/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        let gdprManager = GDPRUserConsentManager(userDefaults: UserDefaults.standard)
        gdprManager.initializeUserDefaults()

        let navigationController = window?.rootViewController as? UINavigationController
        let viewController = navigationController?.topViewController as? ViewController
        viewController?.gdprManager = gdprManager

        return true
    }
}
