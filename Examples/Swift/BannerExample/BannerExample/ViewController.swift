/*
 * Version for iOS © 2015–2018 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class ViewController: UIViewController, YMAAdViewDelegate {
    
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
        self.topAdView = YMAAdView(blockID: "R-M-DEMO-320x50",
                                   adSize: adSize,
                                   delegate: self)!
        self.bottomAdView = YMAAdView(blockID: "R-M-DEMO-320x100-context",
                                      adSize: YMAAdSize.flexible(),
                                      delegate: self)!
        
        if #available(iOS 11.0, *) {
            displayAdAtTopOfSafeArea();
            displayAdAtBottomOfSafeArea();
        } else {
            self.topAdView.displayAtTop(in: self.view)
            self.bottomAdView.displayAtBottom(in: self.view)
        }
        loadAd()
    }
    
    @IBAction func loadAd() {
        self.topAdView.loadAd()
        self.bottomAdView.loadAd()
    }
    
    // Ability to display ad at bottom of Safe Area will soon be added to `displayAdAtTopOfSafeAreaInView:` method of SDK
    @available(iOS 11.0, *)
    func displayAdAtTopOfSafeArea() {
        let constraint = self.topAdView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor)
        display(adView: self.topAdView, anchorConstraint: constraint)
    }
    
    // Ability to display ad at top of Safe Area will soon be added to `displayAtBottomOfSafeAreaInView:` method of SDK
    @available(iOS 11.0, *)
    func displayAdAtBottomOfSafeArea() {
        let constraint = self.bottomAdView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
        display(adView: self.bottomAdView, anchorConstraint: constraint)
    }
    
    @available(iOS 11.0, *)
    func display(adView: UIView, anchorConstraint: NSLayoutConstraint) {
        let layoutGuide = self.view.safeAreaLayoutGuide
        adView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(adView)
        let constraints = [
            adView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
            anchorConstraint
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - YMAAdViewDelegate
    
    // Uncomment to open web links in in-app browser
//    func viewControllerForPresentingModalView() -> UIViewController! {
//        return self
//    }
    
    func adViewDidLoad(_ adView: YMAAdView!) {
        print("Ad loaded")
    }
    
    func adViewDidFailLoading(_ adView: YMAAdView!, error: Error!) {
        print("Ad failed loading. Error: \(error!)")
    }
    
    func adViewWillLeaveApplication(_ adView: YMAAdView!) {
        print("Ad will leave application")
    }
    
    func adViewWillPresentScreen(_ viewController: UIViewController!) {
        print("Ad will present screen")
    }

    func adViewDidDismissScreen(_ viewController: UIViewController!) {
        print("Ad did dismiss screen")
    }
    
}

