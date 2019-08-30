/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import MoPub
import YandexMobileAds
import YandexMobileAdsMoPubAdapters

class ViewController: UIViewController {
    // Replace XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX with Ad Unit ID generated at https://app.mopub.com.
    let adUnit = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

    var rendererConfigurations: [MPNativeAdRendererConfiguration]?
    var adView : UIView?

    @IBOutlet weak var loadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureRenderer()
        let configuration = MPMoPubConfiguration(adUnitIdForAppInitialization: adUnit);
        MoPub.sharedInstance().initializeSdk(with: configuration) {
            DispatchQueue.main.async { [weak self] in
                self?.loadButton.isUserInteractionEnabled = true
            }
        }
    }
    
    @IBAction func loadAd(_ sender: UIButton) {
        loadAdWithAdUnit(adUnit: adUnit)
    }

    private func configureRenderer() {
        let settings = MPStaticNativeAdRendererSettings()
        settings.renderingViewClass = NativeAdView.self
        let commonConfig: MPNativeAdRendererConfiguration =
            MPStaticNativeAdRenderer.rendererConfiguration(with: settings)
        let yandexConfig: MPNativeAdRendererConfiguration =
            YMANativeCustomEventAdRenderer.rendererConfiguration(with: settings)
        self.rendererConfigurations = [commonConfig, yandexConfig];
    }

    private func loadAdWithAdUnit(adUnit: String) {
        let adRequest =
            MPNativeAdRequest(adUnitIdentifier: adUnit, rendererConfigurations: self.rendererConfigurations)
        adRequest?.start { (request, ad, error) in
            if error != nil {
                print("Loading error \(error!.localizedDescription)")
            } else {
                self.display(for: ad)
                print("Received Native Ad")
            }
        }
    }

    private func display(for ad: MPNativeAd?) {
        self.adView?.removeFromSuperview()
        guard let nativeAd = ad, let adView = try? nativeAd.retrieveAdView() else { return }
        self.addView(adView)
        self.adView = adView
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
}
