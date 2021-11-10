/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

private let adMobBlockID = "adf-279013/975874"
private let facebookBlockID = "adf-279013/975877"
private let moPubBlockID = "adf-279013/975875"
private let myTargetBlockID = "adf-279013/975876"
private let yandexBlockID = "adf-279013/975878"

class MobileMediationNativeViewController: UIViewController {
    private let blockIDs = [
        (adapter: "AdMob", blockID: adMobBlockID),
        (adapter: "Facebook", blockID: facebookBlockID),
        (adapter: "MoPub", blockID: moPubBlockID),
        (adapter: "myTarget", blockID: myTargetBlockID),
        (adapter: "Yandex", blockID: yandexBlockID)
    ]

    @IBOutlet private var pickerView: UIPickerView!
    @IBOutlet weak var scrollView: UIScrollView!

    private var adView: NativeAdView?
    private var adLoader: YMANativeAdLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MediationTestsConfigurator.enableTestMode()
        adView = NativeAdView.nib
        addAdView()
        adView?.isHidden = true
        adLoader = YMANativeAdLoader()
        adLoader?.delegate = self
    }
    
    @IBAction func load(_ sender: Any) {
        adView?.isHidden = true
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        /*
         Replace blockID with actual Block ID.
         Following demo block ids may be used for testing:
         AdMob mediation: adMobBlockID
         Facebook mediation: facebookBlockID
         MoPub mediation: moPubBlockID
         MyTarget mediation: myTargetBlockID
         Yandex: yandexBlockID
         */
        let blockID = blockIDs[selectedIndex].blockID
        let requestConfiguration = YMANativeAdRequestConfiguration(blockID: blockID)
        adLoader?.loadAd(with: requestConfiguration)
    }

    func addAdView() {
        guard let adView = adView else { return }

        adView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(adView)

        let constraints = [
            adView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            adView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            adView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            adView.topAnchor.constraint(equalTo: scrollView.topAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - YMANativeAdLoaderDelegate

extension MobileMediationNativeViewController: YMANativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: YMANativeAdLoader, didLoad ad: YMANativeAd) {
        guard let adView = adView else { return }

        ad.delegate = self
        adView.isHidden = false
        do {
            try ad.bind(with: adView)
            adView.configureAssetViews()
        } catch {
            print("Binding error: \(error)")
        }
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader, didFailLoadingWithError error: Error) {
        print("Native ad loading error: \(error)")
    }
}

// MARK: - YMANativeAdDelegate

extension MobileMediationNativeViewController: YMANativeAdDelegate {
    func close(_ ad: YMANativeAd) {
        adView?.isHidden = true
    }

    func nativeAdWillLeaveApplication(_: YMANativeAd) {
        print("native will leave application")
    }

    func nativeAd(_ ad: YMANativeAd, willPresentScreen viewController: UIViewController?) {
        print("native will present screen")
    }

    func nativeAd(_ ad: YMANativeAd, didDismissScreen viewController: UIViewController?) {
        print("native will dismiss screen")
    }

    func nativeAd(_ ad: YMANativeAd, didTrackImpressionWith impressionData: YMAImpressionData?) {
        print("native did track impression")
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension MobileMediationNativeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return blockIDs.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return blockIDs[row].adapter
    }
}
