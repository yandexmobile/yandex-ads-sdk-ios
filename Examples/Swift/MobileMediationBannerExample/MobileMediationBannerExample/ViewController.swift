/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

private let adMobBlockID = "adf-279013/975832"
private let facebookBlockID = "adf-279013/975836"
private let moPubBlockID = "adf-279013/975834"
private let myTargetBlockID = "adf-279013/975835"
private let startAppBlockID = "adf-279013/1006423"
private let yandexBlockID = "adf-279013/975838"

class ViewController: UIViewController {

    private let blockIDs = [
        (adapter: "AdMob",    blockId: adMobBlockID),
        (adapter: "Facebook", blockId: facebookBlockID),
        (adapter: "MoPub",    blockId: moPubBlockID),
        (adapter: "myTarget", blockId: myTargetBlockID),
        (adapter: "StartApp", blockId: startAppBlockID),
        (adapter: "Yandex",   blockId: yandexBlockID)
    ]

    @IBOutlet private var container: UIView!
    @IBOutlet private var pickerView: UIPickerView!

    private var adView: YMAAdView?

    @IBAction func loadAd(_ sender: UIButton) {
        let adSize = YMAAdSize.fixedSize(with: YMAAdSizeBanner_320x50)
        let selectedBlockIndex = pickerView.selectedRow(inComponent: 0)
        /*
         Replace blockID with actual Block ID.
         Following demo block ids may be used for testing:
         AdMob mediation: adMobBlockID
         Facebook mediation: facebookBlockID
         MoPub mediation: moPubBlockID
         MyTarget mediation: myTargetBlockID
         StartApp mediation: startAppBlockID
         Yandex: yandexBlockID
         */
        let blockID = blockIDs[selectedBlockIndex].blockId
        adView?.removeFromSuperview()
        adView = YMAAdView(blockID: blockID, adSize: adSize, delegate: self)
        adView?.loadAd()
    }
}

// MARK: - YMAAdViewDelegate

extension ViewController: YMAAdViewDelegate {
    func adViewDidLoad(_ adView: YMAAdView!) {
        print("Ad loaded")
        adView.displayAtBottom(in: container)
    }

    func adViewDidFailLoading(_ adView: YMAAdView!, error: Error!) {
        print("Ad failed loading. Error: \(String(describing: error))")
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return blockIDs.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return blockIDs[row].adapter
    }
}

