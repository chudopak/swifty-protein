//
//  FavouriteViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/21/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

class FavouriteViewController: BaseViewController {
    
    enum ViewStyle {
        case collectionView, tableView
    }
    
    private var activeViewStyle = ViewStyle.collectionView

    private lazy var searchBarButton = makeSearchBarButtonItem()
    private lazy var styleBarButton = makeStyleBarButtonItem()
    private lazy var segmentControl = makeSegmentControll()
    private lazy var filmsView = makeFilmsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
    }
    
    private func setView() {
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = searchBarButton
        navigationItem.rightBarButtonItem = styleBarButton
        navigationItem.titleView = UIImageView(image: Asset.logoShort.image)
        view.backgroundColor = Asset.Colors.primaryBackground.color
        view.addSubview(segmentControl)
        view.addSubview(filmsView)
        filmsView.filmsInfo = [FilmInfo(id: "tt4682562",
                                        resultType: "Title",
                                        image: "https://imdb-api.com/images/original/MV5BZTA0NDM0ZWMtZDI0Zi00OWI5LWJlOTYtZTk5ZjAzYzIyNjQ3XkEyXkFqcGdeQXVyNDE2NjE1Njc@._V1_Ratio0.7273_AL_.jpg",
                                        title: "Office",
                                        description: "(2015)")]
    }
    
    @objc private func searchFilm() {
        print("hello")
    }
    
    @objc private func changeViewStyle() {
        let button = styleBarButton.customView as! ViewStyleButton
        switch activeViewStyle {
        case .collectionView:
            activeViewStyle = .tableView
            button.style = .tableVeiw(Asset.tabelViewImage.image)

        case .tableView:
            activeViewStyle = .collectionView
            button.style = .collectionView(Asset.collectionViewImage.image)
        }
    }
    
    @objc private func changeFilmsSegment(_ sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("Uno dos")
        
        case 1:
            print("tress quadro")
        
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
            button = ViewStyleButton(style: .collectionView(Asset.collectionViewImage.image))

        case .tableView:
            button = ViewStyleButton(style: .tableVeiw(Asset.tabelViewImage.image))
        }
        button.addTarget(self, action: #selector(changeViewStyle), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    private func makeSegmentControll() -> UISegmentedControl {
        let controll = UISegmentedControl(items: [Text.Common.willWatch, Text.Common.viewed])
        controll.selectedSegmentIndex = 1
        controll.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 15)],
                                        for: .normal)
        controll.addTarget(self, action: #selector(changeFilmsSegment), for: .valueChanged)
        return controll
    }
    
    private func makeFilmsView() -> FilmsView {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = FilmsView(collectionViewLayout: layout)
        return view
    }
}

extension FavouriteViewController {
    
    private func setConstraints() {
        setSegmentControlConstratints()
        setFilmsViewConstraints()
    }
    
    private func setSegmentControlConstratints() {
        segmentControl.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(FavouriteScreenSizes.SegmentControl.topOffset)
            maker.width.equalToSuperview().multipliedBy(FavouriteScreenSizes.SegmentControl.ratioWithSuperViewWidth)
            maker.height.equalTo(FavouriteScreenSizes.SegmentControl.height)
        }
    }
    
    private func setFilmsViewConstraints() {
        filmsView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(segmentControl.snp.bottom).offset(FavouriteScreenSizes.FilmsView.topOffset)
            maker.bottom.equalTo(view.safeAreaLayoutGuide)
            maker.width.equalToSuperview().multipliedBy(FavouriteScreenSizes.FilmsView.ratioWithSuperViewWidth)
        }
    }
}
