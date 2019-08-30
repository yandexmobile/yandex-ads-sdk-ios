/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

class ViewController: UIViewController {
    private var contentAdView: NativeContentAdView?
    private var appInstallView: NativeAppInstallAdView?
    private var imageAdView: NativeImageAdView?
    
    var adLoader: YMANativeAdLoader!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAdViews()
        hideAllViews()
        
        // Replace demo R-M-DEMO-native-c with actual Block ID
        // Following demo Block IDs may be used for testing:
        // R-M-DEMO-native-c
        // R-M-DEMO-native-i
        // R-M-DEMO-native-video
        let configuration = YMANativeAdLoaderConfiguration(blockID: "R-M-DEMO-native-c",
                                                           loadImagesAutomatically: true)
        
        adLoader = YMANativeAdLoader(configuration: configuration)
        adLoader.delegate = self
        adLoader.loadAd(with: nil)
    }
    
    private func loadAdViews() {
        contentAdView = Bundle.main.loadNibNamed("NativeContentAdView",
                                                 owner: nil,
                                                 options: nil)?.first as? NativeContentAdView
        if let myContentAdView = contentAdView {
            addAdView(myContentAdView)
        }
        
        appInstallView = Bundle.main.loadNibNamed("NativeAppInstallAdView",
                                                  owner: nil,
                                                  options: nil)?.first as? NativeAppInstallAdView
        if let myAppInstallView = appInstallView {
            addAdView(myAppInstallView)
        }
        
        imageAdView = Bundle.main.loadNibNamed("NativeImageAdView",
                                               owner: nil,
                                               options: nil)?.first as? NativeImageAdView
        if let myImageAdView = imageAdView {
            addAdView(myImageAdView)
        }
    }
    
    private func addAdView(_ adView: UIView) {
        adView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adView)
        let views = ["adView": adView]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[adView]-|",
                                                        options: [],
                                                        metrics: nil,
                                                        views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[adView]-|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: views)
        view.addConstraints(horizontal + vertical)
    }
    
    private func hideAllViews() {
        imageAdView?.isHidden = true
        appInstallView?.isHidden = true
        contentAdView?.isHidden = true
    }
    
    private func showAdView(_ adView: UIView) {
        adView.isHidden = false
    }
}

// MARK: - YMANativeAdLoaderDelegate

extension ViewController: YMANativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeImageAd) {
        guard let myImageAdView = imageAdView else { return }
        try? ad.bindImageAd(to: myImageAdView, delegate: self)
        showAdView(myImageAdView)
        myImageAdView.configureAssetViews()
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeContentAd) {
        guard let myContentAdView = contentAdView else { return }
        try? ad.bindContentAd(to: myContentAdView, delegate: self)
        showAdView(myContentAdView)
        myContentAdView.configureAssetViews()
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeAppInstallAd) {
        guard let myAppInstallView = appInstallView else { return }
        try? ad.bindAppInstallAd(to: myAppInstallView, delegate: self)
        showAdView(myAppInstallView)
        myAppInstallView.configureAssetViews()
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didFailLoadingWithError error: Error) {
        print("Native ad loading error: \(error)")
    }
}

// MARK: - YMANativeAdDelegate

extension ViewController: YMANativeAdDelegate {
    func closeNativeAd(_ ad: Any!) {
        print("Close native ad")
        hideAllViews()
    }
}
