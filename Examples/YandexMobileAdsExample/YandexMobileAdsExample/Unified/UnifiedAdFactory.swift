import UIKit
import YandexMobileAds

enum FactoryIDs {
    static let interstitial: [AdSource: String] = {
        var ids: [AdSource: String] = [
            .yandex: "demo-interstitial-yandex",
        ]
        ids[.adfox] = "demo-interstitial-adfox-image"
        ids[.applovin] = "demo-interstitial-applovin"
        ids[.mintegral] = "demo-interstitial-mintegral"
        ids[.mytarget] = "demo-interstitial-mytarget"
        ids[.vungle] = "demo-interstitial-vungle"
        ids[.admobReverseAdapter] = "ca-app-pub-4651572829019143/3054278095"
        ids[.google] = "demo-interstitial-admob"
        #if COCOAPODS
            ids[.bigo] = "demo-interstitial-bigoads"
            ids[.chartboost] = "demo-interstitial-chartboost"
            ids[.inmobi] = "demo-interstitial-inmobi"
            ids[.ironsource] = "demo-interstitial-ironsource"
            ids[.pangle] = "demo-interstitial-pangle"
            ids[.startapp] = "demo-interstitial-startapp"
            ids[.unity] = "demo-interstitial-unityads"
        #endif
        return ids
    }()

    static let rewarded: [AdSource: String] = {
        var ids: [AdSource: String] = [
            .yandex: "demo-rewarded-yandex",
        ]
        ids[.applovin] = "demo-rewarded-applovin"
        ids[.mintegral] = "demo-rewarded-mintegral"
        ids[.mytarget] = "demo-rewarded-mytarget"
        ids[.vungle] = "demo-rewarded-vungle"
        ids[.admobReverseAdapter] = "ca-app-pub-4651572829019143/6476005590"
        ids[.google] = "demo-rewarded-admob"
        #if COCOAPODS
            ids[.bigo] = "demo-rewarded-bigoads"
            ids[.chartboost] = "demo-rewarded-chartboost"
            ids[.inmobi] = "demo-rewarded-inmobi"
            ids[.ironsource] = "demo-rewarded-ironsource"
            ids[.pangle] = "demo-rewarded-pangle"
            ids[.startapp] = "demo-rewarded-startapp"
            ids[.unity] = "demo-rewarded-unityads"
        #endif
        return ids
    }()

    static let nativeTemplate: [AdSource: String] = {
        var ids: [AdSource: String] = [
            .yandex: "demo-native-content-yandex",
            .adfox: "demo-native-adfox",
        ]
        ids[.mintegral] = "demo-native-mintegral"
        ids[.mytarget] = "demo-native-mytarget"
        ids[.vungle] = "demo-native-vungle"
        ids[.admobReverseAdapter] = "ca-app-pub-4651572829019143/9595635718"
        ids[.google] = "demo-native-admob"
        #if COCOAPODS
            ids[.bigo] = "demo-native-bigoads"
            ids[.pangle] = "demo-native-pangle"
        #endif
        return ids
    }()

    static let banner: [AdSource: String] = {
        var ids: [AdSource: String] = [
            .yandex: "demo-banner-yandex",
        ]
        ids[.applovin] = "demo-banner-applovin"
        ids[.mintegral] = "demo-banner-mintegral"
        ids[.mytarget] = "demo-banner-mytarget"
        ids[.vungle] = "demo-banner-vungle"
        ids[.admobReverseAdapter] = "ca-app-pub-4651572829019143/7264255923"
        ids[.google] = "demo-banner-admob"
        #if COCOAPODS
            ids[.bigo] = "demo-banner-bigoads"
            ids[.chartboost] = "demo-banner-chartboost"
            ids[.inmobi] = "demo-banner-inmobi"
            ids[.ironsource] = "demo-banner-ironsource"
            ids[.pangle] = "demo-banner-pangle"
            ids[.pangleMrec] = "demo-banner-pangle-mrec"
            ids[.startapp] = "demo-banner-startapp"
            ids[.unity] = "demo-banner-unityads"
        #endif
        return ids
    }()

    static let appOpen: [AdSource: String] = {
        var ids: [AdSource: String] = [
            .yandex: "demo-appopenad-yandex",
        ]
        ids[.mintegral] = "demo-appopenad-mintegral"
        ids[.vungle] = "demo-appopenad-vungle"
        #if COCOAPODS
            ids[.bigo] = "demo-appopenad-bigoads"
            ids[.pangle] = "demo-appopenad-pangle"
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
    static let feedAdYandex = "demo-feed-yandex"
}

@MainActor
enum UnifiedAdFactory {
    private enum Sizes {
        static let yandexInline: (w: CGFloat, h: CGFloat) = (320, 50)
        static let adfoxSticky: (w: CGFloat, maxH: CGFloat) = (300, 300)
    }

    @MainActor
    static func makeAdapter(source: AdSource, format: UnifiedFormat, hostViewController: UIViewController) -> UnifiedAdProtocol {
        switch format {
        case .interstitial:
            let id = requireID(FactoryIDs.interstitial, source, format: format)
            switch source {
            case .adfox:
                return AdFoxInterstitialAdapter(adUnitID: id)
            case .admobReverseAdapter:
                return AdMobInterstitialAdapter(adUnitID: id, hostViewController: hostViewController)
            default:
                return YandexInterstitialAdapter(adUnitID: id)
            }

        case .rewarded:
            let id = requireID(FactoryIDs.rewarded, source, format: format)
            switch source {
            case .admobReverseAdapter:
                return AdMobRewardedAdapter(adUnitID: id, hostViewController: hostViewController)
            default:
                return YandexRewardedAdapter(adUnitID: id)
            }

        case .appOpen:
            let id = requireID(FactoryIDs.appOpen, source, format: format)
            return YandexAppOpenAdapter(adUnitID: id)

        case .bannerInline:
            let id = requireID(FactoryIDs.banner, source, format: format)
            return YandexInlineBannerAdapter(adUnitID: id)

        case .bannerSticky:
            if source == .adfox {
                return AdFoxBannerAdapter(
                    adUnitID: FactoryIDs.bannerStickyAdFox,
                    adWidth: Sizes.adfoxSticky.w,
                    maxHeight: Sizes.adfoxSticky.maxH
                )
            }
            let id = requireID(FactoryIDs.banner, source, format: format)
            return YandexStickyBannerAdapter(adUnitID: id)

        case .banner:
            let id = requireID(FactoryIDs.banner, source, format: format)
            switch source {
            case .admobReverseAdapter:
                return AdMobBannerAdapter(adUnitID: id, hostViewController: hostViewController)
            default:
                return YandexInlineBannerAdapter(
                    adUnitID: id,
                    width: Sizes.yandexInline.w,
                    height: Sizes.yandexInline.h
                )
            }

        case .nativeBulk:
            return YandexNativeBulkAdapter(adUnitID: FactoryIDs.nativeBulkYandex)

        case .nativeTemplate:
            let id = requireID(FactoryIDs.nativeTemplate, source, format: format)
            return if case .adfox = source {
                AdFoxNativeAdapter(adUnitID: id)
            } else {
                AdMobNativeAdapter(adUnitID: id, hostViewController: hostViewController)
            }

        case .nativeCustom:
            return YandexNativeCustomAdapter(adUnitID: "demo-native-video-yandex")

        case .instreamSingle:
            return YandexInstreamSingleAdapter(pageID: "demo-instream-vmap-yandex")

        case .instreamInrolls:
            return YandexAdBreaksAdapter(pageID: "demo-instream-vmap-yandex")

        case .feedAd:
            return YandexFeedAdAdapter(adUnitID: FactoryIDs.feedAdYandex)

        case .carousel:
            return AdFoxSliderAdapter(adUnitID: FactoryIDs.carouselAdFox)
        }
    }

    // MARK: - Helpers

    @inline(__always)
    private static func requireID(_ map: [AdSource: String], _ source: AdSource, format: UnifiedFormat) -> String {
        if let id = map[source] { return id }
        preconditionFailure("Missing AdUnit ID for format=\(format) source=\(source)")
    }
}
