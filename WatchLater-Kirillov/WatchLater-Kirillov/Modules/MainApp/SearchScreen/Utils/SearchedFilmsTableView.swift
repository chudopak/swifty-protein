//
//  SearchedFilmsTableView.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/4/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

class SearchedFilmsTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var resultTableView = makeTableView()
    private var imageDownloadingService: ImageDownloadingServiceProtocol!
    
    var moviesData = [MovieData]() {
        didSet {
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
        cell.yearLabel.text = moviesData[indexPath.row].year ?? "unowned"
        cell.titleLabel.text = moviesData[indexPath.row].title
        if let rating = moviesData[indexPath.row].rating {
            cell.ratingLabel.text = getRatingString(rating: rating)
        } else {
            cell.ratingLabel.text = "0"
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
