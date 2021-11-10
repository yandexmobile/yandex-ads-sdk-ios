/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

protocol VideoAVPlayerDelegate: AnyObject {
    func playerDidPrepare(_ player: VideoAVPlayer)

    func playerDidStart(_ player: VideoAVPlayer)

    func playerDidComplete(_ player: VideoAVPlayer)

    func playerDidResume(_ player: VideoAVPlayer)

    func playerDidPause(_ player: VideoAVPlayer)

    func playerDidFailToPlay(_ player: VideoAVPlayer)

    func playerDidStop(_ player: VideoAVPlayer)

    func playerDidUpdateVolume(_ player: VideoAVPlayer, _ volume: Double)
}
