/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class ViewController: UIViewController {

    private let adMobBlockID = "adf-279013/975832"
    private let facebookBlockID = "adf-279013/975836"
    private let moPubBlockID = "adf-279013/975834"
    private let startAppBlockID = "adf-279013/1006423"
    private let yandexBlockID = "adf-279013/975838"

    @IBOutlet weak var container: UIView!
    
    var adView: YMAAdView!

    @IBAction func loadAd(_ sender: UIButton) {

        /*
         Replace demo adMobBlockID with actual Block ID.
         Following demo block ids may be used for testing:
         AdMob mediation: adMobBlockID
         Facebook mediation: facebookBlockID
         MoPub mediation: moPubBlockID
         StartApp mediation: startAppBlockID
         Yandex: yandexBlockID
         */

        let adSize = YMAAdSize.fixedSize(with: YMAAdSizeBanner_320x50)
        adView = YMAAdView(blockID: adMobBlockID, adSize: adSize, delegate: self)
        adView.loadAd()
    }
}

// MARK: - YMAAdViewDelegate

extension ViewController: YMAAdViewDelegate {
    func adViewDidLoad(_ adView: YMAAdView!) {
        print("Ad loaded")
        adView.displayAtBottom(in: container)
    }

    func adViewDidFailLoading(_ adView: YMAAdView!, error: Error!) {
        print("Ad failed loading. Error: \(String(describing: error))")
    }
}

