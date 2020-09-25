/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import GoogleMobileAds

class ViewController: UIViewController {
    private var adLoader: GADAdLoader!
    private var adView: UnifiedNativeAdView?

    override func viewDidLoad() {
        super.viewDidLoad()

        createAdView()
        createLoader()
    }

    @IBAction func loadAd(_ sender: UIButton) {
        adLoader.load(GADRequest())
    }
    
    private func createAdView() {
        adView = Bundle.main.loadNibNamed("UnifiedNativeAdView",
                                          owner: nil,
                                          options: nil)?.first as? UnifiedNativeAdView
        if let adView = adView {
            adView.isHidden = true
            addView(adView)
        }
    }

    private func addView(_ adView: UIView) {
        adView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(adView)
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

    private func createLoader() {
        // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com".
        adLoader = GADAdLoader(adUnitID: "ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY",
                               rootViewController: self,
                               adTypes: [.unifiedNative],
                               options: nil)
        adLoader.delegate = self
    }
}

extension ViewController: GADUnifiedNativeAdLoaderDelegate, GADUnifiedNativeAdDelegate {
    func adLoader(_ adLoader: GADAdLoader, didReceive nativeAd: GADUnifiedNativeAd) {

        guard let adView = adView else { return }

        nativeAd.delegate = self
        adView.nativeAd = nativeAd
        adView.configureAssetViews()
        adView.isHidden = false
    }

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: GADRequestError) {
        print("Ad loader did fail to receive ad with error: \(error)")
    }
}
