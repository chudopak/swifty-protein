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
}

class FavouriteViewController: BaseViewController, FavouriteViewControllerProtocol {
    
    enum ViewStyle {
        case collectionView, tableView
    }
    
    private var activeViewStyle = ViewStyle.collectionView

    private lazy var searchBarButton = makeSearchBarButtonItem()
    private lazy var styleBarButton = makeStyleBarButtonItem()
    private lazy var segmentControl = makeSegmentControll()
    private lazy var filmsCollectionView = makeFilmsCollectionView()
    private lazy var filmsTableView = makeFilmsTableView()
    
    private var interactor: FavouriteInteractorProtocol!

    private var filmsWillWatch = [FilmInfo(id: "tt4682562",
                                           resultType: "Title",
                                           image: "https://imdb-api.com/images/original/MV5BZTA0NDM0ZWMtZDI0Zi00OWI5LWJlOTYtZTk5ZjAzYzIyNjQ3XkEyXkFqcGdeQXVyNDE2NjE1Njc@._V1_Ratio0.7273_AL_.jpg",
                                           title: "Office",
                                           description: "(2015)"),
                                  FilmInfo(id: "tt9288848",
                                           resultType: "Title",
                                           image: "https://imdb-api.com/images/original/MV5BYThkYTFiYTUtNTY0NS00Y2Y0LTk3ZmItMzZjMjZjZWE3NDRiXkEyXkFqcGdeQXVyMjQ3MjU3NTU@._V1_Ratio0.7273_AL_.jpg",
                                           title: "Pacific Rim: The Black",
                                           description: "(2015)")
        ]
    private var filmsViewd = [FilmInfo(id: "tt11859542",
                                       resultType: "Title",
                                       image: "https://imdb-api.com/images/original/MV5BZWNiYjllNjgtY2VlOC00NDM4LTk4YzQtNGU1Zjk4NDUzN2Q4XkEyXkFqcGdeQXVyMTA2ODkwNzM5._V1_Ratio0.7273_AL_.jpg",
                                       title: "In from the Cold",
                                       description: "(2015)"),
                              FilmInfo(id: "tt3921180",
                                       resultType: "Title",
                                       image: "https://imdb-api.com/images/original/MV5BNjVmY2M3ZTUtMDhkZC00ODk4LTkwMjktNDRjNGRjYTIxZGZiXkEyXkFqcGdeQXVyNjEwNTM2Mzc@._V1_Ratio0.7273_AL_.jpg",
                                       title: "Scream: The TV Series",
                                       description: "(2015)")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
    }
    
    func setupComponents(interactor: FavouriteInteractorProtocol) {
        self.interactor = interactor
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
        // TODO: - Put films from core data in films info
        filmsCollectionView.filmsInfo = filmsWillWatch
        filmsTableView.filmsInfo = filmsWillWatch
    }
    
    private func setActiveFilms(for view: FilmsCollectionView) {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            view.filmsInfo = filmsWillWatch

        case 1:
            view.filmsInfo = filmsViewd
        
        default:
            break
        }
    }
    
    private func getActiveFilms() -> [FilmInfo] {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return filmsWillWatch

        case 1:
            return filmsViewd
        
        default:
            return [FilmInfo]()
        }
    }
    
    private func setFilmsToActiveView(films: [FilmInfo]) {
        if !filmsCollectionView.isHidden {
            filmsCollectionView.filmsInfo = films
        } else {
            filmsTableView.filmsInfo = films
        }
    }

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
            filmsTableView.filmsInfo = getActiveFilms()

        case .tableView:
            activeViewStyle = .collectionView
            button.style = .tableVeiw(Asset.tabelViewImage.image)
            filmsTableView.isHidden = true
            filmsCollectionView.isHidden = false
            filmsCollectionView.filmsInfo = getActiveFilms()
        }
    }
    
    @objc private func changeFilmsSegment(_ sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
        case 0:
            setFilmsToActiveView(films: filmsWillWatch)
        
        case 1:
            setFilmsToActiveView(films: filmsViewd)
        
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
