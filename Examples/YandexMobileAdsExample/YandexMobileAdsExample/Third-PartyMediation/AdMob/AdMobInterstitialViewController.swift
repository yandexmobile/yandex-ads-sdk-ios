/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import GoogleMobileAds

class AdMobInterstitialViewController: UIViewController {
    var interstitial: GADInterstitialAd?
    @IBOutlet weak var showButton: UIButton!
    @IBOutlet weak var loadButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeAdMob()
    }

    func initializeAdMob() {
        let initializationStatus =
            GADMobileAds.sharedInstance().initializationStatus.adapterStatusesByClassName[GADMobileAds.className()]
        if (initializationStatus?.state == .notReady) {
            self.loadButton.isUserInteractionEnabled = false
            GADMobileAds.sharedInstance().start { [weak self] status in
                let initializationStatus = status.adapterStatusesByClassName[GADMobileAds.className()]?.state == .ready
                DispatchQueue.main.async {
                    self?.loadButton.isUserInteractionEnabled = initializationStatus
                }
            }
        }
    }

    @IBAction func loadAd(_ sender: UIButton) {
        self.showButton.isEnabled = false

        // Replace ca-app-pub-XXXXXXXXXXXXXXXX/YYYYYYYYYY with Ad Unit ID generated at https://apps.admob.com".
        GADInterstitialAd.load(withAdUnitID:"ca-app-pub-4449457472880521/5935222734",
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

extension AdMobInterstitialViewController: GADFullScreenContentDelegate {
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("Did fail to present ad with error: \(error.localizedDescription)")
    }
}