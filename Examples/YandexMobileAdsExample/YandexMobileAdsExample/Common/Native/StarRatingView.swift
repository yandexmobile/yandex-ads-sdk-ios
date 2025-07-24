/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

class StarRatingView: UIView {
    private let starSpace: CGFloat = 5

    private var _rating: Int?
    private var starViews = [UIImageView]()

    private func updateStarViews() {
        for image in starViews {
            image.removeFromSuperview()
        }

        starViews.removeAll()

        guard let rating = _rating, rating > 0 else { return }
        showStar(atLeft: self, attribute: .trailing)
        for _ in 1 ..< rating {
            showStar(atLeft: starViews.last!, attribute: .leading)
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
                                              attribute: .trailing,
                                              relatedBy: .equal,
                                              toItem: view,
                                              attribute: attribute,
                                              multiplier: 1,
                                              constant: 0))
        self.addConstraint(NSLayoutConstraint(item: starImageView,
                                              attribute: .top,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .top,
                                              multiplier: 1,
                                              constant: starSpace))
        starViews.append(starImageView)
    }
}

extension StarRatingView: Rating {
    func setRating(_ rating: NSNumber?) {
        _rating = rating as? Int
        updateStarViews()
    }

    func rating() -> NSNumber? {
        guard let rating = _rating else { return nil }
        return NSNumber(value: rating)
    }
}
