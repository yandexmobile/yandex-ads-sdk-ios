#if COCOAPODS
import GoogleMobileAds

enum AdMobStarter {
    private static var started = false
    private static var queue: [() -> Void] = []
    
    static func startIfNeeded(_ completion: @escaping () -> Void) {
        if started { completion(); return }
        queue.append(completion)
        guard queue.count == 1 else { return }
        
        print("AdMob MobileAds: starting…")
        GoogleMobileAds.MobileAds.shared.start { _ in
            print("AdMob MobileAds: started")
            started = true
            let callbacks = queue
            queue.removeAll()
            DispatchQueue.main.async { callbacks.forEach { $0() } }
        }
    }
}
#endif
