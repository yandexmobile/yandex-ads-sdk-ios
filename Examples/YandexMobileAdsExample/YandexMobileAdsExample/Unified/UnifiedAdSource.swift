import Foundation

enum AdSource: String, CaseIterable {
    case yandex = "Yandex"
    case adfox  = "AdFox"
    #if COCOAPODS
    case applovin = "AppLovin"
    case bigo = "BigoAds"
    case chartboost = "Chartboost"
    case admob = "AdMob"
    case inmobi = "InMobi"
    case ironsource = "IronSource"
    case mintegral = "Mintegral"
    case mytarget = "MyTarget"
    case startapp = "StartApp"
    case unity = "UnityAds"
    case vungle = "Vungle"
    #else
    case applovin = "AppLovin"
    case mintegral = "Mintegral"
    case mytarget = "MyTarget"
    case vungle = "Vungle"
    #endif

    var title: String { rawValue }
}
