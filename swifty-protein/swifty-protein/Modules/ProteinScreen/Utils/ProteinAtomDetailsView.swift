//
//  ProteinAtomDetailsView.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/16/22.
//

import UIKit

final class ProteinAtomDetailsView: UIView {
    
    init() {
        super.init(frame: .zero)
        setView()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        clipsToBounds = true
        backgroundColor = Asset.atomInfoBackgroundColor.color
    }
}
