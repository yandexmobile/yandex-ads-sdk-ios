/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */


import UIKit
import YandexMobileAds

class NativeSliderView: YMANativeAdView {
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.alwaysBounceHorizontal = true
        scrollView.isPagingEnabled = true
        return scrollView
    }()

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .equalSpacing
        stackView.alignment = .bottom
        return stackView
    }()

    private let leftChevronButton: UIButton = chevronButton(name: "chevron.left")

    private let rightChevronButton: UIButton = chevronButton(name: "chevron.right")

    private let pageControl: UIPageControl = {
        let pageControll = UIPageControl()
        pageControll.translatesAutoresizingMaskIntoConstraints = false
        pageControll.backgroundStyle = .prominent
        return pageControll
    }()
    
    public var autoscrollInterval: TimeInterval = 2 {
        didSet {
            startTimer()
        }
    }

    public var isAutoscrollEnabled: Bool = true {
        didSet {
            startTimer()
        }
    }
    
    private var adsCount = 0
    private var timer: Timer?

    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        setupLayout()
        setupActions()
    }

    private func setupActions() {
        leftChevronButton.addTarget(self, action: #selector(handleLeftScroll), for: .primaryActionTriggered)
        rightChevronButton.addTarget(self, action: #selector(handleRightScroll), for: .primaryActionTriggered)
        scrollView.delegate = self
    }

    private func setupLayout() {
        addSubview(scrollView)
        scrollView.addSubview(stackView)
        addSubview(leftChevronButton)
        addSubview(rightChevronButton)
        addSubview(pageControl)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.centerXAnchor.constraint(equalTo: centerXAnchor),
            scrollView.widthAnchor.constraint(equalToConstant: 328),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            leftChevronButton.heightAnchor.constraint(equalToConstant: 48),
            leftChevronButton.widthAnchor.constraint(equalToConstant: 48),
            leftChevronButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: -24),
            leftChevronButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            
            rightChevronButton.heightAnchor.constraint(equalToConstant: 48),
            rightChevronButton.widthAnchor.constraint(equalToConstant: 48),
            rightChevronButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16),
            rightChevronButton.centerYAnchor.constraint(equalTo: stackView.centerYAnchor),
            
            pageControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: stackView.bottomAnchor, constant: -16)
        ])
        setupSponsored()
    }

    private func setupSponsored() {
        sponsoredLabel = .init()
        guard let sponsoredLabel else { return }
        addSubview(sponsoredLabel)
        sponsoredLabel.translatesAutoresizingMaskIntoConstraints = false
        sponsoredLabel.backgroundColor = .red
        NSLayoutConstraint.activate([
            sponsoredLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            sponsoredLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            sponsoredLabel.topAnchor.constraint(equalTo: topAnchor),
        ])
    }

    func bind(with ad: NativeAd) throws {
        stackView.arrangedSubviews.forEach { 
            stackView.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }

        do {
            try ad.bindAd(toSliderView: self)
        } catch {
            print(error)
        }

        let ads = ad.ads.isEmpty ? [ad] : ad.ads
        setupPageControll(pages: ads.count)
        for (index, innerAd) in ads.enumerated() {
            let adView = viewForAd(innerAd)
            do {
                try innerAd.bind(with: adView)
            } catch {
                print("Error binding slider at index \(index) - \(error)")
                throw error
            }
            adView.translatesAutoresizingMaskIntoConstraints = false
            let constraints = [
                adView.widthAnchor.constraint(equalToConstant: adView.frame.size.width),
                adView.heightAnchor.constraint(equalToConstant: adView.frame.size.height),
            ]
            NSLayoutConstraint.activate(constraints)
            innerAd.delegate = self
            stackView.addArrangedSubview(adView)
        }
        startTimer()
        scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y), animated: true)
    }

    private func setupPageControll(pages: Int) {
        adsCount = pages
        guard pages > 1 else {
            pageControl.isHidden = true
            leftChevronButton.isHidden = true
            rightChevronButton.isHidden = true
            return
        }
        leftChevronButton.isHidden = true
        pageControl.isHidden = false
        pageControl.numberOfPages = pages
    }

    private static func chevronButton(name: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(configuredImage(systemName: name), for: .normal)
        button.tintColor = .white
        button.backgroundColor = .gray.withAlphaComponent(0.7)
        button.layer.cornerRadius = 24
        return button
    }

    private static func configuredImage(systemName: String) -> UIImage? {
        UIImage(systemName: systemName, withConfiguration: UIImage.SymbolConfiguration(pointSize: 28))?.withRenderingMode(.alwaysTemplate)
    }

    @objc
    private func handleLeftScroll() {
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x - scrollView.frame.width, y: scrollView.contentOffset.y), animated: true)
        startTimer()
    }

    @objc
    private func handleRightScroll() {
        scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x + scrollView.frame.width, y: scrollView.contentOffset.y), animated: true)
        startTimer()
    }

    private func startTimer() {
        guard autoscrollInterval > 0, isAutoscrollEnabled, adsCount > 1 else { return }
        timer?.invalidate()
        timer = nil
        timer = Timer.scheduledTimer(withTimeInterval: autoscrollInterval, repeats: true, block: { [weak self ] _ in
            self?.autoscroll()
        })
    }

    private func autoscroll() {
        let currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        let offset = currentPage == (adsCount - 1) ? 0 : scrollView.contentOffset.x + scrollView.frame.width
        scrollView.setContentOffset(CGPoint(x: offset, y: scrollView.contentOffset.y), animated: true)
    }

    private func viewForAd(_ ad: NativeAd) -> YMANativeAdView {
        let view = NativeAdView.nib!
        view.frame = CGRect(x: 0.0, y: 0.0, width: sliderViewItemWidth, height: view.frame.size.height)

        view.ageLabel?.isHidden = ad.adAssets().age == nil
        view.iconImageView?.isHidden = ad.adAssets().icon == nil

        return view
    }
}

extension NativeSliderView: NativeAdDelegate {
    func nativeAd(_ ad: any NativeAd, didTrackImpressionWith impressionData: (any ImpressionData)?) {
        
    }
}

extension NativeSliderView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startTimer()
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        pageControl.currentPage = currentPage
        leftChevronButton.isHidden = currentPage == 0
        rightChevronButton.isHidden = currentPage == (adsCount - 1)
    }
}

private let sliderViewItemWidth: CGFloat = 320.0
private let sliderViewItemHeight: CGFloat = 400
