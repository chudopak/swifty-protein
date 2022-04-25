//
//  FilmsCollectionView.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/25/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

class FilmsView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var filmsCollectionView: UICollectionView!
    
    var filmsInfo = [FilmInfo]() {
        didSet {
            setNeedsLayout()
        }
    }
    
    init(collectionViewLayout: UICollectionViewFlowLayout) {
        super.init(frame: .zero)
        filmsCollectionView = makeFilmsCollectionView(collectionViewLayout: collectionViewLayout)
        addSubview(filmsCollectionView)
        setCollectionViewConstraints()
        backgroundColor = .clear
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: - Delete 7
        return filmsInfo.count + 7
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCollectionViewCell.identifier, for: indexPath) as! FilmCollectionViewCell
        cell.backgroundColor = .blue
        if !filmsInfo.isEmpty {
            cell.filmInfo = filmsInfo[0]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = bounds.width * FavouriteScreenSizes.FilmCollectionViewCell.ratioWithSuperViewWidth
        let height = width * FavouriteScreenSizes.FilmCollectionViewCell.ratioSelfWidthWithHeight
        return CGSize(width: width,
                      height: height)
    }
}

extension FilmsView {
    
    private func makeFilmsCollectionView(collectionViewLayout: UICollectionViewFlowLayout) -> UICollectionView {
        let collectionView = UICollectionView(frame: .zero,
                                              collectionViewLayout: collectionViewLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(FilmCollectionViewCell.self,
                                forCellWithReuseIdentifier: FilmCollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        return collectionView
    }
}

extension FilmsView {

    private func setCollectionViewConstraints() {
        filmsCollectionView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
