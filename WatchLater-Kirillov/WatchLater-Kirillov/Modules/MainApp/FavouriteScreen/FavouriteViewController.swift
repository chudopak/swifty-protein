//
//  FavouriteViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/21/pageSize.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

struct FilmsPaging {
    var currentPage: Int
    var isFull: Bool
}

protocol FavouriteViewControllerProtocol: AnyObject {
    func showFilms(_ films: [FilmInfoTmp]?, watched: Bool)
}

protocol FavouriteViewControllerDelegate: AnyObject {
    func fetchNewFilms()
}

class FavouriteViewController: BaseViewController, FavouriteViewControllerProtocol, FavouriteViewControllerDelegate {

    enum ViewStyle {
        case collectionView, tableView
    }
    
    private var activeViewStyle = ViewStyle.collectionView
    
    private let pageSize = 24
    private var viewedFilmsInfo = FilmsPaging(currentPage: -1, isFull: false)
    private var willWatchFilmsInfo = FilmsPaging(currentPage: -1, isFull: false)
    
    private var viewedFilms = [FilmInfoTmp]()
    private var willWatchFilms = [FilmInfoTmp]()
    
    private lazy var searchBarButton = makeSearchBarButtonItem()
    private lazy var styleBarButton = makeStyleBarButtonItem()
    private lazy var segmentControl = makeSegmentControll()
    private lazy var filmsCollectionView = makeFilmsCollectionView()
    private lazy var filmsTableView = makeFilmsTableView()
    
    private var interactor: FavouriteInteractorProtocol!
    private var router: FavouriteRouter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationController()
        fetchNewFilms()
    }
    
    func setupComponents(interactor: FavouriteInteractorProtocol,
                         router: FavouriteRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    func showFilms(_ films: [FilmInfoTmp]?, watched: Bool) {
        guard let films = films
        else {
            return
        }
        if watched {
            if films.count < pageSize {
                viewedFilmsInfo.isFull = true
            }
            viewedFilms += films
            setFilmsToActiveView(films: viewedFilms)
        } else {
            if films.count < pageSize {
                willWatchFilmsInfo.isFull = true
            }
            willWatchFilms += films
            setFilmsToActiveView(films: willWatchFilms)
        }
    }
    
    func fetchNewFilms() {
        let watched = getWatched()
        if watched && !viewedFilmsInfo.isFull {
            viewedFilmsInfo.currentPage += 1
            interactor.fetchMovies(page: viewedFilmsInfo.currentPage, size: pageSize, watched: watched)
        } else if !watched && !willWatchFilmsInfo.isFull {
            willWatchFilmsInfo.currentPage += 1
            interactor.fetchMovies(page: willWatchFilmsInfo.currentPage, size: pageSize, watched: watched)
        }
    }
    
    private func setView() {
        view.backgroundColor = Asset.Colors.primaryBackground.color
        view.addSubview(segmentControl)
        view.addSubview(filmsCollectionView)
        view.addSubview(filmsTableView)
        filmsTableView.isHidden = true
    }
    
    private func setNavigationController() {
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = searchBarButton
        navigationItem.rightBarButtonItem = styleBarButton
        navigationItem.titleView = UIImageView(image: Asset.logoShort.image)
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
        filmsCollectionView.filmsInfo = films
        filmsTableView.filmsInfo = films
    }
    
    private func shouldFetchFilmsStyleChanged() -> Bool {
        let watched = getWatched()
        if watched && viewedFilmsInfo.currentPage == -1 {
            return true
        } else if !watched && willWatchFilmsInfo.currentPage == -1 {
            return true
        }
        return false
    }
    
    private func setFilmsWithoutFetching() {
        let watched = getWatched()
        if watched {
            setFilmsToActiveView(films: viewedFilms)
        } else {
            setFilmsToActiveView(films: willWatchFilms)
        }
    }
    
    // TODO: searchFilm
    @objc private func searchFilm() {
        navigationController?.pushViewController(SearchScreenConfigurator().setupModule(), animated: true)
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
        if shouldFetchFilmsStyleChanged() {
            fetchNewFilms()
        } else {
            setFilmsWithoutFetching()
        }
    }
    
    @objc private func changeFilmsSegment(_ sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
        case 0:
            if shouldFetchFilmsStyleChanged() {
                fetchNewFilms()
            } else {
                setFilmsWithoutFetching()
            }
            
        case 1:
            if shouldFetchFilmsStyleChanged() {
                fetchNewFilms()
            } else {
                setFilmsWithoutFetching()
            }
            
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
        let networkLayer = NetworkLayer(refreshService: RefreshTokenService())
        let view = FilmsCollectionView(collectionViewLayout: layout,
                                       posterImageLoader: ImageDownloadingService(networkManager: networkLayer),
                                       delegate: self)
        return view
    }
    
    private func makeFilmsTableView() -> FilmsTableView {
        let view = FilmsTableView(delegate: self)
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
