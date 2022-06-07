//
//  PopUpView.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/7/22.
//

import UIKit

final class Popup: UIView {
    
    init(title: String, description: String) {
        super.init(frame: UIScreen.main.bounds)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        backgroundColor = Asset.grayTransparent.color
        
    }
}

extension Popup {
    
    private func makeTitleLabel(title: String) -> UILabel {
        let label = UILabel()
        label.text = title
        label.textColor = Asset.textColor.color
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }
}
