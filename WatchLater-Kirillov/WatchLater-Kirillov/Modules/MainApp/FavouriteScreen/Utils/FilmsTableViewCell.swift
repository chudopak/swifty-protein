//
//  FilmsTableViewCell.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

class FilmsTableViewCell: UITableViewCell {
    
    lazy var titleLabel = makeTitleLabel()
    
    static let identifier = "FilmsTableViewCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        accessoryType = .disclosureIndicator
        addSubview(titleLabel)
        setTitleLabelConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilmsTableViewCell {
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }
}

extension FilmsTableViewCell {
    
    private func setTitleLabelConstraints() {
        titleLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.equalTo(layoutMarginsGuide)
            maker.trailing.equalTo(layoutMarginsGuide).inset(FavouriteScreenSizes.FilmsTableViewCell.trailingAccessoryZoneInset)
            maker.height.equalTo(FavouriteScreenSizes.FilmsTableViewCell.height)
        }
    }
}
