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
    
    private var imageCache = NSCache<NSString, NSData>()
    private var imageCacheLock = NSLock()
    
    private let semaphore = DispatchSemaphore(value: 2)
    
    var searchArea = SearchArea.IMDB
    
    var moviesData = [MovieData]() {
        didSet {
            imageCache = NSCache<NSString, NSData>()
            resultTableView.reloadData()
        }
    }
    
    init(imageDownloadingService: ImageDownloadingServiceProtocol) {
        super.init(frame: .zero)
        self.imageDownloadingService = imageDownloadingService
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
    
    private func getRatingString(rating: String) -> String {
        var str = rating.prefix(3)
        if str.suffix(1) == "." {
            str.remove(at: str.index(before: str.endIndex))
        }
        return String(str)
    }
    
    private func configureIMDBCell(cell: SearchFilmTableViewCell,
                                   index: Int) {
        cell.posterImageView.image = nil
//        cell.imageId = ""
//        if let imageData = imageCache.object(forKey: moviesData[index].image as NSString),
//           let image = UIImage(data: imageData as Data) {
//            cell.posterImageView.image = image
//        } else {
//            cell.imageId = moviesData[index].image
//            DispatchQueue.global(qos: .userInteractive).async { [weak self] in
//                self?.semaphore.wait()
//                self?.imageDownloadingService.downloadJPEG(
//                    urlString: self?.moviesData[index].image ?? "") { [weak self] result in
//                    self?.handleImageDownloadResult(result: result, cell: cell)
//                }
//            }
//        }
        if let url = URL(string: moviesData[index].image) {
            cell.posterImageView.kf.setImage(with: url)
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
    
    private func configureLocalCell(cell: SearchFilmTableViewCell,
                                    index: Int) {
    }
    
    private func handleImageDownloadResult(result: Result<(id: String, image: UIImage), Error>,
                                           cell: SearchFilmTableViewCell) {
        switch result {
        case .success(let data):
            if cell.imageId == data.id {
                DispatchQueue.global(qos: .userInteractive).async { [weak self] in
                    let image = self?.compressAndCacheImage(data: data)
                    DispatchQueue.main.async {
                        cell.posterImageView.image = image
                    }
                }
            }

        case .failure:
            DispatchQueue.main.async {
                cell.posterImageView.image = Asset.noImage.image
            }
        }
        semaphore.signal()
    }
    
    private func compressAndCacheImage(data: (id: String, image: UIImage)) -> UIImage {
        guard let iamgeData = data.image.jpegData(compressionQuality: 0.2),
              let image = UIImage(data: iamgeData)
        else {
            return data.image
        }
        imageCacheLock.lock()
        imageCache.setObject(iamgeData as NSData, forKey: data.id as NSString)
        imageCacheLock.unlock()
        return image
    }
}

extension SearchedFilmsTableView {
    
    private func makeTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(SearchFilmTableViewCell.self, forCellReuseIdentifier: SearchFilmTableViewCell.identifier)
        tableView.backgroundColor = .clear
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
