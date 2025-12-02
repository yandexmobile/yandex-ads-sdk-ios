import YandexMobileAds

enum UnifiedAdEvent {
    case loaded
    case failedToLoad(Error)
    case shown
    case failedToShow(Error)
    case dismissed
    case clicked
    case impression
    case rewarded(Reward)
}
