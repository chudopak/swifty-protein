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
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .clear
        addSubview(resultTableView)
        setTableViewConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SearchFilmTableViewCell.identifier, for: indexPath) as! SearchFilmTableViewCell
        cell.yearLabel.text = "2020"
        cell.titleLabel.text = "Title"
        cell.ratingLabel.text = "9.9"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return SearchScreenSizes.TableView.cellHeight
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
