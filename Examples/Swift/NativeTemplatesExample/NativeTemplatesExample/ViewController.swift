/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class ViewController: UIViewController {
    
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

    func displayAdAtBottom() {
        guard let bannerView = bannerView else { return }

        bannerView.translatesAutoresizingMaskIntoConstraints = false
        var layoutGuide = self.view.layoutMarginsGuide
        if #available(iOS 11.0, *) {
            layoutGuide = self.view.safeAreaLayoutGuide
        }
        let constraints = [
            bannerView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            bannerView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            bannerView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension ViewController: YMANativeAdLoaderDelegate {
    
    func nativeAdLoader(_ loader: YMANativeAdLoader, didLoad ad: YMANativeAd) {
        self.bannerView?.removeFromSuperview()
        ad.delegate = self

        let bannerView = YMANativeBannerView()
        bannerView.ad = ad
        self.view.addSubview(bannerView)
        self.bannerView = bannerView
        displayAdAtBottom();
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader, didFailLoadingWithError error: Error) {
        print("Native ad loading error: \(error)")
    }

}

extension ViewController: YMANativeAdDelegate {
    
    // Uncomment to open web links in in-app browser
//    func viewControllerForPresentingModalView() -> UIViewController? {
//        return self
//    }
    
    func nativeAdWillLeaveApplication(_ ad: YMANativeAd) {
        print("Will leave application")
    }
    
    func nativeAd(_ ad: YMANativeAd, willPresentScreen viewController: UIViewController?) {
        print("Will present screen")
    }
    
    func nativeAd(_ ad: YMANativeAd, didDismissScreen viewController: UIViewController?) {
        print("Did dismiss screen")
    }
    
}

