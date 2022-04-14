//
//  AuthorizationButton.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/13/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

struct AuthorizationButtonColorSet {
    let enabledText: UIColor
    let enabledBackground: UIColor
    let enabledBorder: UIColor
    let disabledText: UIColor
    let disabledBackground: UIColor
    let disabledBorder: UIColor
}

class AuthorizationButton: UIButton {
    
    private var colorSet: AuthorizationButtonColorSet!

    let fontSize: CGFloat = 17
    
    override var isEnabled: Bool {
        didSet {
            changeColorSet()
        }
    }
    
    override var isHighlighted: Bool {
        didSet {
            isHighlighted
                ? animateButtonAlpha(duration: 0.1, alpha: 0.5)
                : animateButtonAlpha(duration: 0.1, alpha: 1)
        }
    }
    
    init(colorSet: AuthorizationButtonColorSet, text: String) {
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
            animateButtonAlpha(duration: 0.2, alpha: 0.2)
            backgroundColor = colorSet.enabledBackground
            setTitleColor(colorSet.enabledText, for: .normal)
            layer.borderColor = colorSet.enabledBorder.cgColor
            alpha = 0.2
            animateButtonAlpha(duration: 0.5, alpha: 1)
        } else {
            animateButtonAlpha(duration: 0.5, alpha: 0.2)
            backgroundColor = colorSet.disabledBackground
            setTitleColor(colorSet.disabledText, for: .normal)
            layer.borderColor = colorSet.disabledBorder.cgColor
            alpha = 0.2
            animateButtonAlpha(duration: 0.2, alpha: 1)
        }
    }
    
    private func animateButtonAlpha(duration: TimeInterval, alpha: CGFloat) {
        UIView.animate(withDuration: duration,
                       delay: 0.0,
                       options: .curveLinear, animations: { [weak self] in
                        self?.alpha = alpha
                       }, completion: { _ in })
    }
}
