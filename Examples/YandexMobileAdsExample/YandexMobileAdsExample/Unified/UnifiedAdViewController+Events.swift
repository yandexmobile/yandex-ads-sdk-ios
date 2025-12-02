import UIKit

extension UnifiedAdViewController {
    func wireEvents() {
        guard let adapter = self.adapter else { return }
        adapter.onEvent = { [weak self] event in
            guard let self else { return }
            
            switch event {
            case .loaded:
                self.hasLoadedCurrentAd = true
                self.logsView.appendLogLine(StateUtils.loaded)
                
                if let inline = adapter.inlineView {
                    if inline.superview != nil {
                        inline.removeFromSuperview()
                    }
                    
                    inline.accessibilityIdentifier = CommonAccessibility.bannerView
                    inline.translatesAutoresizingMaskIntoConstraints = false
                    self.view.addSubview(inline)
                    self.currentInlineView = inline
                    self.currentInlineConstraints = [
                        inline.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: Layout.side),
                        inline.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -Layout.side),
                        inline.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
                        inline.bottomAnchor.constraint(equalTo: self.headerStack.topAnchor, constant: -16)
                    ]
                    NSLayoutConstraint.activate(self.currentInlineConstraints)
                }
                
                switch self.currentFormat {
                case .appOpen:
                    self.placeholderIconView.image = UIImage(
                        systemName: "rectangle.portrait.and.arrow.right",
                        withConfiguration: UIImage.SymbolConfiguration(pointSize: Layout.iconPoint, weight: .regular)
                    )
                    self.placeholderLabel.text = PlaceholderState.Message.appOpenLoaded
                    self.stopPlaceholderIconAnimation()
                    self.setPlaceholder(visible: true, animated: true)
                    self.view.bringSubviewToFront(self.placeholderView)
                    
                case .interstitial, .rewarded:
                    if adapter.inlineView == nil {
                        self.updatePlaceholder(state: .fullscreenHint, visible: true, animated: true)
                    } else {
                        self.setPlaceholder(visible: false, animated: true)
                    }
                    
                default:
                    self.setPlaceholder(visible: false, animated: true)
                }
                
            case .failedToLoad(let error):
                self.hasLoadedCurrentAd = false
                self.logsView.appendLogLine(StateUtils.loadError(error))
                self.updatePlaceholder(state: .error(PlaceholderState.Message.failedToLoad), visible: true, animated: true)
                
            case .shown:
                self.logsView.appendLogLine(StateUtils.shown)
                self.setPlaceholder(visible: false, animated: true)
                
            case .failedToShow(let error):
                self.logsView.appendLogLine(StateUtils.showError(error))
                self.updatePlaceholder(state: .error(PlaceholderState.Message.failedToShow), visible: true, animated: true)
                
            case .dismissed:
                if let reward = self.pendingReward {
                    self.pendingReward = nil
                    DispatchQueue.main.async { [weak self] in
                        self?.presentRewardAlert(reward)
                    }
                }
                self.showIdlePromptIfNeeded()
                self.logsView.appendLogLine(StateUtils.dismissed)
            case .clicked:
                self.logsView.appendLogLine(StateUtils.clicked)
                
            case .impression:
                self.logsView.appendLogLine(StateUtils.impression)
                
            case .rewarded(let reward):
                self.pendingReward = reward
                self.logsView.appendLogLine("Reward received: \(reward.amount) \(reward.type)")
            }
            
            self.updatePresentAvailability()
        }
    }
    
    func showIdlePromptIfNeeded() {
        switch currentFormat {
        case .interstitial, .rewarded, .appOpen:
            updatePlaceholder(state: .idle, visible: true, animated: true)
            view.bringSubviewToFront(placeholderView)
            hasLoadedCurrentAd = false
            presentButton.isEnabled = false
        default:
            break
        }
    }
}
