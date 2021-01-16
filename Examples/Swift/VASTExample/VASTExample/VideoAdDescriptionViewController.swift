/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

class VideoAdDescriptionViewController: UIViewController {
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
        
        self.title = "Video ads"

        let descriptionTextView = createDescriptionTextView()
        view.addSubview(descriptionTextView)
        configureConstraint(descriptionTextView: descriptionTextView)
        configureNavigationItem()
    }

    private func configureNavigationItem() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Tracking",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(displayTracking))
    }

    private func createDescriptionTextView() -> UITextView {
        let descriptionTextView = UITextView(frame: .zero)
        descriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        descriptionTextView.isEditable = false
        descriptionTextView.text = ad.description
        return descriptionTextView
    }

    private func configureConstraint(descriptionTextView : UIView) {
        let views = ["descriptionTextView": descriptionTextView]
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|[descriptionTextView]|",
                                                        options: [],
                                                        metrics: nil,
                                                        views: views)
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|[descriptionTextView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: views)
        view.addConstraints(horizontal + vertical)
    }
    
    @objc private func displayTracking() {
        let controller = TrackingTableViewController(ad: ad)
        navigationController?.pushViewController(controller, animated: true)
    }
}
