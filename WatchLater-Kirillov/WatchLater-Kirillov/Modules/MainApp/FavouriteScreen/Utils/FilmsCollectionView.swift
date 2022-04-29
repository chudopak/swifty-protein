//
//  FilmsCollectionView.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/25/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

class FilmsCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var filmsCollectionView: UICollectionView!
    private var posterImageLoader: ImageDownloadingServiceProtocol!
    
    var filmsInfo = [FilmInfoTmp]() {
        didSet {
            filmsCollectionView.reloadData()
        }
    }
    
    init(collectionViewLayout: UICollectionViewFlowLayout,
         posterImageLoader: ImageDownloadingServiceProtocol) {
        super.init(frame: .zero)
        self.posterImageLoader = posterImageLoader
        filmsCollectionView = makeFilmsCollectionView(collectionViewLayout: collectionViewLayout)
        addSubview(filmsCollectionView)
        backgroundColor = .clear
        setCollectionViewConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filmsInfo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCollectionViewCell.identifier, for: indexPath) as! FilmCollectionViewCell
        cell.titleLabel.text = filmsInfo[indexPath.row].title
        cell.ratingLabel.text = getRatingString(rating: filmsInfo[indexPath.row].rating)
        cell.filmImageView.image = nil
        if let posterID = filmsInfo[indexPath.row].posterId,
           !posterID.isEmpty {
            cell.id = posterID
            posterImageLoader.download(id: posterID) { result in
                switch result {
                case .success(let imageData):
                    if cell.id == imageData.id {
                        DispatchQueue.main.async {
                            cell.filmImageView.image = imageData.image
                        }
                    }
                    
                case .failure(let error):
                    print("Poster Loading Failure for id \(posterID) - \(error.localizedDescription)")
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = bounds.width * FavouriteScreenSizes.FilmCollectionViewCell.ratioWithSuperViewWidth
        let height = width * FavouriteScreenSizes.FilmCollectionViewCell.ratioSelfWidthWithHeight
        return CGSize(width: width,
                      height: height)
    }
    
    private func getRatingString(rating: Double?) -> String {
        var str = String(rating ?? 0).prefix(3)
        if str.suffix(1) == "." {
            str.remove(at: str.index(before: str.endIndex))
        }
        return String(str)
    }
}

extension FilmsCollectionView {
    
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

extension FilmsCollectionView {

    private func setCollectionViewConstraints() {
        filmsCollectionView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
