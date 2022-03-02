/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

private let settingsSegueID = "showSettingsViewController"
private let dialogSegueID = "showDialogViewController"

class GDPRViewController: UIViewController {
    var adLoader: YMANativeAdLoader!
    var bannerView: YMANativeBannerView?
    var gdprManager: GDPRUserConsentManager

    required init?(coder: NSCoder) {
        gdprManager = GDPRUserConsentManager(userDefaults: UserDefaults.standard)
        gdprManager.initializeUserDefaults()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        adLoader = YMANativeAdLoader()
        adLoader.delegate = self
    }

    @IBAction func loadAd(_ sender: Any) {
        let shouldShowDialog = gdprManager.showDialog
        if shouldShowDialog {
            performSegue(withIdentifier: dialogSegueID, sender: nil)
        } else {
            loadAd()
        }
    }

    @IBAction func showSettings(_ sender: Any) {
        performSegue(withIdentifier: settingsSegueID, sender: nil)
    }

    private func loadAd() {
        // Replace demo R-M-DEMO-native-c with actual Ad Unit ID
        let requestConfiguration = YMANativeAdRequestConfiguration(adUnitID: "R-M-DEMO-native-c")
        adLoader.loadAd(with: requestConfiguration)
    }

    private func configureLayoutAtBottom(for bannerView: UIView) {
        var guide = self.view.layoutMarginsGuide
        if #available(iOS 11.0, *) {
            guide = self.view.safeAreaLayoutGuide
        }
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [bannerView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                           bannerView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                           bannerView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }

    // MARK: - Prepare for segue

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSettingsViewController",
           let settingsViewController = segue.destination as? SettingsViewController {
            settingsViewController.gdprManager = gdprManager
        } else if segue.identifier == "showDialogViewController",
                let dialogViewController = segue.destination as? GDPRDialogViewController {
            dialogViewController.delegate = self
            dialogViewController.gdprManager = gdprManager
        }
    }
}

// MARK: - GDPRDialogDelegate

extension GDPRViewController: GDPRDialogDelegate {
    func dialogDidDismiss(_ dialog : GDPRDialogViewController) {
        loadAd()
    }
}

// MARK: - YMANativeAdLoaderDelegate

extension GDPRViewController: YMANativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: YMANativeAdLoader, didLoad ad: YMANativeAd) {
        let bannerView = YMANativeBannerView()
        bannerView.ad = ad

        self.bannerView?.removeFromSuperview()
        self.bannerView = bannerView
        view.addSubview(bannerView)
        configureLayoutAtBottom(for: bannerView)
    }

    func nativeAdLoader(_ loader: YMANativeAdLoader, didFailLoadingWithError error: Error) {
        print("Native ad loading error: ", error)
    }
}
