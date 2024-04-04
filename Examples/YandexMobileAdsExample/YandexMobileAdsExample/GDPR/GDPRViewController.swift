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
    var adLoader: NativeAdLoader!
    var bannerView: NativeBannerView?
    var gdprManager: GDPRUserConsentManager
    
    @IBOutlet private var loadButton: UIButton!
    @IBOutlet private var settingsButton: UIButton!

    required init?(coder: NSCoder) {
        gdprManager = GDPRUserConsentManager(userDefaults: UserDefaults.standard)
        gdprManager.initializeUserDefaults()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        adLoader = NativeAdLoader()
        adLoader.delegate = self
        
        loadButton.accessibilityIdentifier = CommonAccessibility.loadButton
        settingsButton.accessibilityIdentifier = GDPRAccessibility.settingsButton
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
        // Replace demo-native-content-yandex with actual Ad Unit ID
        let requestConfiguration = NativeAdRequestConfiguration(adUnitID: "demo-native-content-yandex")
        adLoader.loadAd(with: requestConfiguration)
    }

    private func configureLayoutAtBottom(for bannerView: UIView) {
        let guide = self.view.layoutMarginsGuide
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

extension GDPRViewController: NativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: NativeAdLoader, didLoad ad: NativeAd) {
        let bannerView = NativeBannerView()
        bannerView.ad = ad

        self.bannerView?.removeFromSuperview()
        self.bannerView = bannerView
        view.addSubview(bannerView)
        configureLayoutAtBottom(for: bannerView)
    }

    func nativeAdLoader(_ loader: NativeAdLoader, didFailLoadingWithError error: Error) {
        print("Native ad loading error: ", error)
    }
}
