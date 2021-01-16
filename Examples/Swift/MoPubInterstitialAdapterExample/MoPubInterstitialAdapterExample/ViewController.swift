/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import MoPub

class ViewController: UIViewController {

    // Replace XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX with Ad Unit ID generated at https://app.mopub.com.
    let adUnitID = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
    
    var interstitial: MPInterstitialAdController?

    @IBOutlet weak var loadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeMoPub()
        interstitial = MPInterstitialAdController(forAdUnitId: adUnitID)
        interstitial?.delegate = self
    }

    @IBAction func loadAd(_ sender: UIButton) {
        interstitial?.loadAd()
    }

    @IBAction func showAd(_ sender: UIButton) {
        interstitial?.show(from: self)
    }

    private func initializeMoPub() {
        let configuration = MPMoPubConfiguration(adUnitIdForAppInitialization: adUnitID)
        MoPub.sharedInstance().initializeSdk(with: configuration) {
            DispatchQueue.main.async { [weak self] in
                self?.loadButton.isUserInteractionEnabled = true
            }
        }
    }
}

extension ViewController: MPInterstitialAdControllerDelegate {

    func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
        print("Interstitial did load ad")
    }

    func interstitialDidFail(toLoadAd interstitial: MPInterstitialAdController!, withError error: Error!) {
        print("Interstitial did fail to load ad with error: \(String(describing: error))")
    }
}
