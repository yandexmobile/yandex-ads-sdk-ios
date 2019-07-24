/*
 * Version for iOS © 2015–2019 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

class VideoAdsTableViewController: UITableViewController {
    private let cellID = "Cell"
    
    private let ads: [YMAVASTAd]
    
    init(ads: [YMAVASTAd]) {
        self.ads = ads
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Video ads"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ads.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        cell.textLabel?.text = ads[indexPath.row].adTitle
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = VideoAdDescriptionViewController(ad: ads[indexPath.row])
        navigationController?.pushViewController(controller, animated: true)
    }
}
