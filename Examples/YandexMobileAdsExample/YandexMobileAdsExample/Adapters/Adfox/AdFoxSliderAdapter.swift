import UIKit
import YandexMobileAds

final class AdFoxSliderAdapter: NSObject, UnifiedAdProtocol {
    var inlineView: UIView? { sliderView }
    var onEvent: ((UnifiedAdEvent) -> Void)?
    
    private let adUnitID: String
    var adFoxParameters: [String: String] = [
        "adf_ownerid": "270901",
        "adf_p1": "ddfla",
        "adf_p2": "fksh"
    ]
    private let adLoader = SliderAdLoader()
    private var currentAd: SliderAd?
    
    private let sliderView: NativeSliderView = {
        let view = NativeSliderView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        return view
    }()
    
    init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init()
    }
    
    deinit {
        Task { @MainActor [currentAd] in
            currentAd?.delegate = nil
        }
    }
    
    func load() {
        currentAd?.delegate = nil
        currentAd = nil
        sliderView.isHidden = true
        let request = AdRequest(adUnitID: adUnitID, parameters: adFoxParameters)

        debugPrint("AdFox Slider: start loading (unit=\(adUnitID), params=\(adFoxParameters))")
        adLoader.loadAd(with: request) { [weak self] in
            guard let self else { return }
            switch $0 {
            case .success(let ad):
                currentAd = ad
                ad.delegate = self
                do {
                    try sliderView.bind(with: ad)
                    sliderView.isHidden = false
                    debugPrint("AdFox Slider: loaded successfully (unit=\(adUnitID))")
                    onEvent?(.loaded)
                } catch {
                    debugPrint("AdFox Slider: bind failed (unit=\(adUnitID)) error=\(error)")
                    onEvent?(.failedToLoad(error))
                }
            case .failure(let error):
                debugPrint("AdFox Slider: failedToLoad (unit=\(adUnitID)) error=\(error)")
                onEvent?(.failedToLoad(error))
            }
        }
    }
    
    func tearDown() {
        currentAd?.delegate = nil
        currentAd = nil
        sliderView.isHidden = true
        sliderView.removeFromSuperview()
        debugPrint("AdFox Slider: tearDown (unit=\(adUnitID))")
    }
}

// MARK: - SliderAdDelegate

extension AdFoxSliderAdapter: SliderAdDelegate {
    func sliderAdDidClick(_ ad: SliderAd) {
        debugPrint("AdFox Slider: clicked (unit=\(adUnitID))")
        onEvent?(.clicked)
    }

    func sliderAd(_ ad: SliderAd, didTrackImpression impressionData: ImpressionData?) {
        debugPrint("AdFox Slider: impression tracked (unit=\(adUnitID))")
        onEvent?(.impression)
    }
}
