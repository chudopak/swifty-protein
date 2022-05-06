//
//  SearchedFilmsTableView.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/4/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class SearchedFilmsTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var resultTableView = makeTableView()
    private var imageDownloadingService: ImageDownloadingServiceProtocol!
    private weak var delegate: SearchViewControllerDelegate!
    
    var searchArea = SearchArea.IMDB
    
    var moviesData = [MovieData]() {
        didSet {
            ImageCache.default.clearMemoryCache()
            resultTableView.reloadData()
        }
    }
    
    init(imageDownloadingService: ImageDownloadingServiceProtocol,
         delegate: SearchViewControllerDelegate) {
        super.init(frame: .zero)
        self.imageDownloadingService = imageDownloadingService
        self.delegate = delegate
        backgroundColor = .clear
        addSubview(resultTableView)
        setTableViewConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moviesData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchFilmTableViewCell.identifier, for: indexPath) as! SearchFilmTableViewCell
        switch searchArea {
        case .IMDB:
            configureIMDBCell(cell: cell, index: indexPath.row)
        
        case .local:
            configureLocalCell(cell: cell, index: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchScreenSizes.TableView.cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        ImageCache.default.clearMemoryCache()
        switch searchArea {
        case .IMDB:
            delegate.presentDetailsScreen(imdbData: moviesData[indexPath.row], localData: nil)
        
        case .local:
            delegate.presentDetailsScreen(imdbData: nil, localData: nil)
        }
    }
    
    private func configureIMDBCell(cell: SearchFilmTableViewCell,
                                   index: Int) {
        cell.posterImageView.image = nil
        if let url = URL(string: moviesData[index].image) {
            let prosessor = ResizingImageProcessor(
                referenceSize: CGSize(width: SearchScreenSizes.TableView.posterImageViewWidth,
                                      height: SearchScreenSizes.TableView.posterImageViewHeight))
            cell.posterImageView.kf.indicatorType = .activity
            cell.posterImageView.kf.setImage(with: url, options: [.processor(prosessor)])
        } else {
            cell.posterImageView.image = Asset.noImage.image
        }
        cell.yearLabel.text = moviesData[index].year ?? "unowned"
        cell.titleLabel.text = moviesData[index].title
        if let rating = moviesData[index].rating {
            cell.ratingLabel.text = getRatingString(rating: rating)
        } else {
            cell.ratingLabel.text = "0"
        }
    }
    
    // TODO: it will work with core data
    private func configureLocalCell(cell: SearchFilmTableViewCell,
                                    index: Int) {
    }
    
    private func getRatingString(rating: String) -> String {
        var str = rating.prefix(3)
        if str.suffix(1) == "." {
            str.remove(at: str.index(before: str.endIndex))
        }
        return String(str)
    }
}

extension SearchedFilmsTableView {
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchFilmTableViewCell.self, forCellReuseIdentifier: SearchFilmTableViewCell.identifier)
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }
}

extension SearchedFilmsTableView {

    private func setTableViewConstraints() {
        resultTableView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
