//
//  UITextField+addBottomLine.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/13/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

extension UITextField {
    
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
