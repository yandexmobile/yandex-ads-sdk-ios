/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class ViewController: UIViewController {
    
    @IBOutlet weak var showButton: UIButton!

    private let adMobBlockID = "adf-279013/975869";
    private let facebookBlockID = "adf-279013/975872";
    private let moPubBlockID = "adf-279013/975870";
    private let myTargetBlockID = "adf-279013/975871";
    private let startAppBlockID = "adf-279013/1006406"
    private let unityAdsBlockID = "adf-279013/1006439"
    private let yandexBlockID = "adf-279013/975873";

    var interstitialAd: YMAInterstitialController!

    @IBAction func loadAd(_ sender: UIButton) {
        /*
         Replace demo AdMobBlockID with actual Block ID.
         Following demo block ids may be used for testing:
         AdMob mediation: adMobBlockID
         Facebook mediation: facebookBlockID
         MoPub mediation: moPubBlockID
         MyTarget mediation: myTargetBlockID
         StartApp mediation: startAppBlockID
         UnityAds mediation: unityAdsBlockID
         Yandex: yandexBlockID
         */
        interstitialAd = YMAInterstitialController(blockID: adMobBlockID)
        interstitialAd.delegate = self
        interstitialAd.load()
    }

    @IBAction func presentAd(_ sender: UIButton) {
        interstitialAd.presentInterstitial(from: self)
    }
}

extension ViewController: YMAInterstitialDelegate {
    func interstitialDidLoadAd(_ interstitial: YMAInterstitialController!) {
        print("Interstitial did load ad")
        showButton.isUserInteractionEnabled = true
    }

    func interstitialDidFail(toPresentAd interstitial: YMAInterstitialController!, error: Error!) {
        print("Interstitial did fail to present ad with error: \(String(describing: error))")
    }

    func interstitialDidFail(toLoadAd interstitial: YMAInterstitialController!, error: Error!) {
        print("Interstitial did fail to load ad with error: \(String(describing: error))")
    }
}

