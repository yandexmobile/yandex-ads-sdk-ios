import Foundation

enum AdSource: String, CaseIterable {
    case yandex = "Yandex"
    case adfox  = "AdFox"
    #if COCOAPODS
    case applovin = "AppLovin"
    case bigo = "BigoAds"
    case chartboost = "Chartboost"
    case google = "Google"
    case inmobi = "InMobi"
    case ironsource = "IronSource"
    case mintegral = "Mintegral"
    case mytarget = "MyTarget"
    case pangle = "Pangle"
    case pangleMrec = "Pangle-mrec"
    case startapp = "StartApp"
    case unity = "UnityAds"
    case vungle = "Vungle"
    #else
    case applovin = "AppLovin"
    case google = "Google"
    case mintegral = "Mintegral"
    case mytarget = "MyTarget"
    case vungle = "Vungle"
    #endif
    case admobReverseAdapter = "AdMobReverseAdapter"

    var title: String { rawValue }
}
