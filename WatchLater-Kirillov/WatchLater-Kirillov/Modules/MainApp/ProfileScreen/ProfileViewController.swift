//
//  ProfileViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    private var router: ProfileRouter!
    private lazy var editProfileScreenButton = makeEditProfileScreenButtonItem()
    
    private var isFirstLaunch: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        FirstLaunchChecker.isFirstProfileLaunch = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationController()
        if FirstLaunchChecker.isFirstProfileLaunch {
            router.presentEditProfileScreen(navigationController: navigationController!)
            FirstLaunchChecker.isFirstProfileLaunch = false
        }
    }
    
    func setupComponents(router: ProfileRouter) {
        self.router = router
    }
    
    private func setView() {
        view.backgroundColor = Asset.Colors.primaryBackground.color
    }
    
    private func setNavigationController() {
        navigationItem.rightBarButtonItem = editProfileScreenButton
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = UIImageView(image: Asset.logoShort.image)
    }
    
    @objc private func presentEditProfileScreen() {
        router.presentEditProfileScreen(navigationController: navigationController!)
    }
}

extension ProfileViewController {
    
    private func makeEditProfileScreenButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(Asset.editFilmInfo.image, for: .normal)
        button.addTarget(self, action: #selector(presentEditProfileScreen), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
}
