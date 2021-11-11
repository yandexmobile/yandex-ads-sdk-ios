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
        
        // Replace demo R-M-DEMO-320x500 with actual Block ID
        let adSize = YMAAdSize.fixedSize(with: .init(width: 320, height: 100))
        self.adView = YMAAdView(blockID: "R-M-DEMO-320x100-context", adSize: adSize)
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
