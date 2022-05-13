//
//  FilmsTableView.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

class FilmsTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    
    private lazy var filmsTableView = makeFilmsTableView()
    
    private weak var delegate: FavouriteViewControllerDelegate!
    
    var filmsInfo = [FilmInfoTmp]() {
        didSet {
            filmsTableView.reloadData()
        }
    }

    init(delegate: FavouriteViewControllerDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        backgroundColor = .clear
        addSubview(filmsTableView)
        setTableViewConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filmsInfo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmsTableViewCell.identifier, for: indexPath) as! FilmsTableViewCell
        cell.titleLabel.text = filmsInfo[indexPath.row].title
        if indexPath.row + 10 > filmsInfo.count
            && !delegate.isPaginating {
            delegate.fetchNewFilms()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate.presentDetailsScreen(films: filmsInfo[indexPath.row])
    }
}

extension FilmsTableView {
    
    private func makeFilmsTableView() -> UITableView {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(FilmsTableViewCell.self, forCellReuseIdentifier: FilmsTableViewCell.identifier)
        tableView.backgroundColor = .clear
        return tableView
    }
}

extension FilmsTableView {

    private func setTableViewConstraints() {
        filmsTableView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
}
