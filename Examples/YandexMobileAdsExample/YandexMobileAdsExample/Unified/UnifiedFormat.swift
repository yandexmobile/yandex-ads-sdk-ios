import Foundation

enum UnifiedFormat: String, CaseIterable {
    case banner = "Banner"
    case bannerInline = "Banner (Inline)"
    case bannerSticky = "Banner (Sticky)"
    case carousel = "Carousel"
    case interstitial = "Interstitial"
    case rewarded = "Rewarded"
    case appOpen = "App Open"
    case nativeTemplate = "Native (Template)"
    case nativeCustom = "Native (Custom)"
    case nativeBulk = "Native (Bulk)"
    case instreamSingle = "Instream (Single)"
    case instreamInrolls = "Instream (Inroll)"
}
