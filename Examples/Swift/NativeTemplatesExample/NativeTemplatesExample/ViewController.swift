/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class ViewController: UIViewController, YMANativeAdDelegate, YMANativeAdLoaderDelegate {
    
    var adLoader: YMANativeAdLoader!
    var bannerView: YMANativeBannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Replace demo R-M-DEMO-native-c with actual Block ID.
        // Please, note, that configured image sizes don't affect demo ads.
        // Following demo Block IDs may be used for testing:
        // R-M-DEMO-native-video
        // R-M-DEMO-native-c
        // R-M-DEMO-native-i

        let configuration = YMANativeAdLoaderConfiguration(blockID: "R-M-DEMO-native-c",
                                                           imageSizes: [kYMANativeImageSizeMedium],
                                                           loadImagesAutomatically: true)
        self.adLoader = YMANativeAdLoader(configuration: configuration)
        self.adLoader.delegate = self
        loadAd()
    }
    
    @IBAction func loadAd() {
        self.adLoader.loadAd(with: nil)
    }
    
    func didLoadAd(_ ad: YMANativeGenericAd) {
        ad.delegate = self
        self.bannerView?.removeFromSuperview()
        let bannerView = YMANativeBannerView(frame: CGRect.zero)
        bannerView.ad = ad
        self.view.addSubview(bannerView)
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        self.bannerView = bannerView
        
        if #available(iOS 11.0, *) {
            displayAdAtBottomOfSafeArea();
        } else {
            displayAdAtBottom();
        }
    }
    
    func displayAdAtBottom() {
        let views = ["bannerView" : self.bannerView!]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[bannerView]-(10)-|",
                                                        options: [],
                                                        metrics: nil,
                                                        views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[bannerView]-(10)-|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: views)
        self.view.addConstraints(horizontal)
        self.view.addConstraints(vertical)
    }
    
    @available(iOS 11.0, *)
    func displayAdAtBottomOfSafeArea() {
        let bannerView = self.bannerView!
        let layoutGuide = self.view.safeAreaLayoutGuide
        let constraints = [
            bannerView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            bannerView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            bannerView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    // MARK: - YMANativeAdDelegate
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeAppInstallAd) {
        print("Loaded App Install ad")
        didLoadAd(ad)
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeContentAd) {
        print("Loaded Content ad")
        didLoadAd(ad)
    }

    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeImageAd) {
        print("Loaded Image ad")
        didLoadAd(ad)
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didFailLoadingWithError error: Error) {
        print("Native ad loading error: \(error)")
    }
    
    // MARK: - YMANativeAdLoaderDelegate
    
    // Uncomment to open web links in in-app browser
//    func viewControllerForPresentingModalView() -> UIViewController {
//        return self
//    }
    
    func nativeAdWillLeaveApplication(_ ad: Any!) {
        print("Will leave application")
    }
    
    func nativeAd(_ ad: Any!, willPresentScreen viewController: UIViewController?) {
        print("Will present screen")
    }
    
    func nativeAd(_ ad: Any!, didDismissScreen viewController: UIViewController?) {
        print("Did dismiss screen")
    }
    
}

