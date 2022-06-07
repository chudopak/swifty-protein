//
//  PopupSizes.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/7/22.
//

import UIKit

struct PopupSizes {
    let width: CGFloat = 250
    let cornerRadius: CGFloat = 10
    let bottomSpace: CGFloat = 10
    
    var titleLabelWidth: CGFloat {
        return width * 0.8
    }
    let titleLabelHeight: CGFloat = 25
    let titleLabelTopOffset: CGFloat = 10
    
    var descriptionLabelWidth: CGFloat {
        return width * 0.8
    }
    let descriptionLabelMaxTextSize = 250
    let descriptionLabelTopOffset: CGFloat = 10
    
    let buttonHeight: CGFloat = 40
    let maxButtons = 3
    
    let separateButtonsLineHeight: CGFloat = 1
    
    let stackViewSpacing: CGFloat = 1
}
