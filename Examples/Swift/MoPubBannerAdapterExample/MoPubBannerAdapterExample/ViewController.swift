/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import MoPub

class ViewController: UIViewController {

    // Replace XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX with Ad Unit ID generated at https://app.mopub.com.
    let adUnitId = "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

    @IBOutlet weak var loadButton: UIButton!

    var adView: MPAdView!

    override func viewDidLoad() {
        super.viewDidLoad()

        adView = makeAdView()
        addAdView(adView)
        initializeMoPub()
    }

    @IBAction func loadAd(_ sender: UIButton) {
        adView.loadAd()
    }
    

    private func initializeMoPub() {
        let configuration = MPMoPubConfiguration(adUnitIdForAppInitialization: adUnitId)
        MoPub.sharedInstance().initializeSdk(with: configuration){ [weak self] in
            DispatchQueue.main.async {
                self?.loadButton.isUserInteractionEnabled = true
            }
        }
    }

    private func makeAdView() -> MPAdView {
        let adView: MPAdView = MPAdView(adUnitId: adUnitId, size: MOPUB_BANNER_SIZE)
        adView.isHidden = true
        adView.delegate = self
        return adView
    }

    private func addAdView(_ banner: UIView) {
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.removeFromSuperview()
        view.addSubview(banner)
        configureLayoutForView(banner: banner, size: MOPUB_BANNER_SIZE)
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

extension ViewController: MPAdViewDelegate {
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self
    }

    func adViewDidLoadAd(_ view: MPAdView!) {
        print("Ad view did load")
        view.isHidden = false
    }

    func adView(_ view: MPAdView!, didFailToLoadAdWithError error: Error!) {
        print("Ad view did fail to load ad with error: \(String(describing: error))")
    }
}
