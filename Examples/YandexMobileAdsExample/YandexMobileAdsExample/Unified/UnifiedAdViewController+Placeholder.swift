import UIKit

extension UnifiedAdViewController {
    func updatePlaceholder(state: PlaceholderState, visible: Bool, animated: Bool) {
        switch state {
        case .idle:
            placeholderIconView.image = UIImage(
                systemName: "rectangle.and.hand.point.up.left",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: Layout.iconPoint, weight: .regular)
            )
            placeholderLabel.text = PlaceholderState.Message.selectFormatAndSource
            stopPlaceholderIconAnimation()
            
        case .loading:
            placeholderIconView.image = UIImage(
                systemName: "arrow.triangle.2.circlepath",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: Layout.iconPoint, weight: .regular)
            )
            placeholderLabel.text = PlaceholderState.Message.loading
            startRotationAnimation()
            
        case .fullscreenHint:
            placeholderIconView.image = UIImage(
                systemName: "arrow.up.left.and.arrow.down.right",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: Layout.iconPoint, weight: .regular)
            )
            placeholderLabel.text = PlaceholderState.Message.presentFullscreen
            startPulseAnimation()
            
        case .error(let message):
            placeholderIconView.image = UIImage(
                systemName: "exclamationmark.triangle",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: Layout.iconPoint, weight: .regular)
            )
            placeholderLabel.text = message
            stopPlaceholderIconAnimation()
        }
        
        setPlaceholder(visible: visible, animated: animated)
        if visible { view.bringSubviewToFront(placeholderView) }
    }
    
    func startPulseAnimation() {
        placeholderIconView.layer.removeAllAnimations()
        let pulse = CABasicAnimation(keyPath: "transform.scale")
        pulse.fromValue = 1.0
        pulse.toValue = 1.08
        pulse.duration = 1.2
        pulse.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        placeholderIconView.layer.add(pulse, forKey: "pulse")
    }
    
    func startRotationAnimation() {
        placeholderIconView.layer.removeAllAnimations()
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0
        rotate.toValue = CGFloat.pi * 2
        rotate.duration = 1.0
        rotate.repeatCount = .infinity
        placeholderIconView.layer.add(rotate, forKey: "rotate")
    }
    
    func stopPlaceholderIconAnimation() {
        placeholderIconView.layer.removeAllAnimations()
    }
    
    func setPlaceholder(visible: Bool, animated: Bool) {
        let apply: () -> Void = {
            let alpha: CGFloat = visible ? 1 : 0
            self.placeholderView.alpha = alpha
            self.placeholderIconView.alpha = alpha
            self.placeholderLabel.alpha = alpha
        }
        
        if animated {
            placeholderView.isHidden = false
            placeholderView.alpha = visible ? 0 : 1
            placeholderIconView.alpha = placeholderView.alpha
            placeholderLabel.alpha = placeholderView.alpha
            UIView.animate(withDuration: 0.2, animations: apply) { _ in
                self.placeholderView.isHidden = !visible
            }
        } else {
            placeholderView.isHidden = !visible
            apply()
        }
    }
}
