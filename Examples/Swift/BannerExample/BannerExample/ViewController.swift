/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class ViewController: UIViewController {
    
    var topAdView: YMAAdView!
    var bottomAdView: YMAAdView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Replace demo R-M-DEMO-320x50 with actual Block ID
        // Following demo Block IDs may be used for testing:
        // R-M-DEMO-320x50
        // R-M-DEMO-320x50-app_install
        // R-M-DEMO-728x90
        // R-M-DEMO-320x100-context
        // R-M-DEMO-300x250
        // R-M-DEMO-300x250-context
        // R-M-DEMO-300x300-context
        let adSize = YMAAdSize.flexibleSize(withContainerWidth: self.view.frame.width)
        self.topAdView = YMAAdView(blockID: "R-M-DEMO-320x50", adSize: adSize)
        self.topAdView.delegate = self
        self.bottomAdView = YMAAdView(blockID: "R-M-DEMO-320x100-context", adSize: YMAAdSize.flexible())
        self.bottomAdView.delegate = self

        self.topAdView.displayAtTop(in: self.view)
        self.bottomAdView.displayAtBottom(in: self.view)

        loadAd()
    }
    
    @IBAction func loadAd() {
        self.topAdView.loadAd()
        self.bottomAdView.loadAd()
    }
}

extension ViewController: YMAAdViewDelegate {
    // Uncomment to open web links in in-app browser
//    func viewControllerForPresentingModalView() -> UIViewController? {
//        return self
//    }
    
    func adViewDidLoad(_ adView: YMAAdView) {
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
