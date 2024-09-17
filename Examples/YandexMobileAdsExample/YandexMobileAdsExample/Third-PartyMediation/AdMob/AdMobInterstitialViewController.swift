/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import GoogleMobileAds

class AdMobInterstitialViewController: UIViewController {
    var interstitial: GADInterstitialAd?
    @IBOutlet var showButton: UIButton!
    @IBOutlet var loadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAdMob()
    }

    func initializeAdMob() {
        loadButton.isUserInteractionEnabled = false
        GADMobileAds.sharedInstance().start { [weak self] _ in
            DispatchQueue.main.async {
                self?.loadButton.isUserInteractionEnabled = true
            }
        }
    }

    @IBAction func loadAd(_: UIButton) {
        showButton.isEnabled = false

        // Replace ca-app-pub-4651572829019143/3054278095 with Ad Unit ID generated at https://apps.admob.com".
        GADInterstitialAd.load(withAdUnitID: "ca-app-pub-4651572829019143/3054278095",
                               request: GADRequest()) { [self] ad, error in
            if let error = error {
                print("Did fail to receive ad with error: \(error.localizedDescription)")
            } else {
                print("Did receive ad")
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
                self.showButton.isEnabled = true
            }
        }
    }

    @IBAction func showAd(_: UIButton) {
        interstitial?.present(fromRootViewController: self)
        showButton.isEnabled = false
    }
}

extension AdMobInterstitialViewController: GADFullScreenContentDelegate {
    func ad(_: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Did fail to present ad with error: \(error.localizedDescription)")
    }
}
