/*
 * Version for iOS © 2015–2025 YANDEX
 *
 * You may not use this file except in compliance with the License.
 * You may obtain a copy of the License at https://yandex.com/legal/mobileads_sdk_agreement/
 */

import UIKit
import CoreGraphics

class ViewVisibilityValidator {
    func validateVisible(_ view: UIView?, for minPercent: Double) -> Bool {
        let application = UIApplication.shared
        guard let view = view, let targetView = application.keyWindow else { return false }

        let addedToScreen = application.applicationState == .active && isHierarchyVisible(view) && view.window != nil
        let percent = visiblePercent(for: view, in: targetView)
        return addedToScreen && percent >= minPercent
    }

    private func isHierarchyVisible(_ inputView: UIView) -> Bool {
        var result = true
        var currentView: UIView? = inputView
        while let view = currentView {
            if view.isHidden || view.alpha < CGFloat.ulpOfOne {
                result = false
            }
            currentView = view.superview
        }
        return result
    }

    private func visiblePercent(for view: UIView, in targetView: UIView) -> Double {
        var percent = 0.0
        let viewArea = view.frame.width * view.frame.height
        if viewArea > CGFloat.ulpOfOne {
            let intersectionFrame = visibleRect(for: view, in: targetView)
            let visibleArea = intersectionFrame.width * intersectionFrame.height
            percent = Double(visibleArea / viewArea * 100.0)
        }
        return percent
    }

    func visibleRect(for view: UIView, in targetView: UIView) -> CGRect {
        var result = view.bounds
        var currentView = view
        var currentSuperview = view.superview
        var passedView = currentView
        var intersection = currentView.bounds

        while let superview = currentSuperview, passedView != targetView {
            if superview.clipsToBounds || superview == targetView {
                let frameInViewFrame = currentView.convert(intersection, to: superview)
                intersection = frameInViewFrame.intersection(superview.bounds)
                result = intersection
                currentView = superview
            }
            passedView = superview
            currentSuperview = superview.superview
        }
        if currentSuperview == nil && passedView != targetView {
            result = CGRect.zero
        }
        return result
    }
}
