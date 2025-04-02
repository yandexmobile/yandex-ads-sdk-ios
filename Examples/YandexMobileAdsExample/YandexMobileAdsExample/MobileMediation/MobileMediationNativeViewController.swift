/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

private let adMobAdUnitID = "demo-native-admob"
private let mintegralAdUnitID = "demo-native-mintegral"
private let myTargetAdUnitID = "demo-native-mytarget"
private let yandexAdUnitID = "demo-native-content-yandex"
private let vungleAdUnitID = "demo-native-vungle"

class MobileMediationNativeViewController: UIViewController {
#if COCOAPODS
    private let adUnitIDs = [
        (adapter: "AdMob", adUnitID: adMobAdUnitID),
        (adapter: "Mintegral", adUnitID: mintegralAdUnitID),
        (adapter: "MyTarget", adUnitID: myTargetAdUnitID),
        (adapter: "Vungle", adUnitID: vungleAdUnitID),
        (adapter: "Yandex", adUnitID: yandexAdUnitID)
    ]
#else
    private let adUnitIDs = [
        (adapter: "AdMob", adUnitID: adMobAdUnitID),
        (adapter: "Mintegral", adUnitID: mintegralAdUnitID),
        (adapter: "MyTarget", adUnitID: myTargetAdUnitID),
        (adapter: "Vungle", adUnitID: vungleAdUnitID),
        (adapter: "Yandex", adUnitID: yandexAdUnitID)
    ]
#endif

    @IBOutlet private var pickerView: UIPickerView!
    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var stateLabel: UILabel!
    @IBOutlet private var loadButton: UIButton!

    private var adView: NativeAdView?
    private var adLoader: NativeAdLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        adView = NativeAdView.nib
        addAdView()
        adView?.isHidden = true
        adLoader = NativeAdLoader()
        adLoader?.delegate = self
        adView?.accessibilityIdentifier = CommonAccessibility.bannerView
        
        stateLabel.accessibilityIdentifier = CommonAccessibility.stateLabel
        loadButton.accessibilityIdentifier = CommonAccessibility.loadButton
    }
    
    @IBAction func load(_ sender: Any) {
        adView?.isHidden = true
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        /*
         Replace adUnitID with actual Ad Unit ID.
         Following demo ad unit ids may be used for testing:
         AdMob mediation: adMobAdUnitID
         MyTarget mediation: myTargetAdUnitID
         Yandex: yandexAdUnitID
         */
        let adUnitID = adUnitIDs[selectedIndex].adUnitID
        let requestConfiguration = NativeAdRequestConfiguration(adUnitID: adUnitID)
        adLoader?.loadAd(with: requestConfiguration)
        
        stateLabel.text = nil
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

extension MobileMediationNativeViewController: NativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: NativeAdLoader, didLoad ad: NativeAd) {
        guard let adView = adView else { return }

        ad.delegate = self
        adView.isHidden = false
        do {
            try ad.bind(with: adView)
            adView.configureAssetViews()
            stateLabel.text = StateUtils.loaded()
        } catch {
            print("Binding error: \(error)")
            stateLabel.text = StateUtils.loadError(error)
        }
    }
    
    func nativeAdLoader(_ loader: NativeAdLoader, didFailLoadingWithError error: Error) {
        print("Native ad loading error: \(error)")
        stateLabel.text = StateUtils.loadError(error)
    }
}

// MARK: - YMANativeAdDelegate

extension MobileMediationNativeViewController: NativeAdDelegate {
    func close(_ ad: NativeAd) {
        adView?.isHidden = true
    }

    func nativeAdWillLeaveApplication(_: NativeAd) {
        print("native will leave application")
    }

    func nativeAd(_ ad: NativeAd, willPresentScreen viewController: UIViewController?) {
        print("native will present screen")
    }

    func nativeAd(_ ad: NativeAd, didDismissScreen viewController: UIViewController?) {
        print("native will dismiss screen")
    }

    func nativeAd(_ ad: NativeAd, didTrackImpressionWith impressionData: ImpressionData?) {
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
