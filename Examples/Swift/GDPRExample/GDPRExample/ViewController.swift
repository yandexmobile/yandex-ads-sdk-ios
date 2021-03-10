/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class ViewController: UIViewController {
    var adLoader: YMANativeAdLoader!
    var bannerView: YMANativeBannerView?
    var gdprManager: GDPRUserConsentManager!

    override func viewDidLoad(){
        super.viewDidLoad()
        adLoader = YMANativeAdLoader()
        adLoader.delegate = self
    }

    @IBAction func loadAd(_ sender: UIButton) {
        let shouldShowDialog = gdprManager.showDialog
        if shouldShowDialog {
            showGDPRDialog()
        } else {
            loadAd()
        }
    }

    @IBAction func showSettings(_ sender: Any) {
        let settings = SettingsViewController(gdprManager: gdprManager)
        navigationController?.pushViewController(settings, animated: true)
    }

    private func showGDPRDialog() {
        // This is sample GDPR dialog which is used to demonstrate the GDPR user consent retrieval logic.
        // Please, do not use this dialog in production app.
        // Replace it with one which is suitable for the app.
        let dialog = GDPRDialogViewController(delegate: self, gdprManager: gdprManager)
        dialog.modalPresentationStyle = UIModalPresentationStyle.formSheet
        self.present(dialog, animated: true, completion: nil)
    }

    private func loadAd() {
        let requestConfiguration = YMANativeAdRequestConfiguration(blockID: "R-M-DEMO-native-c")
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
}

// MARK: - GDPRDialogDelegate

extension ViewController: GDPRDialogDelegate {
    func dialogDidDismiss(_ dialog : GDPRDialogViewController) {
        loadAd()
    }
}

// MARK: - YMANativeAdLoaderDelegate

extension ViewController: YMANativeAdLoaderDelegate {
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
