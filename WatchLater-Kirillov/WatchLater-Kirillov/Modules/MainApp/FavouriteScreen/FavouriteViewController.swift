//
//  FavouriteViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/21/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class FavouriteViewController: BaseViewController {
    
    enum ViewStyle {
        case collectionView, tableView
    }
    
    private var activeViewStyle = ViewStyle.collectionView
    private lazy var searchBarButton = makeSearchBarButtonItem()
    private lazy var styleBarButton = makeStyleBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.primaryBackground.color
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = searchBarButton
        navigationItem.rightBarButtonItem = styleBarButton
        navigationItem.titleView = UIImageView(image: Asset.logoShort.image)
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
}
