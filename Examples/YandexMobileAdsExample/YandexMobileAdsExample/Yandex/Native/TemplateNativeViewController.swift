/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

class TemplateNativeViewController: UIViewController {
    private var adView: YMANativeBannerView?

    var adLoader: YMANativeAdLoader!

    override func viewDidLoad() {
        super.viewDidLoad()

        adView = YMANativeBannerView()
        addAdView()
        adView?.isHidden = true

        adLoader = YMANativeAdLoader()
        adLoader.delegate = self
    }

    @IBAction func loadAd(_ sender: Any) {
        adView?.removeFromSuperview()
        // Replace demo R-M-DEMO-native-c with actual Ad Unit ID
        let requestConfiguration = YMANativeAdRequestConfiguration(adUnitID: "R-M-DEMO-native-c")
        adLoader.loadAd(with: requestConfiguration)
    }

    func addAdView() {
        guard let adView = adView else { return }

        adView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adView)
        var layoutGuide = self.view.layoutMarginsGuide
        if #available(iOS 11.0, *) {
            layoutGuide = self.view.safeAreaLayoutGuide
        }
        let constraints = [
            adView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 10),
            adView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -10),
            adView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -10)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

// MARK: - YMANativeAdLoaderDelegate

extension TemplateNativeViewController: YMANativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: YMANativeAdLoader, didLoad ad: YMANativeAd) {
        guard let adView = adView else { return }

        ad.delegate = self
        adView.isHidden = false
        adView.ad = ad
        addAdView()
    }

    func nativeAdLoader(_ loader: YMANativeAdLoader, didFailLoadingWithError error: Error) {
        print("Native ad loading error: \(error)")
    }
}

// MARK: - YMANativeAdDelegate

extension TemplateNativeViewController: YMANativeAdDelegate {

    // Uncomment to open web links in in-app browser
//    func viewControllerForPresentingModalView() -> UIViewController? {
//        return self
//    }

    func nativeAdWillLeaveApplication(_ ad: YMANativeAd) {
        print("Will leave application")
    }

    func nativeAd(_ ad: YMANativeAd, willPresentScreen viewController: UIViewController?) {
        print("Will present screen")
    }

    func nativeAd(_ ad: YMANativeAd, didDismissScreen viewController: UIViewController?) {
        print("Did dismiss screen")
    }

    func close(_ ad: YMANativeAd) {
        adView?.isHidden = true
    }
}
