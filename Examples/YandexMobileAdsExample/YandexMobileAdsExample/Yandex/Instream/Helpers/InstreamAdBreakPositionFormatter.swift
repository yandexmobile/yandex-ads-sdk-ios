/*
 * Version for iOS © 2015–2021 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import YandexMobileAdsInstream

class InstreamAdBreakPositionFormatter {
    func positionDescription(for position: InstreamAdBreakPosition) -> String {
        var result = String(position.value)
        switch position.type {
        case InstreamAdBreakPositionType.percents:
            result = result + "%"
        case InstreamAdBreakPositionType.milliseconds:
            result = result + "ms"
        case InstreamAdBreakPositionType.position:
            result = "#" + result
        default:
            break
        }
        return result
    }
}
