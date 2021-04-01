/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import GoogleMobileAds

class ViewController: UIViewController {
    var interstitial: GADInterstitialAd?
    @IBOutlet weak var showButton: UIButton!

    @IBAction func loadAd(_ sender: UIButton) {
        self.showButton.isEnabled = false

        // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com".
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY",
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
    
    @IBAction func showAd(_ sender: UIButton) {
        interstitial?.present(fromRootViewController: self)
    }
}

extension ViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Did fail to present ad with error: \(error.localizedDescription)")
    }
}
