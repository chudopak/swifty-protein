//
//  FavouriteViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/21/pageSize.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

protocol FavouriteViewControllerProtocol: AnyObject {
    func showFilms(_ films: [FilmInfoTmp]?)
}

class FavouriteViewController: BaseViewController, FavouriteViewControllerProtocol {
    
    enum ViewStyle {
        case collectionView, tableView
    }
    
    private var activeViewStyle = ViewStyle.collectionView
    
    private let pageSize = 21
    
    private lazy var searchBarButton = makeSearchBarButtonItem()
    private lazy var styleBarButton = makeStyleBarButtonItem()
    private lazy var segmentControl = makeSegmentControll()
    private lazy var filmsCollectionView = makeFilmsCollectionView()
    private lazy var filmsTableView = makeFilmsTableView()
    
    private var interactor: FavouriteInteractorProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor.fetchMovies(page: 1, size: pageSize, watched: false)
        // TODO: - show loading indicator (i think)
        filmsCollectionView.filmsInfo = [FilmInfoTmp]()
        filmsTableView.filmsInfo = [FilmInfoTmp]()
    }
    
    func setupComponents(interactor: FavouriteInteractorProtocol) {
        self.interactor = interactor
    }
    
    func showFilms(_ films: [FilmInfoTmp]?) {
        setFilmsToActiveView(films: films ?? [FilmInfoTmp]())
    }
    
    private func setView() {
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = searchBarButton
        navigationItem.rightBarButtonItem = styleBarButton
        navigationItem.titleView = UIImageView(image: Asset.logoShort.image)
        view.backgroundColor = Asset.Colors.primaryBackground.color
        view.addSubview(segmentControl)
        view.addSubview(filmsCollectionView)
        view.addSubview(filmsTableView)
        filmsTableView.isHidden = true
    }
    
    private func getWatched() -> Bool {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return false
            
        case 1:
            return true
            
        default:
            return false
        }
    }
    
    private func setFilmsToActiveView(films: [FilmInfoTmp]) {
        if !filmsCollectionView.isHidden {
            filmsCollectionView.filmsInfo = films
        } else {
            filmsTableView.filmsInfo = films
        }
    }
    
    // TODO: searchFilm
    @objc private func searchFilm() {
        print("hello")
    }
    
    @objc private func changeViewStyle() {
        let button = styleBarButton.customView as! ViewStyleButton
        switch activeViewStyle {
        case .collectionView:
            activeViewStyle = .tableView
            button.style = .collectionView(Asset.collectionViewImage.image)
            filmsTableView.isHidden = false
            filmsCollectionView.isHidden = true
            
        case .tableView:
            activeViewStyle = .collectionView
            button.style = .tableVeiw(Asset.tabelViewImage.image)
            filmsTableView.isHidden = true
            filmsCollectionView.isHidden = false
        }
        interactor.fetchMovies(page: 1, size: pageSize, watched: getWatched())
    }
    
    @objc private func changeFilmsSegment(_ sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
        case 0:
            interactor.fetchMovies(page: 1, size: pageSize, watched: false)
            
        case 1:
            interactor.fetchMovies(page: 1, size: pageSize, watched: true)
            
        default:
            break
        }
    }
}

extension FavouriteViewController {
    
    private func makeSearchBarButtonItem() -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(Asset.searchIcon.image, for: .normal)
        button.addTarget(self, action: #selector(searchFilm), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    private func makeStyleBarButtonItem() -> UIBarButtonItem {
        
        let button: ViewStyleButton
        switch activeViewStyle {
        case .collectionView:
            button = ViewStyleButton(style: .tableVeiw(Asset.tabelViewImage.image))
            
        case .tableView:
            button = ViewStyleButton(style: .collectionView(Asset.collectionViewImage.image))
        }
        button.addTarget(self, action: #selector(changeViewStyle), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    private func makeSegmentControll() -> UISegmentedControl {
        let controll = UISegmentedControl(items: [Text.Common.willWatch, Text.Common.viewed])
        controll.selectedSegmentIndex = 0
        controll.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 15)],
                                        for: .normal)
        controll.addTarget(self, action: #selector(changeFilmsSegment), for: .valueChanged)
        return controll
    }
    
    private func makeFilmsCollectionView() -> FilmsCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = FilmsCollectionView(collectionViewLayout: layout)
        return view
    }
    
    private func makeFilmsTableView() -> FilmsTableView {
        let view = FilmsTableView()
        return view
    }
}

extension FavouriteViewController {
    
    private func setConstraints() {
        setSegmentControlConstratints()
        setFilmsCollectionViewConstraints()
        setFilmsTableViewConstraints()
    }
    
    private func setSegmentControlConstratints() {
        segmentControl.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(view.layoutMarginsGuide)
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(FavouriteScreenSizes.SegmentControl.topOffset)
            maker.height.equalTo(FavouriteScreenSizes.SegmentControl.height)
        }
    }
    
    private func setFilmsCollectionViewConstraints() {
        filmsCollectionView.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(view.layoutMarginsGuide)
            maker.top.equalTo(segmentControl.snp.bottom).offset(FavouriteScreenSizes.FilmsView.topOffset)
            maker.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func setFilmsTableViewConstraints() {
        filmsTableView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(segmentControl.snp.bottom).offset(FavouriteScreenSizes.FilmsView.topOffset)
            maker.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
