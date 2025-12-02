/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */
 
import Foundation
import YandexMobileAdsInstream
import AVFoundation

class AdPlayerErrorConverter {
    func convert(_ reason: InstreamAdPlayerErrorReason) -> InstreamAdPlayerError {
        .init(reason: reason)
    }

    func convert(_ error: Error?) -> InstreamAdPlayerError {
        guard let error = error as NSError? else {
            return .init(reason: .unknown)
        }
        let reason: InstreamAdPlayerErrorReason

        switch error.domain {
        case AVFoundationErrorDomain where error.code == AVError.serverIncorrectlyConfigured.rawValue:
            reason = .invalidFile
        case NSURLErrorDomain where error.code == NSURLErrorFileDoesNotExist,
            NSURLErrorDomain where error.code == NSURLErrorNoPermissionsToReadFile:
            reason = .fileNotFound
        case NSURLErrorDomain where error.code == NSURLErrorTimedOut:
            reason = .timedOut
        case NSURLErrorDomain where error.code == NSURLErrorNotConnectedToInternet:
            reason = .netwrokUnavailable
        case AVFoundationErrorDomain where error.code == AVError.fileFormatNotRecognized.rawValue:
            reason = .unsupportedFileFormat
        case AVFoundationErrorDomain where error.code == AVError.unknown.rawValue:
            reason = reasonForUnknownAVError(error)
        default:
            reason = .unknown
        }

        return .init(reason: reason, underlyingError: error)
    }

    private final func reasonForUnknownAVError(_ error: NSError) -> InstreamAdPlayerErrorReason {
        guard let underlyingError = error.underlyingError, underlyingError.isAVFormatError else {
            return .fileNotFound
        }
        return .unsupportedCodec
    }
}

private extension InstreamAdPlayerError {
    convenience init(reason: InstreamAdPlayerErrorReason) {
        self.init(reason: reason, underlyingError: EmptyError())
    }

    private struct EmptyError: Error {}
}

private extension Error {
    var underlyingError: Error? {
        let nsError = self as NSError
        guard #available(iOS 14.5, *) else {
            return nsError.userInfo[NSUnderlyingErrorKey] as? Error
        }
        return nsError.underlyingErrors.first
    }
}

private let kAVErrorFourCharCode = "AVErrorFourCharCode"
private let AVErrorFourCharCodeFormat = "\'fmt?\'"

private extension Error {
    var isAVFormatError: Bool {
        let nsError = self as NSError
        guard let errorFourCharCode = nsError.userInfo[kAVErrorFourCharCode] as? String else {
            return false
        }
        return nsError.domain == NSOSStatusErrorDomain && errorFourCharCode == AVErrorFourCharCodeFormat
    }
}
