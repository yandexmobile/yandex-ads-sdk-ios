/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

private let adMobBlockID = "adf-279013/975874"
private let facebookBlockID = "adf-279013/975877"
private let moPubBlockID = "adf-279013/975875"
private let myTargetBlockID = "adf-279013/975876"
private let yandexBlockID = "adf-279013/975878"

class ViewController: UIViewController {

    private let blockIDs = [
        (adapter: "AdMob", blockID: adMobBlockID),
        (adapter: "Facebook", blockID: facebookBlockID),
        (adapter: "MoPub", blockID: moPubBlockID),
        (adapter: "myTarget", blockID: myTargetBlockID),
        (adapter: "Yandex", blockID: yandexBlockID)
    ]

    @IBOutlet private var pickerView: UIPickerView!

    private var contentAdView: NativeContentAdView?
    private var appInstallView: NativeAppInstallAdView?
    private var imageAdView: NativeImageAdView?
    
    private var adLoader: YMANativeAdLoader?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAdViews()
        hideAllViews()
    }
    
    @IBAction func load(_ sender: Any) {
        hideAllViews()
        let selectedIndex = pickerView.selectedRow(inComponent: 0)
        /*
         Replace blockID with actual Block ID.
         Following demo block ids may be used for testing:
         AdMob mediation: adMobBlockID
         Facebook mediation: facebookBlockID
         MoPub mediation: moPubBlockID
         MyTarget mediation: myTargetBlockID
         Yandex: yandexBlockID
         */
        let blockID = blockIDs[selectedIndex].blockID
        let configuration = YMANativeAdLoaderConfiguration(blockID: blockID, loadImagesAutomatically: true)
        adLoader = YMANativeAdLoader(configuration: configuration)
        adLoader?.delegate = self
        adLoader?.loadAd(with: nil)
    }

    private func loadAdViews() {
        contentAdView = Bundle.main.loadNibNamed("NativeContentAdView",
                                                 owner: nil,
                                                 options: nil)?.first as? NativeContentAdView
        if let myContentAdView = contentAdView {
            addAdView(myContentAdView)
        }
        
        appInstallView = Bundle.main.loadNibNamed("NativeAppInstallAdView",
                                                  owner: nil,
                                                  options: nil)?.first as? NativeAppInstallAdView
        if let myAppInstallView = appInstallView {
            addAdView(myAppInstallView)
        }
        
        imageAdView = Bundle.main.loadNibNamed("NativeImageAdView",
                                               owner: nil,
                                               options: nil)?.first as? NativeImageAdView
        if let myImageAdView = imageAdView {
            addAdView(myImageAdView)
        }
    }
    
    private func addAdView(_ adView: UIView) {
        adView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(adView)
        let views = ["adView": adView]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-[adView]-|",
                                                        options: [],
                                                        metrics: nil,
                                                        views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:[adView]-|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: views)
        view.addConstraints(horizontal + vertical)
    }
    
    private func hideAllViews() {
        imageAdView?.isHidden = true
        appInstallView?.isHidden = true
        contentAdView?.isHidden = true
    }
    
    private func showAdView(_ adView: UIView) {
        adView.isHidden = false
    }
}

// MARK: - YMANativeAdLoaderDelegate

extension ViewController: YMANativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeImageAd) {
        guard let myImageAdView = imageAdView else { return }
        try? ad.bindImageAd(to: myImageAdView, delegate: self)
        showAdView(myImageAdView)
        myImageAdView.configureAssetViews()
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeContentAd) {
        guard let myContentAdView = contentAdView else { return }
        try? ad.bindContentAd(to: myContentAdView, delegate: self)
        showAdView(myContentAdView)
        myContentAdView.configureAssetViews()
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didLoad ad: YMANativeAppInstallAd) {
        guard let myAppInstallView = appInstallView else { return }
        try? ad.bindAppInstallAd(to: myAppInstallView, delegate: self)
        showAdView(myAppInstallView)
        myAppInstallView.configureAssetViews()
    }
    
    func nativeAdLoader(_ loader: YMANativeAdLoader!, didFailLoadingWithError error: Error) {
        print("Native ad loading error: \(error)")
    }
}

// MARK: - YMANativeAdDelegate

extension ViewController: YMANativeAdDelegate {
    func closeNativeAd(_ ad: Any!) {
        print("Close native ad")
        hideAllViews()
    }
}

// MARK: - UIPickerViewDelegate & UIPickerViewDataSource

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return blockIDs.count
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let tuple = blockIDs[row]
        return tuple.adapter
    }
}

