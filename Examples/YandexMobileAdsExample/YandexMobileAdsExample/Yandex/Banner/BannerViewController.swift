/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class BannerViewController: UIViewController {
    var adView: YMAAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Replace demo demo-banner-yandex with actual Ad Unit ID
        let adSize = YMAAdSize.inlineSize(withWidth: 320, maxHeight: 50)
        self.adView = YMAAdView(adUnitID: "demo-banner-yandex", adSize: adSize)
        self.adView.delegate = self
    }
    
    @IBAction func loadAd() {
        self.adView.removeFromSuperview()
        self.adView.loadAd()
    }
}

extension BannerViewController: YMAAdViewDelegate {
    // Uncomment to open web links in in-app browser
//    func viewControllerForPresentingModalView() -> UIViewController? {
//        return self
//    }
    
    func adViewDidLoad(_ adView: YMAAdView) {
        self.adView.displayAtBottom(in: self.view)
        print("Ad loaded")
    }

    func adViewDidClick(_ adView: YMAAdView) {
        print("Ad clicked")
    }

    func adView(_ adView: YMAAdView, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print("Impression tracked")
    }
    
    func adViewDidFailLoading(_ adView: YMAAdView, error: Error) {
        print("Ad failed loading. Error: \(error)")
    }
    
    func adViewWillLeaveApplication(_ adView: YMAAdView) {
        print("Ad will leave application")
    }
    
    func adView(_ adView: YMAAdView, willPresentScreen viewController: UIViewController?) {
        print("Ad will present screen")
    }

    func adView(_ adView: YMAAdView, didDismissScreen viewController: UIViewController?) {
        print("Ad did dismiss screen")
    }
    
}
