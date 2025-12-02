import UIKit
import YandexMobileAds

enum FactoryIDs {
    static let interstitial: [AdSource: String] = {
        var ids: [AdSource: String] = [
            .yandex: "demo-interstitial-yandex",
            .applovin: "demo-interstitial-applovin",
            .mintegral: "demo-interstitial-mintegral",
            .mytarget: "demo-interstitial-mytarget",
            .vungle: "demo-interstitial-vungle",
            .adfox: "demo-interstitial-adfox-image"
        ]
#if COCOAPODS
        ids[.admob] = "ca-app-pub-4651572829019143/3054278095"
        ids[.bigo] = "demo-interstitial-bigoads"
        ids[.chartboost] = "demo-interstitial-chartboost"
        ids[.inmobi] = "demo-interstitial-inmobi"
        ids[.ironsource] = "demo-interstitial-ironsource"
        ids[.startapp] = "demo-interstitial-startapp"
        ids[.unity] = "demo-interstitial-unityads"
#endif
        return ids
    }()
    
    static let rewarded: [AdSource: String] = {
        var ids: [AdSource: String] = [
            .yandex: "demo-rewarded-yandex",
            .applovin: "demo-rewarded-applovin",
            .mintegral: "demo-rewarded-mintegral",
            .mytarget: "demo-rewarded-mytarget",
            .vungle: "demo-rewarded-vungle"
        ]
        #if COCOAPODS
        ids[.admob] = "ca-app-pub-4651572829019143/6476005590"
        ids[.bigo] = "demo-rewarded-bigoads"
        ids[.chartboost] = "demo-rewarded-chartboost"
        ids[.inmobi] = "demo-rewarded-inmobi"
        ids[.ironsource] = "demo-rewarded-ironsource"
        ids[.startapp] = "demo-rewarded-startapp"
        ids[.unity] = "demo-rewarded-unityads"
        #endif
        return ids
    }()
    
    static let nativeTemplate: [AdSource: String] = {
        var ids: [AdSource: String] = [
            .yandex: "demo-native-content-yandex",
            .mintegral: "demo-native-mintegral",
            .mytarget: "demo-native-mytarget",
            .vungle: "demo-native-vungle",
            .adfox: "demo-native-adfox"
        ]
        #if COCOAPODS
        ids[.admob] = "ca-app-pub-4651572829019143/9595635718"
        #endif
        return ids
    }()
    
    static let banner: [AdSource: String] = {
        var ids: [AdSource: String] = [
            .yandex: "demo-banner-yandex",
            .mintegral: "demo-banner-mintegral",
            .mytarget: "demo-banner-mytarget",
            .vungle: "demo-banner-vungle",
        ]
        #if COCOAPODS
        ids[.admob] = "ca-app-pub-4651572829019143/7264255923"
        ids[.bigo] = "demo-banner-bigoads"
        ids[.chartboost] = "demo-banner-chartboost"
        ids[.inmobi] = "demo-banner-inmobi"
        ids[.ironsource] = "demo-banner-ironsource"
        ids[.startapp] = "demo-banner-startapp"
        #endif
        return ids
    }()
    
    static let rewardedYandex = "demo-rewarded-yandex"
    static let appOpenYandex = "demo-appopenad-yandex"
    static let nativeBulkYandex = "demo-native-bulk-yandex"
    static let bannerInlineYandex = "demo-banner-yandex"
    static let bannerStickyYandex = "demo-banner-yandex"
    static let bannerStickyAdFox = "demo-banner-adfox-image"
    static let carouselAdFox = "R-M-243655-10"
}


struct UnifiedAdFactory {
    private enum Sizes {
        static let yandexInline: (w: CGFloat, h: CGFloat) = (320, 50)
        static let adfoxSticky: (w: CGFloat, maxH: CGFloat) = (300, 300)
    }
    
    static func makeAdapter(source: AdSource, format: UnifiedFormat, hostViewController: UIViewController) -> UnifiedAdProtocol {
        switch format {
        case .interstitial:
            let id = requireID(FactoryIDs.interstitial, source, format: format)
            switch source {
            #if COCOAPODS
            case .admob:
                return AdMobInterstitialAdapter(adUnitId: id, hostViewController: hostViewController)
            #endif
            case .adfox:
                return AdFoxInterstitialAdapter(adUnitId: id)
            default:
                return YandexInterstitialAdapter(adUnitId: id)
            }
            
        case .rewarded:
            let id = requireID(FactoryIDs.rewarded, source, format: format)
            switch source {
            #if COCOAPODS
            case .admob:
                return AdMobRewardedAdapter(adUnitId: id, hostViewController: hostViewController)
            #endif
            default:
                return YandexRewardedAdapter(adUnitId: id)
            }
            
        case .appOpen:
            return YandexAppOpenAdapter(adUnitId: FactoryIDs.appOpenYandex)
            
        case .bannerInline:
            let id = requireID(FactoryIDs.banner, source, format: format)
            return YandexInlineBannerAdapter(adUnitId: id)
            
        case .bannerSticky:
            if source == .adfox {
                return AdFoxBannerAdapter(
                    adUnitId: FactoryIDs.bannerStickyAdFox,
                    adWidth:  Sizes.adfoxSticky.w,
                    maxHeight: Sizes.adfoxSticky.maxH
                )
            }
            let id = requireID(FactoryIDs.banner, source, format: format)
            return YandexStickyBannerAdapter(adUnitId: id)
            
        case .banner:
            let id = requireID(FactoryIDs.banner, source, format: format)
            switch source {
            #if COCOAPODS
            case .admob:
                return AdMobBannerAdapter(adUnitId: id, hostViewController: hostViewController)
            #endif
            default:
                return YandexInlineBannerAdapter(
                    adUnitId: id,
                    width: Sizes.yandexInline.w,
                    height: Sizes.yandexInline.h
                )
            }
            
        case .nativeBulk:
            return YandexNativeBulkAdapter(adUnitId: FactoryIDs.nativeBulkYandex)
            
        case .nativeTemplate:
            let id = requireID(FactoryIDs.nativeTemplate, source, format: format)
            switch source {
            #if COCOAPODS
            case .admob:
                return AdMobNativeAdapter(adUnitId: id, hostViewController: hostViewController)
            #endif
            case .adfox:
                return AdFoxNativeAdapter(adUnitId: id)
            default:
                return YandexNativeTemplateAdapter(adUnitId: id)
            }
            
        case .nativeCustom:
            return YandexNativeCustomAdapter(adUnitId: "demo-native-video-yandex")
            
        case .instreamSingle:
            return YandexInstreamSingleAdapter(pageID: "demo-instream-vmap-yandex")
            
        case .instreamInrolls:
            return YandexInrollsAdapter(pageID: "demo-instream-vmap-yandex")
            
        case .carousel:
            return AdFoxSliderAdapter(adUnitId: FactoryIDs.carouselAdFox)
        }
    }
    
    // MARK: - Helpers
    
    @inline(__always)
    private static func requireID(_ map: [AdSource: String], _ source: AdSource, format: UnifiedFormat) -> String {
        if let id = map[source] { return id }
        preconditionFailure("Missing AdUnit ID for format=\(format) source=\(source)")
    }
}
