//
//  ProfilePresenter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/23/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol ProfilePresenterProtocol {
    func sendInfoToView(userInfo: UserInfo)
    func showEditViewController()
}

final class ProfilePresenter: ProfilePresenterProtocol {

    private weak var viewController: ProfileViewController!
    
    init(viewController: ProfileViewController) {
        self.viewController = viewController
    }
    
    func sendInfoToView(userInfo: UserInfo) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController.showUserInfo(userInfo: userInfo)
        }
    }
    
    func showEditViewController() {
        DispatchQueue.main.async { [weak self] in
            self?.viewController.openEditScreen()
        }
    }
}
