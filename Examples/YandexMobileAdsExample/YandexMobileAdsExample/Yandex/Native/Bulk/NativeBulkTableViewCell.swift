/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import YandexMobileAds

final class NativeBulkTableViewCell: UITableViewCell {
    static var reuseIdentifier: String { String(describing: Self.self) }
    
    private let adView: NativeCustomAdView = .init()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        adView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(adView)
        
        let margins = contentView.layoutMarginsGuide
        
        NSLayoutConstraint.activate([
            adView.topAnchor.constraint(equalTo: margins.topAnchor),
            adView.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            adView.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            adView.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
        ])
    }
    
    func bindNativeAd(_ ad: NativeAd) {
        ad.delegate = self
        do {
            try ad.bind(with: adView)
            adView.isHidden = false
            adView.callToActionButton?.accessibilityIdentifier = "call"
        } catch {
            print("Binding error: \(error)")
        }
    }
}

// MARK: - YMANativeAdDelegate

extension NativeBulkTableViewCell: NativeAdDelegate {
    func nativeAdDidClick(_ ad: NativeAd) {
        print(#function)
    }

    func nativeAdWillLeaveApplication(_ ad: NativeAd) {
        print(#function)
    }

    func nativeAd(_ ad: NativeAd, willPresentScreen viewController: UIViewController?) {
        print(#function)
    }

    func nativeAd(_ ad: NativeAd, didTrackImpressionWith impressionData: ImpressionData?) {
        print(#function)
    }

    func nativeAd(_ ad: NativeAd, didDismissScreen viewController: UIViewController?) {
        print(#function)
    }

    func close(_ ad: NativeAd) {
        print(#function)
    }
}
