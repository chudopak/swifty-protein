//
//  SearchFilmTableViewCell.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/4/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class SearchFilmTableViewCell: UITableViewCell {
    
    static let identifier = "SearchFilmTableViewCell"
    lazy var posterImageView = makeImageView()
    lazy var yearLabel = makeLabel(fontSize: SearchScreenSizes.TableView.yearFontSize)
    lazy var titleLabel = makeLabel(fontSize: SearchScreenSizes.TableView.titleFontSize)
    private lazy var stackView = makeStackView(views: [titleLabel, yearLabel])
    lazy var ratingLabel = makeRatingLabel()
    
    var imageId = ""

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(posterImageView)
        addSubview(stackView)
        addSubview(ratingLabel)
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SearchFilmTableViewCell {
    
    private func makeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.backgroundColor = Asset.Colors.grayTransperent.color
        imageView.isUserInteractionEnabled = true
        return imageView
    }
    
    private func makeLabel(fontSize: CGFloat) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: fontSize)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.textColor = Asset.Colors.textColor.color
        label.text = ""
        return label
    }
    
    private func makeStackView(views: [UIView]) -> UIStackView {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .fillEqually
        view.spacing = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        for i in views {
            view.addArrangedSubview(i)
        }
        return view
    }
    
    private func makeRatingLabel() -> UILabel {
        let label = UILabel()
        label.layer.borderWidth = SearchScreenSizes.TableView.ratingBorderWidth
        label.layer.borderColor = Asset.Colors.deepBlue.color.cgColor
        label.layer.cornerRadius = SearchScreenSizes.TableView.ratingHeight * 0.5
        label.font = .systemFont(ofSize: SearchScreenSizes.TableView.fontSize)
        label.textColor = Asset.Colors.deepBlue.color
        label.textAlignment = .center
        label.text = ""
        label.numberOfLines = 1
        label.backgroundColor = Asset.Colors.primaryBackground.color
        label.clipsToBounds = true
        return label
    }
}

extension SearchFilmTableViewCell {
    
    private func setConstraints() {
        setPosterImageViewConstraints()
        setStackViewConstraints()
        setRatingLabelConstraints()
    }
    
    private func setPosterImageViewConstraints() {
        posterImageView.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview().inset(SearchScreenSizes.TableView.posterImageViewSideOffset)
            maker.leading.equalTo(layoutMarginsGuide).inset(SearchScreenSizes.TableView.posterImageViewSideOffset)
            maker.width.equalTo(SearchScreenSizes.TableView.posterImageViewWidth)
        }
    }
    
    private func setStackViewConstraints() {
        stackView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(SearchScreenSizes.TableView.stackViewOffset)
            maker.leading.equalTo(posterImageView.snp.trailing).offset(SearchScreenSizes.TableView.stackViewOffset)
            maker.height.equalTo(SearchScreenSizes.TableView.stackViewHeight)
            maker.trailing.equalTo(layoutMarginsGuide)
        }
    }
    
    private func setRatingLabelConstraints() {
        ratingLabel.snp.makeConstraints { maker in
            maker.top.equalTo(stackView.snp.bottom).offset(SearchScreenSizes.TableView.ratingTopOffset)
            maker.leading.equalTo(posterImageView.snp.trailing).offset(SearchScreenSizes.TableView.ratingLeftOffset)
            maker.width.equalTo(SearchScreenSizes.TableView.ratingWidth)
            maker.height.equalTo(SearchScreenSizes.TableView.ratingHeight)
        }
    }
}
