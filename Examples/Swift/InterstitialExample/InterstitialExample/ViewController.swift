/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class ViewController: UIViewController, YMAInterstitialDelegate {
    
    var interstitialController: YMAInterstitialController!
    
    @IBAction func loadInterstitial() {
        // Replace demo R-M-DEMO-240x400-context with actual Block ID
        // Following demo Block IDs may be used for testing:
        // R-M-DEMO-240x400-context
        // R-M-DEMO-400x240-context
        // R-M-DEMO-320x480
        // R-M-DEMO-480x320
        // R-M-DEMO-video-interstitial
        self.interstitialController = YMAInterstitialController(blockID: "R-M-DEMO-240x400-context")
        self.interstitialController.delegate = self;
        self.interstitialController.load()
    }
    
    @IBAction func presentInterstitial() {
        self.interstitialController.presentInterstitial(from: self)
    }
    
    // MARK: - YMAInterstitialDelegate
    
    func interstitialDidLoadAd(_ interstitial: YMAInterstitialController!) {
        print("Ad loaded")
    }
    
    func interstitialDidFail(toLoadAd interstitial: YMAInterstitialController!, error: Error!) {
        print("Loading failed. Error: \(error!)")
    }
    
    func interstitialWillLeaveApplication(_ interstitial: YMAInterstitialController!) {
        print("Will leave application")
    }
    
    func interstitialDidFail(toPresentAd interstitial: YMAInterstitialController!, error: Error!) {
        print("Failed to present interstitial. Error: \(error!)")
    }
    
    func interstitialWillAppear(_ interstitial: YMAInterstitialController!) {
        print("Interstitial will appear")
    }
    
    func interstitialDidAppear(_ interstitial: YMAInterstitialController!) {
        print("Interstitial did appear")
    }
    
    func interstitialWillDisappear(_ interstitial: YMAInterstitialController!) {
        print("Interstitial will disappear")
    }
    
    func interstitialDidDisappear(_ interstitial: YMAInterstitialController!) {
        print("Interstitial did disappear")
    }
    
    func interstitialWillPresentScreen(_ webBrowser: UIViewController!) {
        print("Interstitial will present screen")
    }
}

