/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import YandexMobileAds

class AdFoxSliderViewController: UIViewController {
    private let loadButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Load", for: .normal)
        return button
    }()
    
    private let stateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var adLoader: NativeAdLoader!
    private let sliderAdView: NativeSliderView = {
        let view = NativeSliderView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        adLoader = NativeAdLoader()
        adLoader.delegate = self
        loadButton.addTarget(self, action: #selector(loadSliderAd), for: .primaryActionTriggered)
        layoutAdView()
    }

    @objc private func loadSliderAd() {
        var parameters = Dictionary<String, String>()
        parameters["adf_ownerid"] = "270901"
        parameters["adf_p1"] = "ddfla"
        parameters["adf_p2"] = "fksh"
        let requestConfiguration = MutableNativeAdRequestConfiguration(adUnitID: "R-M-243655-10")
        requestConfiguration.parameters = parameters
        adLoader.loadAd(with: requestConfiguration)
    }

    private func layoutAdView() {
        view.addSubview(loadButton)
        view.addSubview(stateLabel)
        NSLayoutConstraint.activate([
            loadButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            loadButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            loadButton.widthAnchor.constraint(equalToConstant: 50),
            stateLabel.leadingAnchor.constraint(equalTo: loadButton.leadingAnchor),
            stateLabel.topAnchor.constraint(equalTo: loadButton.bottomAnchor, constant: 10),
            stateLabel.widthAnchor.constraint(equalToConstant: 100),
            stateLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        view.addSubview(sliderAdView)
        NSLayoutConstraint.activate([
            sliderAdView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            sliderAdView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            sliderAdView.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 8),
            sliderAdView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
}

extension AdFoxSliderViewController: NativeAdLoaderDelegate {
    func nativeAdLoader(_ loader: NativeAdLoader, didLoad ad: NativeAd) {
        sliderAdView.isHidden = false
        do {
            try sliderAdView.bind(with: ad)
            stateLabel.text = StateUtils.loaded()
        } catch {
            stateLabel.text = StateUtils.loadError(error)
        }
    }

    func nativeAdLoader(_ loader: NativeAdLoader, didFailLoadingWithError error: any Error) {
        stateLabel.text = StateUtils.loadError(error)
    }
}
