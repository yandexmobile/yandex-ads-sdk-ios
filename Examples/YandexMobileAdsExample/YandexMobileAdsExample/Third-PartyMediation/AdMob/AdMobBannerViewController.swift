/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import GoogleMobileAds

class AdMobBannerViewController: UIViewController {
    private var bannerView: GADBannerView!
    @IBOutlet var loadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAdMob()
        // Replace ca-app-pub-4449457472880521/8471882114 with Ad Unit ID generated at https://apps.admob.com".
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView.adUnitID = "ca-app-pub-4449457472880521/8471882114"
        bannerView.delegate = self
        bannerView.rootViewController = self
        bannerView.translatesAutoresizingMaskIntoConstraints = false
    }

    func initializeAdMob() {
        loadButton.isUserInteractionEnabled = false
        GADMobileAds.sharedInstance().start { [weak self] _ in
            DispatchQueue.main.async {
                self?.loadButton.isUserInteractionEnabled = true
            }
        }
    }

    func addBannerView(banner: GADBannerView) {
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
        bannerView.load(GADRequest())
    }
}

extension AdMobBannerViewController: GADBannerViewDelegate {
    func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
        addBannerView(banner: bannerView)
        print("Ad view did receive ad")
    }

    func bannerView(_: GADBannerView, didFailToReceiveAdWithError error: Error) {
        print("Ad view did fail to receive ad with error: \(error)")
    }
}
