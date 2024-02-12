/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

private let adMobAdUnitID = "demo-banner-admob"
private let mintegralAdUnitID = "demo-banner-mintegral"
private let myTargetAdUnitID = "demo-banner-mytarget"
private let chartboostAdUnitID = "demo-banner-chartboost"
private let adColonyAdUnitID = "demo-banner-adcolony"
private let bigoAdsAdUnitID = "demo-banner-bigoads"
private let inMobiAdsAdUnitID = "demo-banner-inmobi"
private let ironSourceAdUnitID = "demo-banner-ironsource"
private let startAppAdUnitID = "demo-banner-startapp"
private let yandexAdUnitID = "demo-banner-yandex"

class MobileMediationBannerViewController: UIViewController {
    
    private let adUnitIDs = [
        (adapter: "AdColony", adUnitID: adColonyAdUnitID),
        (adapter: "BigoAds", adUnitID: bigoAdsAdUnitID),
        (adapter: "Chartboost", adUnitID: chartboostAdUnitID),
        (adapter: "AdMob", adUnitID: adMobAdUnitID),
        (adapter: "InMobi", adUnitID: inMobiAdsAdUnitID),
        (adapter: "Mintegral", adUnitID: mintegralAdUnitID),
        (adapter: "MyTarget", adUnitID: myTargetAdUnitID),
        (adapter: "IronSource", adUnitID: ironSourceAdUnitID),
        (adapter: "StartApp", adUnitID: startAppAdUnitID),
        (adapter: "Yandex", adUnitID: yandexAdUnitID)
    ]

    @IBOutlet private var pickerView: UIPickerView!
    @IBOutlet private var stateLabel: UILabel!
    @IBOutlet private var loadButton: UIButton!

    private var adView: YMAAdView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateLabel.accessibilityIdentifier = CommonAccessibility.stateLabel
        loadButton.accessibilityIdentifier = CommonAccessibility.loadButton
    }

    @IBAction func loadAd(_ sender: UIButton) {
        let adSize = YMABannerAdSize.inlineSize(withWidth: 320, maxHeight: 50)
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
        adView?.accessibilityIdentifier = CommonAccessibility.bannerView
        
        stateLabel.text = nil
    }
}

// MARK: - YMAAdViewDelegate

extension MobileMediationBannerViewController: YMAAdViewDelegate {
    func adViewDidLoad(_ adView: YMAAdView) {
        print("ad loaded")
        adView.displayAtBottom(in: view)
        stateLabel.text = StateUtils.loaded()
    }

    func adViewDidFailLoading(_ adView: YMAAdView, error: Error) {
        print("ad failed loading. Error: \(String(describing: error))")
        stateLabel.text = StateUtils.loadError(error)
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

