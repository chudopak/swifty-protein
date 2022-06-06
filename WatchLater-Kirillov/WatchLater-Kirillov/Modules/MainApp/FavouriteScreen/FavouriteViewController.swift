//
//  FavouriteViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/21/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

protocol FavouriteViewControllerProtocol: AnyObject {
    func showFilms(_ films: [FilmData], watched: Bool)
    func replacePageWithBackendFilms(_ films: [FilmData], watched: Bool, startReplacePosition: Int)
    func appendOneFilm(_ film: FilmData, toList watched: Bool)
    func replaceFilm(_ film: FilmData, watched: Bool, at postion: Int)
    func notifyThatFilmListIsFull(watched: Bool, isFull: Bool)
}

protocol FavouriteViewControllerDelegate: AnyObject {
    
    var isPaginating: Bool { get }
    
    func fetchNewFilms()
    func presentDetailsScreen(films: FilmData)
}

protocol FilmInfoChangedInformerDelegate: AnyObject {
    func handleDeletedFilm(id: Int)
    func cangeFilmInfo(filmData: FilmData)
}

class FavouriteViewController: BaseViewController {

    enum ViewStyle {
        case collectionView, tableView
    }
    
    private var activeViewStyle = ViewStyle.collectionView

    private var viewedFilms = [FilmData]()
    private var willWatchFilms = [FilmData]()
    
    private lazy var searchBarButton = makeSearchBarButtonItem()
    private lazy var styleBarButton = makeStyleBarButtonItem()
    private lazy var segmentControl = makeSegmentControll()
    private lazy var filmsCollectionView = makeFilmsCollectionView()
    private lazy var filmsTableView = makeFilmsTableView()
    
    private var interactor: FavouriteInteractorProtocol!
    private var router: FavouriteRouter!
    
    private var isFetchingNewMovies = false
    private var isFirstLaunch = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationController()
        if isFirstLaunch {
            fetchFilmsForActiveSegment(watched: false)
            isFirstLaunch = false
        }
    }
    
    func setupComponents(interactor: FavouriteInteractorProtocol,
                         router: FavouriteRouter) {
        self.interactor = interactor
        self.router = router
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
    
    private func setFilmsToActiveView(films: [FilmData]) {
        filmsCollectionView.filmsInfo = films
        filmsTableView.filmsInfo = films
    }
    
    private func setFilmsToActiveSegment() {
        let watched = getWatched()
        if watched {
            setFilmsToActiveView(films: viewedFilms)
        } else {
            setFilmsToActiveView(films: willWatchFilms)
        }
    }
    
    private func shouldFetchFilms(watched: Bool) -> Bool {
        if watched {
            return viewedFilms.isEmpty
        } else {
            return willWatchFilms.isEmpty
        }
    }
    
    @objc private func searchFilm() {
        router.pushSearchViewController(to: navigationController!)
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
        setFilmsToActiveSegment()
    }
    
    @objc private func changeFilmsSegment() {
        if shouldFetchFilms(watched: getWatched()) {
            fetchNewFilms()
        } else {
            setFilmsToActiveSegment()
        }
    }
}

extension FavouriteViewController: FavouriteViewControllerProtocol {
    
    func showFilms(_ films: [FilmData], watched: Bool) {
        isFetchingNewMovies = false
        if watched {
            viewedFilms += films
            setFilmsToActiveView(films: viewedFilms)
        } else {
            willWatchFilms += films
            setFilmsToActiveView(films: willWatchFilms)
        }
    }
    
    func replacePageWithBackendFilms(_ films: [FilmData],
                                     watched: Bool,
                                     startReplacePosition: Int) {
        if watched {
            guard let range = getRange(startReplacePosition: startReplacePosition,
                                       updatedFilmsSize: films.count,
                                       oldFilmsSize: viewedFilms.count)
            else {
                return
            }
            viewedFilms.removeSubrange(range)
            viewedFilms += films
            setFilmsToActiveView(films: viewedFilms)
        } else {
            guard let range = getRange(startReplacePosition: startReplacePosition,
                                       updatedFilmsSize: films.count,
                                       oldFilmsSize: willWatchFilms.count)
            else {
                return
            }
            willWatchFilms.removeSubrange(range)
            willWatchFilms += films
            setFilmsToActiveView(films: willWatchFilms)
        }
    }
    
    func replaceFilm(_ film: FilmData, watched: Bool, at postion: Int) {
        print(postion)
        if watched {
            viewedFilms.remove(at: postion)
            viewedFilms.insert(film, at: postion)
        } else {
            willWatchFilms.remove(at: postion)
            willWatchFilms.insert(film, at: postion)
        }
    }
    
    func appendOneFilm(_ film: FilmData, toList watched: Bool) {
        if watched {
            viewedFilms.append(film)
        } else {
            willWatchFilms.append(film)
        }
    }
    
    func notifyThatFilmListIsFull(watched: Bool, isFull: Bool) {
        isFetchingNewMovies = false
    }
    
    private func getRange(startReplacePosition: Int,
                          updatedFilmsSize: Int,
                          oldFilmsSize: Int) -> Range<Int>? {
        if startReplacePosition > oldFilmsSize {
            return nil
        }
        let finish: Int
        if oldFilmsSize <= startReplacePosition + updatedFilmsSize {
            finish = oldFilmsSize
        } else {
            finish = startReplacePosition + updatedFilmsSize
        }
        return startReplacePosition..<finish
    }
}

extension FavouriteViewController: FavouriteViewControllerDelegate {
    
    var isPaginating: Bool {
        return isFetchingNewMovies
    }
    
    func fetchNewFilms() {
        fetchFilmsForActiveSegment(watched: getWatched())
    }
    
    func presentDetailsScreen(films: FilmData) {
        router.pushDetailsViewController(to: navigationController!,
                                         film: films,
                                         favouriteVCDelegate: self)
    }
    
    private func fetchFilmsForActiveSegment(watched: Bool) {
        isFetchingNewMovies = true
        interactor.fetchNewPage(watched: watched)
    }
}

extension FavouriteViewController: FilmInfoChangedInformerDelegate {
    
    func handleDeletedFilm(id: Int) {
    }
    
    func cangeFilmInfo(filmData: FilmData) {
        guard let result = findFilmInLists(id: filmData.id)
        else {
            return
        }
        if let isWatched = filmData.isWatched,
           (isWatched && result.isWatched) || (!isWatched && !result.isWatched) {
            if isWatched && viewedFilms[result.position].id == filmData.id {
                viewedFilms[result.position] = filmData
            } else if !isWatched && willWatchFilms[result.position].id == filmData.id {
                willWatchFilms[result.position] = filmData
            }
        } else if let isWatched = filmData.isWatched {
            replaceFilmInFilmLists(filmData: filmData,
                                   oldFilm: result,
                                   isWatchedNewVersion: isWatched)
        }
    }
    
    private func findFilmInLists(id: Int) -> (position: Int, isWatched: Bool)? {
        for i in 0..<willWatchFilms.count where willWatchFilms[i].id == id {
            return (position: i, isWatched: false)
        }
        for i in 0..<viewedFilms.count where viewedFilms[i].id == id {
            return (position: i, isWatched: true)
        }
        return nil
    }
    
    private func replaceFilmInFilmLists(filmData: FilmData,
                                        oldFilm: (position: Int, isWatched: Bool),
                                        isWatchedNewVersion: Bool) {
        eraseElement(at: oldFilm.position, isWatched: oldFilm.isWatched)
        fetchOneFilm(for: oldFilm.isWatched)
        if isWatchedNewVersion
            && addFilmToList(filmList: &viewedFilms,
                             filmData: filmData,
                             isFull: interactor.isViewedFillmFull)
            && !interactor.isViewedFillmFull {
            viewedFilms.removeLast()
        } else if !isWatchedNewVersion
                    && addFilmToList(filmList: &willWatchFilms,
                                     filmData: filmData,
                                     isFull: interactor.isWillWatchFillmFull)
                    && !interactor.isWillWatchFillmFull {
            willWatchFilms.removeLast()
        }
        setFilmsToActiveSegment()
    }
    
    private func eraseElement(at position: Int, isWatched: Bool) {
        if isWatched {
            viewedFilms.remove(at: position)
        } else {
            willWatchFilms.remove(at: position)
        }
    }
    
    private func fetchOneFilm(for isWatched: Bool) {
        interactor.fetchMoviesForFillingPage(watched: isWatched)
    }
    
    private func addFilmToList(filmList: inout [FilmData],
                               filmData: FilmData,
                               isFull: Bool) -> Bool {
        if isFull {
            insertFilm(filmList: &filmList, filmData: filmData)
            return true
        }
        if filmList.count == .zero {
            return false
        }
        var i = 0
        while i < filmList.count && filmData.id > filmList[i].id {
            i += 1
        }
        if i == filmList.count {
            return false
        }
        filmList.insert(filmData, at: i)
        return true
    }
    
    private func insertFilm(filmList: inout [FilmData],
                            filmData: FilmData) {
        var i = 0
        while i < filmList.count && filmData.id > filmList[i].id {
            i += 1
        }
        if i < filmList.count && filmData.id == filmList[i].id {
            filmList[i] = filmData
        } else {
            filmList.insert(filmData, at: i)
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
        controll.backgroundColor = Asset.Colors.grayTransperent.color
        controll.tintColor = .white
        controll.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 15),
                                         .foregroundColor: Asset.Colors.black.color],
                                        for: .normal)
        controll.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 15),
                                         .foregroundColor: Asset.Colors.black.color],
                                        for: .selected)
        if #available(iOS 13.0, *) {
            controll.selectedSegmentTintColor = .white
        }
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
