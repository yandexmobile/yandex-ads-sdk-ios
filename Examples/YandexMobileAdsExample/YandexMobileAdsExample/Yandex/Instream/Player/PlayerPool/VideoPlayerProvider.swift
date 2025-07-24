/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation

class VideoPlayerProvider<Player> where Player: ReusablePlayer {
    private var freePlayers = [VideoAVPlayer]()
    private let cache: LRUCache<Player, VideoAVPlayer>

    init(maxSize: Int) {
        cache = LRUCache(maxSize)
        freePlayers = (0..<maxSize + 1).map { _ in VideoAVPlayer() }
        cache.delegate = self
    }

    func player(for reusedPlayer: Player) -> VideoAVPlayer {
        if let cachedPlayer = cache.get(reusedPlayer) {
            return cachedPlayer
        } else {
            let player = freePlayers.removeLast()
            cache.set(reusedPlayer, value: player)
            return player
        }
    }
}

extension VideoPlayerProvider: LRUCacheDelegate {
    func cacheWillRemove(_ key: Any, _ entry: Any) {
        freePlayers.append(entry as! VideoAVPlayer)
        (key as! Player).free()
    }
}
