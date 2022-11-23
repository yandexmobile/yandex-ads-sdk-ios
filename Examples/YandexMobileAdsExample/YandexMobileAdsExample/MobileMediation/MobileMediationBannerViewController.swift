/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

private let adMobAdUnitID = "demo-banner-admob"
private let mintegralAdUnitID = "demo-banner-mintegral"
private let myTargetAdUnitID = "demo-banner-mytarget"
private let yandexAdUnitID = "demo-banner-yandex"

class MobileMediationBannerViewController: UIViewController {
    private let adUnitIDs = [
        (adapter: "AdMob",     adUnitID: adMobAdUnitID),
        (adapter: "Mintegral", adUnitID: mintegralAdUnitID),
        (adapter: "myTarget",  adUnitID: myTargetAdUnitID),
        (adapter: "Yandex",    adUnitID: yandexAdUnitID)
    ]

    @IBOutlet private var pickerView: UIPickerView!

    private var adView: YMAAdView?

    @IBAction func loadAd(_ sender: UIButton) {
        let adSize = YMAAdSize.flexibleSize(with: .init(width: 320, height: 50))
        let selectedBlockIndex = pickerView.selectedRow(inComponent: 0)
        /*
         Replace adUnitID with actual Ad unitt ID.
         Following demo ad unit ids may be used for testing:
         AdMob mediation: adMobAdUnitID
         MyTarget mediation: myTargetAdUnitID
         Yandex: yandexAdUnitID
         */
        let adUnitID = adUnitIDs[selectedBlockIndex].adUnitID
        adView?.removeFromSuperview()
        adView = YMAAdView(adUnitID: adUnitID, adSize: adSize)
        adView?.delegate = self
        adView?.loadAd()
    }
}

// MARK: - YMAAdViewDelegate

extension MobileMediationBannerViewController: YMAAdViewDelegate {
    func adViewDidLoad(_ adView: YMAAdView) {
        print("ad loaded")
        adView.displayAtBottom(in: view)
    }

    func adViewDidFailLoading(_ adView: YMAAdView, error: Error) {
        print("ad failed loading. Error: \(String(describing: error))")
    }

    func adViewWillLeaveApplication(_ adView: YMAAdView) {
        print("ad view will leave application")
    }

    func adView(_ adView: YMAAdView, willPresentScreen viewController: UIViewController?) {
        print("ad view will present screen")
    }

    func adView(_ adView: YMAAdView, didDismissScreen viewController: UIViewController?) {
        print("ad view did dismiss screen")
    }

    func adView(_ adView: YMAAdView, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print("ad view did track impression with")
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension MobileMediationBannerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return adUnitIDs.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return adUnitIDs[row].adapter
    }
}

