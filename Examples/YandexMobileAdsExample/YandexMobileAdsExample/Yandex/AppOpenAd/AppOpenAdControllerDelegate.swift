/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

protocol AppOpenAdControllerDelegate: AnyObject {
    func appOpenAdControllerDidLoad(_ appOpenAdController: AppOpenAdController)
    func appOpenAdControllerDidDismiss(_ appOpenAdController: AppOpenAdController)
    func appOpenAdController(_ appOpenAdController: AppOpenAdController, didFailToLoadWithError error: Error)
    func appOpenAdController(_ appOpenAdController: AppOpenAdController, didFailToShowWithError error: Error)
}
