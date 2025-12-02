import Foundation
import YandexMobileAds

final class RewardBox: NSObject, Reward {
    let amount: Int
    let type: String
    
    init(amount: Int, type: String) {
        self.amount = amount
        self.type = type
        super.init()
    }
}
