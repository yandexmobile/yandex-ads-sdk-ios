/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import GoogleMobileAds

class ViewController: UIViewController {

    private var bannerView: GADBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com".
        bannerView = GADBannerView(adSize: kGADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY"
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.translatesAutoresizingMaskIntoConstraints = false
    }

    func addBannerView(banner: GADBannerView) {
        banner.removeFromSuperview()
        view.addSubview(banner)
        view.addConstraints([NSLayoutConstraint(item: banner,
                                                attribute: .bottom,
                                                relatedBy: .equal,
                                                toItem: bottomLayoutGuide,
                                                attribute: .top,
                                                multiplier: 1,
                                                constant: 0),
                             NSLayoutConstraint(item: banner,
                                                attribute: .centerX,
                                                relatedBy: .equal,
                                                toItem: view,
                                                attribute: .centerX,
                                                multiplier: 1,
                                                constant: 0)])
    }

    @IBAction func loadAd(_ sender: UIButton) {
        bannerView.load(GADRequest())
    }
}

extension ViewController: GADBannerViewDelegate {
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerView(banner: bannerView)
        print("Ad view did receive ad")
    }

    func adView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: GADRequestError) {
        print("Ad view did fail to receive ad with error: \(error)")
    }
}
