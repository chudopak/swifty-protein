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
    
    lazy var filmImageView = makeFilmImageView()
    lazy var titleLabel = makeTitleLabel()
    lazy var ratingLabel = makeRatingLabel()
    lazy var noImageLabel = makeNoImageLabel()
    
    var id = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(filmImageView)
        addSubview(titleLabel)
        filmImageView.addSubview(ratingLabel)
        filmImageView.addSubview(noImageLabel)
        noImageLabel.isHidden = true
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilmCollectionViewCell {
    
    private func makeFilmImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.backgroundColor = Asset.Colors.disabledAuthorizationButtonBackground.color
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: FavouriteScreenSizes.FilmCollectionViewCell.fontSize)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.text = ""
        return label
    }
    
    private func makeRatingLabel() -> UILabel {
        let label = UILabel()
        label.layer.borderWidth = FavouriteScreenSizes.FilmCollectionViewCell.ratingBorderWidth
        label.layer.borderColor = Asset.Colors.deepBlue.color.cgColor
        label.layer.cornerRadius = FavouriteScreenSizes.FilmCollectionViewCell.ratingHeight * 0.5
        label.font = .systemFont(ofSize: FavouriteScreenSizes.FilmCollectionViewCell.fontSize)
        label.textColor = Asset.Colors.deepBlue.color
        label.textAlignment = .center
        label.text = ""
        label.numberOfLines = 1
        label.backgroundColor = Asset.Colors.primaryBackground.color
        label.clipsToBounds = true
        return label
    }
    
    private func makeNoImageLabel() -> UILabel {
        let label = UILabel()
        label.textColor = Asset.Colors.disabledAuthorizationButtonText.color
        label.textAlignment = .center
        label.text = Text.Common.noPoster
        label.numberOfLines = 2
        label.clipsToBounds = true
        return label
    }
}

extension FilmCollectionViewCell {
    
    private func setConstraints() {
        setFilmImageViewConstraints()
        setTitleLabelConstraints()
        setRatingLabelConstraints()
        setNoImageLabelConstraints()
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
    
    private func setRatingLabelConstraints() {
        ratingLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(FavouriteScreenSizes.FilmCollectionViewCell.ratingTopOffset)
            maker.trailing.equalToSuperview().inset(FavouriteScreenSizes.FilmCollectionViewCell.ratingRightOffset)
            maker.height.equalTo(FavouriteScreenSizes.FilmCollectionViewCell.ratingHeight)
            maker.width.equalTo(FavouriteScreenSizes.FilmCollectionViewCell.ratingWidth)
        }
    }
    
    private func setNoImageLabelConstraints() {
        noImageLabel.snp.makeConstraints { maker in
            maker.bottom.top.leading.trailing.equalToSuperview().inset(FavouriteScreenSizes.FilmCollectionViewCell.noImageLabelSideOffset)
        }
    }
}
