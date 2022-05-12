//
//  BaseBorderButton.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/13/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class BaseBorderButton: UIButton {
    
    struct ColorSet {
        let enabledText: UIColor
        let enabledBackground: UIColor
        let enabledBorder: UIColor
        let disabledText: UIColor
        let disabledBackground: UIColor
        let disabledBorder: UIColor
    }
    
    private let highlightedStateAlpha: CGFloat = 0.5
    private let normalStateAlpha: CGFloat = 1
    private let switchingStatesAlpha: CGFloat = 0.2
    
    private let tapDuration: TimeInterval = 0.1
    private let enabledDuration: TimeInterval = 0.5
    private let disabledDuration: TimeInterval = 0.2
    
    private var colorSet: ColorSet!
    
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
    
    init(colorSet: BaseBorderButton.ColorSet, text: String, fontSize: CGFloat) {
        super.init(frame: .zero)
        self.colorSet = colorSet
        isEnabled = false
        setTitle(text, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        layer.borderWidth = LoginScreenSizes.AuthorizationButton.borderWidth
        layer.cornerRadius = LoginScreenSizes.AuthorizationButton.cornerRadius
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func changeColorSet() {
        if isEnabled {
            animateButtonAlpha(duration: disabledDuration, alpha: switchingStatesAlpha)
            backgroundColor = colorSet.enabledBackground
            setTitleColor(colorSet.enabledText, for: .normal)
            layer.borderColor = colorSet.enabledBorder.cgColor
            alpha = switchingStatesAlpha
            animateButtonAlpha(duration: enabledDuration, alpha: normalStateAlpha)
        } else {
            animateButtonAlpha(duration: enabledDuration, alpha: switchingStatesAlpha)
            backgroundColor = colorSet.disabledBackground
            setTitleColor(colorSet.disabledText, for: .normal)
            layer.borderColor = colorSet.disabledBorder.cgColor
            alpha = switchingStatesAlpha
            animateButtonAlpha(duration: disabledDuration, alpha: normalStateAlpha)
        }
    }
    
    private func animateButtonAlpha(duration: TimeInterval, alpha: CGFloat) {
        UIView.animate(withDuration: duration,
                       delay: .zero,
                       options: .curveLinear, animations: { [weak self] in
                        self?.alpha = alpha
                       }, completion: { _ in })
    }
}
