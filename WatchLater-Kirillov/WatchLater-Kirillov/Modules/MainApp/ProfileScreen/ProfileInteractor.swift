//
//  ProfileInteractor.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/23/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol ProfileInteractorProtocol {
    func fetchUserInfo()
}

final class ProfileInteractor: ProfileInteractorProtocol {
    
    private let presenter: ProfilePresenterProtocol
    
    init(presenter: ProfilePresenterProtocol) {
        self.presenter = presenter
    }
    
    func fetchUserInfo() {
        ProfileInfo.fetchUserInfo { [weak self] result in
            switch result {
            case .success(let profiles):
                print(profiles.count)
                guard let profile = profiles.first
                else {
                    self?.presenter.showEditViewController()
                    return
                }
                self?.presenter.sendInfoToView(userInfo: UserInfo(pofileCoreDataInfo: profile))
                
            case .failure(let error):
                print("ProfileInteractor, fetchUserInfo - \(error)")
            }
        }
    }
}
