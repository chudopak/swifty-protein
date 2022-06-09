//
//  ProteinListTableViewCell.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/9/22.
//

import UIKit
import SnapKit

final class ProteinListTableViewCell: UITableViewCell {
    
    static let identifier = "ProteinListTableViewCell"
    
    lazy var nameLabel = makeLigandNameLabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        accessoryType = .disclosureIndicator
        addSubview(nameLabel)
        setNameConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProteinListTableViewCell {
    
    private func makeLigandNameLabel() -> UILabel {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = Asset.textColor.color
        label.font = .systemFont(ofSize: ProteinListSizes.ProteinCell.fontSize)
        return label
    }
}

extension ProteinListTableViewCell {
    
    private func setNameConstraints() {
        nameLabel.snp.makeConstraints { maker in
            maker.centerY.equalToSuperview()
            maker.leading.trailing.equalTo(layoutMarginsGuide)
            maker.height.equalTo(ProteinListSizes.ProteinCell.height)
        }
    }
}
