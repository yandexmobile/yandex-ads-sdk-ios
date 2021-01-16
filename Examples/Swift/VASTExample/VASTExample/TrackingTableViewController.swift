/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

class TrackingTableViewController: UITableViewController {
    private let adID = "ad"
    private let creativeID = "creative"
    private let trackingCellID = "TrackCell"
    private let trackingEvents = [
        "ad": [kYMAVASTAdImpression],
        "creative": [
            kYMACreativeStart,
            kYMACreativeFirstQuartile,
            kYMACreativeMidpoint,
            kYMACreativeThirdQuartile,
            kYMACreativeComplete,
            kYMACreativeMute,
            kYMACreativeUnmute,
            kYMACreativeFullscreen,
            kYMACreativeExpand,
            kYMACreativeCollapse,
            kYMACreativeClose,
            kYMACreativeClickTracking
        ]
    ]
    
    private let ad: YMAVASTAd
    
    init(ad: YMAVASTAd) {
        self.ad = ad
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: trackingCellID)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return ad.creatives.count + 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? trackingEvents[adID]!.count : trackingEvents[creativeID]!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: trackingCellID)!
        let events = indexPath.section == 0 ? trackingEvents[adID]! : trackingEvents[creativeID]!
        cell.textLabel?.text = "track: \(events[indexPath.row])"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Ad" : "Creative"
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let action = trackingEvents[adID]![indexPath.row]
            YMAVASTTracker.trackAdEvent(ad, eventName: action)
        } else {
            let creative = ad.creatives[indexPath.section - 1]
            let action = trackingEvents[creativeID]![indexPath.row]
            YMAVASTTracker.trackCreativeEvent(creative, eventName: action)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
