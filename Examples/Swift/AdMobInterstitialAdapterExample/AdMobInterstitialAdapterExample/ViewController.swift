/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import GoogleMobileAds

class ViewController: UIViewController {
    var interstitial: GADInterstitial?

    @IBAction func loadAd(_ sender: UIButton) {
        // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com".
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY")
        interstitial!.delegate = self
        interstitial!.load(GADRequest())
    }
    
    @IBAction func showAd(_ sender: UIButton) {
        if interstitial?.isReady == true {
            interstitial!.present(fromRootViewController: self)
        } else {
            print("Interstitial ad wasn't ready")
        }
    }
}

extension ViewController: GADInterstitialDelegate {
    func interstitialDidReceiveAd(_ ad: GADInterstitial) {
        print("Interstitial did receive ad")
    }

    func interstitial(_ ad: GADInterstitial, didFailToReceiveAdWithError error: GADRequestError) {
        print("Did fail to receive ad with error: \(error)")
    }
}
