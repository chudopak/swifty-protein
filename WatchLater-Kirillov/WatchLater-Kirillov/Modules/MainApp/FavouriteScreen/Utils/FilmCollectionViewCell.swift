//
//  FilmCollectionViewCell.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/25/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

class FilmCollectionViewCell: UICollectionViewCell {

    static let identifier = "FilmCollectionViewCell"
    
    private lazy var filmImageView = makeFilmImageView()
    private lazy var titleLabel = makeTitleLabel()
    
    var filmInfo: FilmInfo! {
        didSet {
            updateView()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(filmImageView)
        addSubview(titleLabel)
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateView() {
        titleLabel.text = filmInfo.title
    }
}

extension FilmCollectionViewCell {
    
    private func makeFilmImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = .brown
        return imageView
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = ""
        label.backgroundColor = .red
        return label
    }
}

extension FilmCollectionViewCell {
    
    private func setConstraints() {
        setFilmImageViewConstraints()
        setTitleLabelConstraints()
    }
    
    private func setFilmImageViewConstraints() {
        filmImageView.snp.makeConstraints { maker in
            maker.top.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview().multipliedBy(FavouriteScreenSizes.FilmCollectionViewCell.ratioFilmImageHeightWithCellHeight)
        }
    }
    
    private func setTitleLabelConstraints() {
        titleLabel.snp.makeConstraints { maker in
            maker.bottom.leading.trailing.equalToSuperview()
            maker.height.equalToSuperview().multipliedBy(FavouriteScreenSizes.FilmCollectionViewCell.ratioTitleLabelHeightWithCellHeight)
        }
    }
}
