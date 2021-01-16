/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

class ViewController: UITableViewController {
    private let pageID = "349941";
    private let categoryID = "0";
    private let cellID = "Cell"
    
    let vmapLoader = YMAVMAPLoader()
    var VMAP: YMAVMAP?

    override func viewDidLoad() {
        super.viewDidLoad()
        vmapLoader.delegate = self
        let configuration = YMAMutableVMAPRequestConfiguration(pageID: pageID)
        configuration.categoryID = categoryID
        vmapLoader.loadVMAP(with: configuration)
    }

    private func requestVASTForAdBreak(at index: Int) {
        let configuration = YMAVASTRequestConfiguration(adBreak: VMAP!.adBreaks[index])
        let videoAdLoader = YMAVideoAdLoader()
        videoAdLoader.delegate = self
        videoAdLoader.loadVAST(with: configuration)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return VMAP?.adBreaks.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        cell.textLabel?.text = "AdBreak: \(indexPath.row)"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        requestVASTForAdBreak(at: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - YMAVMAPLoaderDelegate

extension ViewController: YMAVMAPLoaderDelegate {
    func loader(_ loader: YMAVMAPLoader, didLoad VMAP: YMAVMAP) {
        self.VMAP = VMAP
        tableView.reloadData()
    }

    func loader(_ loader: YMAVMAPLoader, didFailLoadingVMAPWithError error: Error) {
        print("Did fail loading VMAP with error: \(error)")
    }
}

// MARK: - YMAVideoAdLoaderDelegate

extension ViewController: YMAVideoAdLoaderDelegate {
    func loaderDidLoadVideoAds(_ ads: [YMAVASTAd]) {
        let viewControler = VideoAdsTableViewController(ads: ads)
        navigationController?.pushViewController(viewControler, animated: true)
    }

    func loaderDidFailLoadingVideoAdsWithError(_ error: Error) {
        print("Loader did fail loading video ads with error: \(String(describing: error))")
    }
}
