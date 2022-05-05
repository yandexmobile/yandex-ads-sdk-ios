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
        IronSource.setInterstitialDelegate(self)
    }

    @IBAction func loadAd(_ sender: UIButton) {
        showButton.isEnabled = false
        IronSource.loadInterstitial()
    }

    @IBAction func showAd(_ sender: UIButton) {
        IronSource.showInterstitial(with: self)
    }
}

extension IronSourceInterstitialViewController: ISInterstitialDelegate {
    func interstitialDidFailToLoadWithError(_ error: Error!) {
        print("Interstitial did fail to load")
        showButton.isEnabled = false
    }

    func interstitialDidLoad() {
        print("Interstitial did load")
        showButton.isEnabled = true
    }

    func interstitialDidFailToShowWithError(_ error: Error!) {
        print("Interstitial did fail to show")
    }

    func interstitialDidShow() {
        print("Interstitial did show")
    }

    func didClickInterstitial() {
        print("Did click interstitial")
    }

    func interstitialDidOpen() {
        print("Interstitial did open")
    }

    func interstitialDidClose() {
        print("Interstital did close")
    }
}
