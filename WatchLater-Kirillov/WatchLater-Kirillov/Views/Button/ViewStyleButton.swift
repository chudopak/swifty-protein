//
//  ViewStyleButton.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/25/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class ViewStyleButton: UIButton {
    
    enum ViewStyle {
        case noStyle
        case collectionView(UIImage)
        case tableVeiw(UIImage)
    }

    var style: ViewStyle {
        didSet {
            changeButtonImage(style: style)
        }
    }
    
    init(style: ViewStyle) {
        self.style = style
        super.init(frame: .zero)
        changeButtonImage(style: style)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func changeButtonImage(style: ViewStyle) {
        switch style {
        case .collectionView(let image):
            setImage(image, for: .normal)
        
        case .tableVeiw(let image):
            setImage(image, for: .normal)
        
        default:
            break
        }
    }
}
