/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

private let adMobAdUnitID = "adf-279013/975874"
private let facebookAdUnitID = "adf-279013/975877"
private let myTargetAdUnitID = "adf-279013/975876"
private let yandexAdUnitID = "adf-279013/975878"

class MobileMediationNativeViewController: UIViewController {
    private let adUnitIDs = [
        (adapter: "AdMob", adUnitID: adMobAdUnitID),
        (adapter: "Facebook", adUnitID: facebookAdUnitID),
        (adapter: "myTarget", adUnitID: myTargetAdUnitID),
        (adapter: "Yandex", adUnitID: yandexAdUnitID)
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
         Replace adUnitID with actual Ad Unit ID.
         Following demo ad unit ids may be used for testing:
         AdMob mediation: adMobAdUnitID
         Facebook mediation: facebookAdUnitID
         MyTarget mediation: myTargetAdUnitID
         Yandex: yandexAdUnitID
         */
        let adUnitID = adUnitIDs[selectedIndex].adUnitID
        let requestConfiguration = YMANativeAdRequestConfiguration(adUnitID: adUnitID)
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
        return adUnitIDs.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return adUnitIDs[row].adapter
    }
}
