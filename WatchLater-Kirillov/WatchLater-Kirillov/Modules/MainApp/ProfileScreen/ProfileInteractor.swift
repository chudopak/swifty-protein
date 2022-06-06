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
    private let imageService: ProfileImageloadingProtocol
    
    init(presenter: ProfilePresenterProtocol,
         imageService: ProfileImageloadingProtocol) {
        self.presenter = presenter
        self.imageService = imageService
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
                self?.fetchImage(profile: profile)
                
            case .failure(let error):
                // Here should be function that will fetch info from back but it doesn't work on API
                print("ProfileInteractor, fetchUserInfo - \(error)")
                self?.presenter.showEditViewController()
            }
        }
    }
    
    private func fetchImage(profile: ProfileInfo) {
        imageService.getProfilePhoto { result in
            switch result {
            case .success(let imageData):
                ProfileInfo.changeProfileInfo(info: profile) { [weak self] info in
                    if info.photoId != imageData.id
                        || info.photoData == nil {
                        info.photoId = imageData.id
                        info.photoData = imageData.image.jpegData(compressionQuality: 1)
                        self?.presenter.changeProfileImage(imageData: imageData)
                        ProfileInfo.saveProfileInfoChanges()
                    }
                }
            
            case .failure(let error):
                print("ProfileInteractor - \(error)")
            }
        }
    }
}
