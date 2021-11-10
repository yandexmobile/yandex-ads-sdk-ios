/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import MoPubSDK

class MoPubBannerViewController: UIViewController {
    // Replace 1f6d9f3553c6493aac4f99aac8bccf5c with Ad Unit ID generated at https://app.mopub.com.
    let adUnitID = "1f6d9f3553c6493aac4f99aac8bccf5c"

    @IBOutlet weak var loadButton: UIButton!

    var adView: MPAdView!

    override func viewDidLoad() {
        super.viewDidLoad()

        adView = makeAdView()
        initializeMoPub()
    }

    @IBAction func loadAd(_ sender: UIButton) {
        adView.loadAd()
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

    private func makeAdView() -> MPAdView {
        let adView: MPAdView = MPAdView(adUnitId: adUnitID)
        adView.frame = CGRect(x: 0, y: 0, width: 320, height: 50)
        adView.delegate = self
        return adView
    }

    private func addAdView(_ banner: UIView, adSize: CGSize) {
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.removeFromSuperview()
        view.addSubview(banner)
        configureLayoutForView(banner: banner, size: adSize)
    }

    private func configureLayoutForView(banner: UIView, size: CGSize) {
        let constraints = [NSLayoutConstraint(item: banner,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .height,
                                              multiplier: 1,
                                              constant: size.height),
                           NSLayoutConstraint(item: banner,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .width,
                                              multiplier: 1,
                                              constant: size.width),
                           NSLayoutConstraint(item: banner,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: bottomLayoutGuide,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: 0),
                           NSLayoutConstraint(item: banner,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: .centerX,
                                              multiplier: 1,
                                              constant: 0)]
        view.addConstraints(constraints)
    }
}

extension MoPubBannerViewController: MPAdViewDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }

    func adViewDidLoadAd(_ view: MPAdView!, adSize: CGSize) {
        print("Ad view did load")
        addAdView(adView, adSize: adSize)
    }

    func adView(_ view: MPAdView!, didFailToLoadAdWithError error: Error!) {
        print("Ad view did fail to load ad with error: \(String(describing: error))")
    }
}
