/*
 * Version for iOS © 2015–2020 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

class StarRatingView: UIView {
    private var _rating: Int?
    private var starViews = [UIImageView]()

    private func updateStarViews() {
        for image in starViews {
            image.removeFromSuperview()
        }

        starViews.removeAll()

        guard let rating = _rating, rating > 0 else { return }
        showStar(atLeft: self, attribute: .leading)
        for _ in 1 ..< rating {
            showStar(atLeft: starViews.last!, attribute: .trailing)
        }
    }

    private func showStar(atLeft view: UIView, attribute: NSLayoutConstraint.Attribute) {
        let starImageView = UIImageView(image: UIImage(named: "star"))
        starImageView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(starImageView)
        starImageView.addConstraint(NSLayoutConstraint(item: starImageView,
                                                       attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: nil,
                                                       attribute: .height,
                                                       multiplier: 1,
                                                       constant: starImageView.frame.size.height))
        starImageView.addConstraint(NSLayoutConstraint(item: starImageView,
                                                       attribute: .width,
                                                       relatedBy: .equal,
                                                       toItem: nil,
                                                       attribute: .width,
                                                       multiplier: 1,
                                                       constant: starImageView.frame.size.width))
        self.addConstraint(NSLayoutConstraint(item: starImageView,
                                              attribute: .leading,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: attribute,
                                              multiplier: 1,
                                              constant: 0))
        self.addConstraint(NSLayoutConstraint(item: starImageView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: 0))
        starViews.append(starImageView)
    }
}

extension StarRatingView: YMARating {
    func setRating(_ rating: NSNumber?) {
        _rating = rating as? Int
        updateStarViews()
    }

    func rating() -> NSNumber? {
        guard let rating = _rating else { return nil }
        return NSNumber(value: rating)
    }
}
