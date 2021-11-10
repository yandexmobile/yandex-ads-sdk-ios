/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import MoPubSDK

class MoPubInterstitialViewController: UIViewController {
    // Replace c2ae143bf0c344dc931c7bed9397b46c with Ad Unit ID generated at https://app.mopub.com.
    let adUnitID = "c2ae143bf0c344dc931c7bed9397b46c"
    
    var interstitial: MPInterstitialAdController?

    @IBOutlet weak var loadButton: UIButton!
    @IBOutlet weak var showButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeMoPub()
        interstitial = MPInterstitialAdController(forAdUnitId: adUnitID)
        interstitial?.delegate = self
    }

    @IBAction func loadAd(_ sender: UIButton) {
        self.showButton.isEnabled = false
        interstitial?.loadAd()
    }

    @IBAction func showAd(_ sender: UIButton) {
        interstitial?.show(from: self)
    }

    private func initializeMoPub() {
        let isMoPubInitialized = MoPub.sharedInstance().isSdkInitialized
        if !isMoPubInitialized {
            loadButton.isUserInteractionEnabled = false
            let configuration = MPMoPubConfiguration(adUnitIdForAppInitialization: adUnitID)
            MoPub.sharedInstance().initializeSdk(with: configuration) { [weak self] in
                DispatchQueue.main.async {
                    self?.loadButton.isUserInteractionEnabled = true
                }
            }
        }
    }
}

extension MoPubInterstitialViewController: MPInterstitialAdControllerDelegate {

    func interstitialDidLoadAd(_ interstitial: MPInterstitialAdController!) {
        self.showButton.isEnabled = true
        print("Interstitial did load ad")
    }

    func interstitialDidFail(toLoadAd interstitial: MPInterstitialAdController!, withError error: Error!) {
        print("Interstitial did fail to load ad with error: \(String(describing: error))")
    }

    func interstitialWillAppear(_ interstitial: MPInterstitialAdController!) {
        print("Interstitial will appear")
    }

    func interstitialDidAppear(_ interstitial: MPInterstitialAdController!) {
        print("Interstitial did appear")
    }

    func interstitialWillDismiss(_ interstitial: MPInterstitialAdController!) {
        print("Interstitial will sidmiss")
    }

    func interstitialDidDismiss(_ interstitial: MPInterstitialAdController!) {
        print("Interstitial did dismiss")
    }

    func interstitialDidReceiveTapEvent(_ interstitial: MPInterstitialAdController!) {
        print("Interstitial did receive tap event")
    }

    func mopubAd(_ ad: MPMoPubAd, didTrackImpressionWith impressionData: MPImpressionData?) {
        print("Interstitial did track impression")
    }
}
