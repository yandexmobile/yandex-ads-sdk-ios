/*
 * Version for iOS © 2015–2023 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import IronSource

final class IronSourceBannerViewController: UIViewController {
    private var bannerView: ISBannerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeIronSource()
    }

    private func initializeIronSource() {
        IronSourceManager.shared.initializeSDK()
        IronSource.setLevelPlayBannerDelegate(self)
    }

    private func addBannerView(banner: ISBannerView) {
        banner.translatesAutoresizingMaskIntoConstraints = false
        banner.removeFromSuperview()
        view.addSubview(banner)
        let layoutGuide = view.layoutMarginsGuide
        let constraints = [
            banner.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
            banner.centerXAnchor.constraint(equalTo: layoutGuide.centerXAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
    }

    @IBAction func loadAd(_: UIButton) {
        IronSource.loadBanner(
            with: self,
            size: ISBannerSize(description: kSizeBanner, width: 320, height: 50)
        )
    }
}

// MARK: - LevelPlayBannerDelegate

extension IronSourceBannerViewController: LevelPlayBannerDelegate {
    func didLoad(_ bannerView: ISBannerView, with adInfo: ISAdInfo) {
        addBannerView(banner: bannerView)
        print("Banner did load")
    }
    
    func didFailToLoadWithError(_ error: Error!) {
        print("Banner did fail to load")
    }
    
    func didClick(with adInfo: ISAdInfo!) {
        print("Banner did click")
    }
    
    func didLeaveApplication(with adInfo: ISAdInfo!) {
        print("Did leave application")
    }
    
    func didPresentScreen(with adInfo: ISAdInfo!) {
        print("Did present screen")
    }
    
    func didDismissScreen(with adInfo: ISAdInfo!) {
        print("Did dismiss screen")
    }
}
