/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import Foundation
import YandexMobileAds

final class NativeVideoMuteControlView: UIButton, NativeVideoPlaybackMuteControl {
    weak var delegate: NativeVideoPlaybackMuteControlDelegate?
    private var isMuted = false

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(withIsMuted isMuted: Bool) {
        self.isMuted = isMuted
        updateText()
    }

    func configure(withIsHidden isHidden: Bool) {
        self.isHidden = isHidden
    }

    private func setupView() {
        addTarget(self, action: #selector(handleButtonClick), for: .touchUpInside)
        updateText()
    }

    private func updateText() {
        setTitle(isMuted ? "unmute" : "mute", for: .normal)
    }

    @objc
    private func handleButtonClick() {
        isMuted.toggle()
        delegate?.muteControl(self, didChangeIsMuted: isMuted)
        updateText()
    }
}
