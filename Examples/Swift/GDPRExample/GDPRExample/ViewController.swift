/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class ViewController: UIViewController {
    var adLoader: YMANativeAdLoader!
    var lastBanner: YMANativeBannerView?
    var gdprManager: GDPRUserConsentManager!

    override func viewDidLoad(){
        super.viewDidLoad()
        let configuration = YMANativeAdLoaderConfiguration(blockID: "R-M-DEMO-native-c", loadImagesAutomatically: true)
        adLoader = YMANativeAdLoader(configuration: configuration)
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

    private func didLoadAd(ad : YMANativeGenericAd) {
        let bannerView = YMANativeBannerView()
        bannerView.ad = ad

        lastBanner?.removeFromSuperview()
        lastBanner = bannerView
        self.view.addSubview(bannerView)

        bannerView.translatesAutoresizingMaskIntoConstraints = false

        if #available(iOS 11.0, *) {
            configureLayoutAtBottomOfSafeArea(for: bannerView)
        } else {
            configureLayoutAtBottom(for: bannerView)
        }
    }

    private func configureLayoutAtBottom(for bannerView: UIView) {
        let views = ["bannerView" : bannerView]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[bannerView]-|",
                                                        options: [],
                                                        metrics: nil,
                                                        views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[bannerView]-|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: views)
        self.view.addConstraints(horizontal)
        self.view.addConstraints(vertical)
    }

    @available(iOS 11.0, *)
    private func configureLayoutAtBottomOfSafeArea(for bannerView: UIView) {
        let guide = self.view.safeAreaLayoutGuide
        let constraints = [bannerView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
                           bannerView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
                           bannerView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)]
        NSLayoutConstraint.activate(constraints)
    }

    private func loadAd() {
        adLoader.loadAd(with: nil)
    }
}

// MARK: - GDPRDialogDelegate

extension ViewController: YMANativeAdLoaderDelegate {
    func dialogDidDismiss(_ dialog : GDPRDialogViewController) {
        loadAd()
    }
}

// MARK: - YMANativeAdLoaderDelegate

extension ViewController: GDPRDialogDelegate {
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeAppInstallAd) {
        didLoadAd(ad: ad)
    }

    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeContentAd) {
        didLoadAd(ad: ad)
    }

    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeImageAd) {
        didLoadAd(ad: ad)
    }

    func nativeAdLoader(_ loader: YMANativeAdLoader!, didFailLoadingWithError error: Error) {
        print("Native ad loading error: ", error)
    }
}
