//
//  CustomButton.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/3/22.
//

import UIKit

class CustomButton: UIButton {
    
    private(set) var tapDuration: TimeInterval = 0.1
    private(set) var highlightedStateAlpha: CGFloat = 0.5
    private(set) var normalStateAlpha: CGFloat = 1
    
    override var isHighlighted: Bool {
        didSet {
            isHighlighted
                ? animateButtonAlpha(duration: tapDuration, alpha: highlightedStateAlpha)
                : animateButtonAlpha(duration: tapDuration, alpha: normalStateAlpha)
        }
    }
    
    private func animateButtonAlpha(duration: TimeInterval, alpha: CGFloat) {
        UIView.animate(
            withDuration: duration,
            delay: .zero,
            options: .curveLinear,
            animations: { [weak self] in
                self?.alpha = alpha
            }, completion: { _ in }
        )
    }
}
