/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    private let adStride = 10
    private let contentCellHeight: CGFloat = 50
    private let adCellId = "Ad"
    private let contentCellId = "Content"

    private var adLoader: YMANativeAdLoader!
    private var ads = [YMANativeAd]()

    override func viewDidLoad() {
        adLoader = YMANativeAdLoader()
        adLoader.delegate = self
    }

    @IBAction func loadAd(_ sender: UIButton) {
        // Following demo Block IDs may be used for testing:
        // R-M-DEMO-native-c
        // R-M-DEMO-native-i
        // R-M-DEMO-native-video

        let requestConfiguration = YMANativeAdRequestConfiguration(blockID: "R-M-DEMO-native-c")
        adLoader.loadAd(with: requestConfiguration)
    }

}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count * adStride
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : UITableViewCell

        if (indexPath.row % adStride == 0) {
            let adCell = tableView.dequeueReusableCell(withIdentifier: adCellId) as! AdTableViewCell
            let ad = ads[indexPath.row / adStride]
            adCell.bannerView.ad = ad
            ad.loadImages()
            cell = adCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: contentCellId)!
            cell.textLabel?.text = "Content"
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row % adStride == 0 {
            return YMANativeBannerView.height(with: ads[indexPath.row / adStride],
                                                    width: tableView.frame.size.width,
                                                    appearance: nil)
        } else {
            return contentCellHeight
        }
    }
}

// MARK: - YMANativeAdLoaderDelegate

extension ViewController: YMANativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: YMANativeAdLoader, didLoad ad: YMANativeAd) {
        let startIndex = ads.count * adStride
        ads.append(ad)
        var indexPaths = [IndexPath]()
        for i in 0 ..< adStride {
            indexPaths.append(IndexPath(row: i + startIndex, section: 0))
        }
        tableView.insertRows(at: indexPaths, with: .fade)
    }

    func nativeAdLoader(_ loader: YMANativeAdLoader, didFailLoadingWithError error: Error) {
        print("Native ad loading error: \(error)")
    }
}
