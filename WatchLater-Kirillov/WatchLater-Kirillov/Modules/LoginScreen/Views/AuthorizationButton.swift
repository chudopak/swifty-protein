//
//  AuthorizationButton.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/13/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

struct AuthorizationButtonColorSet {
    let enabledTint: UIColor
    let enabledBackground: UIColor
    let enabledBorder: UIColor
    let disabledTint: UIColor
    let disabledBackground: UIColor
    let disabledBorder: UIColor
}

class AuthorizationButton: UIButton {
    
    private var colorSet: AuthorizationButtonColorSet!
    
    init(colorSet: AuthorizationButtonColorSet, text: String) {
        super.init(frame: .zero)
        self.colorSet = colorSet
        backgroundColor = colorSet.disabledBackground
        tintColor = colorSet.disabledTint
        setTitle(text, for: .normal)
        layer.cornerRadius = LoginScreenSizes.AuthorizationButton.cornerRadius
        layer.borderColor = colorSet.disabledBorder.cgColor
        layer.borderWidth = LoginScreenSizes.AuthorizationButton.borderWidth
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
