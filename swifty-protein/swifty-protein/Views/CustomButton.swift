//
//  CustomButton.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/3/22.
//

import UIKit

class CustomButton: UIButton {
    
    struct Colors {
        let boarderColor: UIColor
        let backgroundColor: UIColor
        let textColor: UIColor
    }
    
    private(set) var tapDuration: TimeInterval = 0.1
    private(set) var switchingStatesDuration: TimeInterval = 0.2

    private(set) var highlightedStateAlpha: CGFloat = 0.5
    private(set) var normalStateAlpha: CGFloat = 1
    private(set) var switchingStatesAlpha: CGFloat = 0.2
    
    private(set) var enabledColors: Colors?
    private(set) var disabledColors: Colors?
    
    override var isEnabled: Bool {
        didSet {
            changeColorSet()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            isHighlighted
                ? animateButtonAlpha(duration: tapDuration, alpha: highlightedStateAlpha)
                : animateButtonAlpha(duration: tapDuration, alpha: normalStateAlpha)
        }
    }
    
    private func changeColorSet() {
        guard enabledColors != nil && disabledColors != nil,
              let colors = getColorsDependsOnState()
        else {
            return
        }
        animateButtonAlpha(duration: switchingStatesDuration, alpha: switchingStatesAlpha)
        backgroundColor = colors.backgroundColor
        setTitleColor(colors.textColor, for: .normal)
        layer.borderColor = colors.boarderColor.cgColor
        animateButtonAlpha(duration: switchingStatesDuration, alpha: normalStateAlpha)
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
    
    private func getColorsDependsOnState() -> Colors? {
        if isEnabled {
            guard let colors = enabledColors
            else {
                return nil
            }
            return colors
        } else {
            guard let colors = disabledColors
            else {
                return nil
            }
            return colors
        }
    }
}
