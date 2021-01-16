/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class ViewController: UIViewController {
    
    var interstitialAd: YMAInterstitialAd!
    
    @IBAction func loadInterstitial() {
        // Replace demo R-M-DEMO-240x400-context with actual Block ID
        // Following demo Block IDs may be used for testing:
        // R-M-DEMO-240x400-context
        // R-M-DEMO-400x240-context
        // R-M-DEMO-320x480
        // R-M-DEMO-480x320
        // R-M-DEMO-video-interstitial
        self.interstitialAd = YMAInterstitialAd(blockID: "R-M-DEMO-240x400-context")
        self.interstitialAd.delegate = self;
        self.interstitialAd.load()
    }
    
    @IBAction func presentInterstitial() {
        self.interstitialAd.present(from: self)
    }

}

extension ViewController: YMAInterstitialAdDelegate {
    func interstitialAdDidLoad(_ interstitialAd: YMAInterstitialAd) {
        print("Ad loaded")
    }

    func interstitialAdDidFail(toLoad interstitialAd: YMAInterstitialAd, error: Error) {
        print("Loading failed. Error: \(error)")
    }

    func interstitialAdWillLeaveApplication(_ interstitialAd: YMAInterstitialAd) {
        print("Will leave application")
    }

    func interstitialAdDidFail(toPresent interstitialAd: YMAInterstitialAd, error: Error) {
        print("Failed to present interstitial. Error: \(error)")
    }

    func interstitialAdWillAppear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad will appear")
    }

    func interstitialAdDidAppear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad did appear")
    }

    func interstitialAdWillDisappear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad will disappear")
    }

    func interstitialAdDidDisappear(_ interstitialAd: YMAInterstitialAd) {
        print("Interstitial ad did disappear")
    }

    func interstitialAd(_ interstitialAd: YMAInterstitialAd, willPresentScreen webBrowser: UIViewController?) {
        print("Interstitial ad will present screen")
    }
}
