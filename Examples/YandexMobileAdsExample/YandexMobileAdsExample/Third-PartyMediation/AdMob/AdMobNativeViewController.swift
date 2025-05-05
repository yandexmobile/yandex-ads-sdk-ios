/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import GoogleMobileAds

class AdMobNativeViewController: UIViewController {
    private var adLoader: GoogleMobileAds.AdLoader?
    private var adView: AdMobNativeAdView?
    @IBOutlet var loadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAdMob()
        createAdView()
        createLoader()
    }

    func initializeAdMob() {
        loadButton.isUserInteractionEnabled = false
        GoogleMobileAds.MobileAds.shared.start { [weak self] _ in
            DispatchQueue.main.async {
                self?.loadButton.isUserInteractionEnabled = true
            }
        }
    }

    @IBAction func loadAd(_: UIButton) {
        adLoader?.load(GoogleMobileAds.Request())
    }

    private func createAdView() {
        adView = Bundle.main.loadNibNamed("AdMobNativeAdView",
                                          owner: nil,
                                          options: nil)?.first as? AdMobNativeAdView
        if let adView = adView {
            adView.isHidden = true
            addView(adView)
        }
    }

    private func addView(_ adView: UIView) {
        adView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adView)
        let layoutGuide = view.layoutMarginsGuide
        let constraints = [
            adView.leftAnchor.constraint(equalTo: layoutGuide.leftAnchor),
            adView.rightAnchor.constraint(equalTo: layoutGuide.rightAnchor),
            adView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    private func createLoader() {
        // Replace ca-app-pub-4651572829019143/9595635718 with Ad Unit ID generated at https://apps.admob.com".
        adLoader = GoogleMobileAds.AdLoader(
            adUnitID: "ca-app-pub-4651572829019143/9595635718",
            rootViewController: self,
            adTypes: [.native],
            options: nil
        )
        adLoader?.delegate = self
    }
}

extension AdMobNativeViewController: GoogleMobileAds.NativeAdLoaderDelegate {
    func adLoader(_: GoogleMobileAds.AdLoader, didReceive nativeAd: GoogleMobileAds.NativeAd) {
        guard let adView = adView else { return }

        nativeAd.delegate = self
        adView.nativeAd = nativeAd
        adView.configureAssetViews()
        adView.isHidden = false
    }

    func adLoader(_: GoogleMobileAds.AdLoader, didFailToReceiveAdWithError error: Error) {
        print("Ad loader did fail to receive ad with error: \(error.localizedDescription)")
    }
}

// MARK: - GoogleMobileAds.NativeAdDelegate implementation

extension AdMobNativeViewController: GoogleMobileAds.NativeAdDelegate {
    func nativeAdDidRecordClick(_: GoogleMobileAds.NativeAd) {
        print("\(#function) called")
    }

    func nativeAdDidRecordImpression(_: GoogleMobileAds.NativeAd) {
        print("\(#function) called")
    }
}
