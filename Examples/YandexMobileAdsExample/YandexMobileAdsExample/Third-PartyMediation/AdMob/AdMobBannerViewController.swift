/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import GoogleMobileAds

class AdMobBannerViewController: UIViewController {
    private var bannerView: GoogleMobileAds.BannerView!
    @IBOutlet var loadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAdMob()
        // Replace ca-app-pub-4651572829019143/7264255923 with Ad Unit ID generated at https://apps.admob.com".
        bannerView = GoogleMobileAds.BannerView(adSize: GoogleMobileAds.AdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-4651572829019143/7264255923"
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.translatesAutoresizingMaskIntoConstraints = false
    }

    func initializeAdMob() {
        loadButton.isUserInteractionEnabled = false
        GoogleMobileAds.MobileAds.shared.start { [weak self] _ in
            DispatchQueue.main.async {
                self?.loadButton.isUserInteractionEnabled = true
            }
        }
    }

    func addBannerView(banner: GoogleMobileAds.BannerView) {
        banner.removeFromSuperview()
        view.addSubview(banner)

        let layoutGuide = view.layoutMarginsGuide
        let constraints = [
            banner.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            banner.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @IBAction func loadAd(_: UIButton) {
        bannerView.load(GoogleMobileAds.Request())
    }
}

extension AdMobBannerViewController: GoogleMobileAds.BannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GoogleMobileAds.BannerView) {
        addBannerView(banner: bannerView)
        print("Ad view did receive ad")
    }

    func bannerView(_: GoogleMobileAds.BannerView, didFailToReceiveAdWithError error: Error) {
        print("Ad view did fail to receive ad with error: \(error)")
    }
}
