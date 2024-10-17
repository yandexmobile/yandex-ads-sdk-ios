import UIKit
import YandexMobileAds

final class NativeCustomAdView: YMANativeAdView {
    private enum Constants {
        static let smallMargin: CGFloat = 4
        static let bigMargin: CGFloat = 8
    }

    private let title: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let domain: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let warning: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let sponsored: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let feedback: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let callToAction: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.tintColor, for: .normal)
        return button
    }()

    private let media: YMANativeMediaView = {
        let mediaView = YMANativeMediaView()
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        return mediaView
    }()

    private let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let price: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let reviewCount: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let rating: StarRatingView = {
        let starRatingView = StarRatingView()
        starRatingView.translatesAutoresizingMaskIntoConstraints = false
        return starRatingView
    }()

    private let body: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        return label
    }()

    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.spacing = Constants.bigMargin
        return stack
    }()

    private let titleStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.smallMargin
        return stack
    }()

    private let headerStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.spacing = Constants.bigMargin
        return stack
    }()

    private let priceStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = Constants.smallMargin
        return stack
    }()

    private let bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .fillProportionally
        stack.spacing = Constants.smallMargin
        return stack
    }()

    init() {
        super.init(frame: CGRect())
        addSubviews()
        setupConstraints()
        bindAssets()
    }

    required init?(coder: NSCoder) {
        fatalError("Please use this class from code.")
    }

    private func addSubviews() {
        addSubview(stack)

        stack.addArrangedSubview(headerStack)
        stack.addArrangedSubview(warning)
        stack.addArrangedSubview(body)
        stack.addArrangedSubview(media)
        stack.addArrangedSubview(bottomStack)

        headerStack.addArrangedSubview(iconImage)
        headerStack.addArrangedSubview(titleStack)
        headerStack.addArrangedSubview(feedback)

        titleStack.addArrangedSubview(title)
        titleStack.addArrangedSubview(sponsored)
        titleStack.addArrangedSubview(reviewCount)

        bottomStack.addArrangedSubview(priceStack)
        bottomStack.addArrangedSubview(callToAction)

        priceStack.addArrangedSubview(price)
        priceStack.addArrangedSubview(domain)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.leftAnchor.constraint(equalTo: leftAnchor),
            stack.rightAnchor.constraint(equalTo: rightAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),

            media.widthAnchor.constraint(greaterThanOrEqualToConstant: 320),
            media.heightAnchor.constraint(lessThanOrEqualToConstant: 300),

            iconImage.widthAnchor.constraint(equalToConstant: 70),
            iconImage.heightAnchor.constraint(equalTo: iconImage.widthAnchor),

            rating.widthAnchor.constraint(equalToConstant: 100),
            rating.heightAnchor.constraint(equalToConstant: 20),
        ])
    }

    private func bindAssets() {
        titleLabel = title
        domainLabel = domain
        warningLabel = warning
        sponsoredLabel = sponsored
        feedbackButton = feedback
        callToActionButton = callToAction
        mediaView = media
        priceLabel = price
        reviewCountLabel = reviewCount
        ratingView = rating
        bodyLabel = body
        iconImageView = iconImage
    }
}

