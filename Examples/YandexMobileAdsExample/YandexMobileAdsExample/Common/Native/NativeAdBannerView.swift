/*
 * Version for iOS © 2015–2026 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

final class NativeAdBannerView: YandexMobileAds.NativeAdView {
    private enum Constants {
        static let smallMargin: CGFloat = 4
        static let mediumMargin: CGFloat = 8
        static let iconSize: CGFloat = 50
        static let faviconSize: CGFloat = 16
        static let feedbackSize: CGFloat = 30
        static let ratingWidth: CGFloat = 80
        static let ratingHeight: CGFloat = 16
        static let mediaAspectRatio: CGFloat = 9.0 / 16.0
    }

    private let ageLabel_: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return label
    }()

    private let sponsoredLabel_: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()

    private let feedbackButton_: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setContentHuggingPriority(.required, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()

    private let iconImageView_: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel_: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()

    private let bodyLabel_: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.numberOfLines = 3
        return label
    }()

    private let faviconImageView_: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let domainLabel_: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        return label
    }()

    private let priceLabel_: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()

    private let ratingView_: StarRatingView = {
        let view = StarRatingView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let reviewCountLabel_: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        return label
    }()

    private let callToActionButton_: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.tintColor, for: .normal)
        button.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()

    private let mediaView_: YandexMobileAds.NativeMediaView = {
        let view = YandexMobileAds.NativeMediaView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let warningLabel_: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()

    private let topStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constants.smallMargin
        stack.alignment = .center
        return stack
    }()

    private let domainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constants.smallMargin
        stack.alignment = .center
        return stack
    }()

    private let bottomInfoStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constants.smallMargin
        stack.alignment = .center
        return stack
    }()

    private let contentStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.smallMargin
        return stack
    }()

    private let middleStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constants.mediumMargin
        stack.alignment = .top
        return stack
    }()

    private let mainStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.mediumMargin
        return stack
    }()

    init() {
        super.init(frame: .zero)
        addSubviews()
        setupConstraints()
        bindAssets()
    }

    required init?(coder: NSCoder) {
        fatalError("Please use this class from code.")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        iconImageView_.isHidden = iconImageView_.image == nil
        faviconImageView_.isHidden = faviconImageView_.image == nil
    }

    private func addSubviews() {
        addSubview(mainStack)

        topStack.addArrangedSubview(ageLabel_)
        topStack.addArrangedSubview(sponsoredLabel_)
        topStack.addArrangedSubview(feedbackButton_)

        domainStack.addArrangedSubview(faviconImageView_)
        domainStack.addArrangedSubview(domainLabel_)

        bottomInfoStack.addArrangedSubview(priceLabel_)
        bottomInfoStack.addArrangedSubview(ratingView_)
        bottomInfoStack.addArrangedSubview(reviewCountLabel_)
        bottomInfoStack.addArrangedSubview(callToActionButton_)

        contentStack.addArrangedSubview(titleLabel_)
        contentStack.addArrangedSubview(bodyLabel_)
        contentStack.addArrangedSubview(domainStack)
        contentStack.addArrangedSubview(bottomInfoStack)

        middleStack.addArrangedSubview(iconImageView_)
        middleStack.addArrangedSubview(contentStack)

        mainStack.addArrangedSubview(topStack)
        mainStack.addArrangedSubview(middleStack)
        mainStack.addArrangedSubview(mediaView_)
        mainStack.addArrangedSubview(warningLabel_)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: topAnchor, constant: Constants.mediumMargin),
            mainStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.mediumMargin),
            mainStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -Constants.mediumMargin),
            mainStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.mediumMargin),

            iconImageView_.widthAnchor.constraint(equalToConstant: Constants.iconSize),
            iconImageView_.heightAnchor.constraint(equalToConstant: Constants.iconSize),

            faviconImageView_.widthAnchor.constraint(equalToConstant: Constants.faviconSize),
            faviconImageView_.heightAnchor.constraint(equalToConstant: Constants.faviconSize),

            feedbackButton_.widthAnchor.constraint(equalToConstant: Constants.feedbackSize),
            feedbackButton_.heightAnchor.constraint(equalToConstant: Constants.feedbackSize),

            mediaView_.heightAnchor.constraint(equalTo: mediaView_.widthAnchor, multiplier: Constants.mediaAspectRatio),

            ratingView_.widthAnchor.constraint(equalToConstant: Constants.ratingWidth),
            ratingView_.heightAnchor.constraint(equalToConstant: Constants.ratingHeight),
        ])
    }

    private func bindAssets() {
        ageLabel = ageLabel_
        bodyLabel = bodyLabel_
        callToActionButton = callToActionButton_
        domainLabel = domainLabel_
        faviconImageView = faviconImageView_
        feedbackButton = feedbackButton_
        iconImageView = iconImageView_
        mediaView = mediaView_
        priceLabel = priceLabel_
        ratingView = ratingView_
        reviewCountLabel = reviewCountLabel_
        sponsoredLabel = sponsoredLabel_
        titleLabel = titleLabel_
        warningLabel = warningLabel_
    }
}
