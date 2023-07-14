/*
 * Version for iOS © 2015–2022 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit

class IronSourceInterstitialViewController: UIViewController {
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeIronSource()
    }

    func initializeIronSource() {
        IronSourceManager.shared.initializeSDK()
        IronSource.setLevelPlayInterstitialDelegate(self)
    }

    @IBAction func loadAd(_ sender: UIButton) {
        showButton.isEnabled = false
        IronSource.loadInterstitial()
    }

    @IBAction func showAd(_ sender: UIButton) {
        IronSource.showInterstitial(with: self)
    }
}

// MARK: - LevelPlayInterstitialDelegate

extension IronSourceInterstitialViewController: LevelPlayInterstitialDelegate {
    func didLoad(with adInfo: ISAdInfo!) {
        print("Interstitial did load")
        showButton.isEnabled = true
    }

    func didFailToLoadWithError(_ error: Error!) {
        print("Interstitial did fail to load")
        showButton.isEnabled = false
    }

    func didOpen(with adInfo: ISAdInfo!) {
        print("Interstitial did open")
    }

    func didShow(with adInfo: ISAdInfo!) {
        print("Interstitial did show")
    }

    func didFailToShowWithError(_ error: Error!, andAdInfo adInfo: ISAdInfo!) {
        print("Interstitial did fail to show")
    }

    func didClick(with adInfo: ISAdInfo!) {
        print("Did click interstitial")
    }

    func didClose(with adInfo: ISAdInfo!) {
        print("Interstital did close")
    }
}
