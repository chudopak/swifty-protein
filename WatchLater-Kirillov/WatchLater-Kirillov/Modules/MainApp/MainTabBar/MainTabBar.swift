//
//  MainTabBar.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/22/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class MainTabBar: UITabBarController {

    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewControllers()
    }
    
    private func setUpViewControllers() {
        let favouriteVC = FavouriteConfigurator().setupModule()
        let favouriteNavigatonController = UINavigationController(rootViewController: favouriteVC)
        
        let profileVC = ProfileConfigurator().setupModule()
        let profileNavigationController = UINavigationController(rootViewController: profileVC)
        favouriteVC.title = NSLocalizedString(Text.TabBar.collection, comment: "")
        profileVC.title = NSLocalizedString(Text.TabBar.profile, comment: "")
        
        setViewControllers([favouriteNavigatonController, profileNavigationController], animated: true)
        guard let items = tabBar.items
        else {
            fatalError("Failed to get tabBar items")
        }
        items[0].image = Asset.collectionInactive.image
        items[0].selectedImage = Asset.collectionActive.image
        items[1].image = Asset.profileImage.image
        items[1].selectedImage = Asset.profileImage.image
    }
}
