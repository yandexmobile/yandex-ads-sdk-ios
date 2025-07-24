/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

class AdFoxNativeViewController: UIViewController {
    private var adView: NativeAdView?
    
    @IBOutlet private var stateLabel: UILabel!
    @IBOutlet private var loadButton: UIButton!

    var adLoader: NativeAdLoader!

    override func viewDidLoad() {
        super.viewDidLoad()

        adView = NativeAdView.nib
        adView?.isHidden = true

        adLoader = NativeAdLoader()
        adLoader.delegate = self
        
        adView?.accessibilityIdentifier = CommonAccessibility.bannerView
        loadButton.accessibilityIdentifier = CommonAccessibility.loadButton
        stateLabel.accessibilityIdentifier = CommonAccessibility.stateLabel
    }

    @IBAction func loadAd(_ sender: UIButton) {
        adView?.removeFromSuperview()
        var parameters = Dictionary<String, String>()
        parameters["adf_ownerid"] = "270901"
        parameters["adf_p1"] = "caboj"
        parameters["adf_p2"] = "fksh"
        parameters["adf_pfc"] = "bskug"
        parameters["adf_pfb"] = "fkjas"
        parameters["adf_pt"] = "b"
        // Replace demo demo-native-adfox with actual Ad Unit ID
        let requestConfiguration = MutableNativeAdRequestConfiguration(adUnitID: "demo-native-adfox")
        requestConfiguration.parameters = parameters
        adLoader.loadAd(with: requestConfiguration)
    }

    func addAdView() {
        guard let adView = adView else { return }

        adView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adView)
        let layoutGuide = self.view.layoutMarginsGuide
        let constraints = [
            adView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            adView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            adView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - YMANativeAdLoaderDelegate

extension AdFoxNativeViewController: NativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: NativeAdLoader, didLoad ad: NativeAd) {
        guard let adView = adView else { return }

        ad.delegate = self
        adView.isHidden = false
        do {
            try ad.bind(with: adView)
            adView.configureAssetViews()
            addAdView()
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

extension AdFoxNativeViewController: NativeAdDelegate {

    // Uncomment to open web links in in-app browser
//    func viewControllerForPresentingModalView() -> UIViewController? {
//        return self
//    }

    func nativeAdWillLeaveApplication(_ ad: NativeAd) {
        print("Will leave application")
    }

    func nativeAd(_ ad: NativeAd, willPresentScreen viewController: UIViewController?) {
        print("Will present screen")
    }

    func nativeAd(_ ad: NativeAd, didDismissScreen viewController: UIViewController?) {
        print("Did dismiss screen")
    }

    func close(_ ad: NativeAd) {
        adView?.isHidden = true
    }
}
