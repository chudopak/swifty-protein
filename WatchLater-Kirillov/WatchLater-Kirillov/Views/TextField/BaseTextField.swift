//
//  BaseTextField.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/23/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class BaseTextField: UITextField {
    
    var inset: UIEdgeInsets!
    
    init(inset: UIEdgeInsets) {
        super.init(frame: .zero)
        self.inset = inset
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        let originalRect = super.clearButtonRect(forBounds: bounds)
        return originalRect.offsetBy(dx: -inset.left, dy: 0)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rect.inset(by: inset)
    }
        
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rect.inset(by: inset)
    }
    
    func addBottomBoarder(color: UIColor, height: CGFloat, sideOffset: CGFloat) {
        let borderView = UIView()
        borderView.backgroundColor = color
        borderView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(borderView)
        NSLayoutConstraint.activate([
            borderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: sideOffset),
            borderView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -sideOffset),
            borderView.bottomAnchor.constraint(equalTo: bottomAnchor),
            borderView.heightAnchor.constraint(equalToConstant: height)
        ])
    }
}
