//
//  KeyboardView.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/3/22.
//

import UIKit

final class KeyboardView: UIView {
    
    init() {
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

// MARK: Creating UI elements

extension KeyboardView {
    
    private func makeNumberButton(number: Int) -> CustomButton {
        let button = CustomButton()
        button.layer.cornerRadius = LoginSizes.KeboardButton.cornerRadius
        button.layer.borderWidth = LoginSizes.KeboardButton.boarderWidth
        button.tag = number
        button.setTitle(String(number), for: .normal)
        return button
    }
}
