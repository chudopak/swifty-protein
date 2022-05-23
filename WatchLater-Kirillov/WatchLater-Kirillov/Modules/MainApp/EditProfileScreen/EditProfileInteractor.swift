//
//  EditProfileInteractor.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/23/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol EditProfileInteractorProtocol {
    func saveAllChanges(userInfo: UserInfo)
    func saveChanges(userInfo: UserInfo)
    func savePicture(image: Data?)
}

final class EditProfileInteractor: EditProfileInteractorProtocol {

    private let presenter: EditProfilePresenterProtocol
    private let imageService: ProfileImageloadingProtocol
    
    init(presenter: EditProfilePresenterProtocol,
         imageService: ProfileImageloadingProtocol) {
        self.presenter = presenter
        self.imageService = imageService
    }
    
    func saveAllChanges(userInfo: UserInfo) {
        saveChanges(userInfo: userInfo)
        savePicture(image: userInfo.photoData)
    }
    
    func saveChanges(userInfo: UserInfo) {
        ProfileInfo.fetchUserInfo { [weak self] result in
            switch result {
            case .success(let usersInfo):
                print(usersInfo.count)
                if let localInfo = usersInfo.first {
                    self?.updateLocalInfo(localInfo: localInfo, newInfo: userInfo)
                } else {
                    self?.saveUserInfoTextInfo(userInfo: userInfo)
                }

            case .failure:
                print("Failed to fetch userInfo")
                self?.saveUserInfoTextInfo(userInfo: userInfo)
            }
            self?.presenter.successfulDataUpload(userInfo: userInfo)
        }
    }
    
    func savePicture(image: Data?) {
        ProfileInfo.fetchUserInfo { [weak self] result in
            switch result {
            case .success(let usersInfo):
                if let localInfo = usersInfo.first {
                    self?.updatePhoto(localInfo: localInfo, photoData: image)
                } else {
                }

            case .failure:
                print("Failed to fetch userInfo")
            }
        }
//        uploadImageToBackend(data: data)
    }
    
    private func uploadImageToBackend(data: Data) {
        imageService.uploadImage(data: data) { result in
            switch result {
            case .success(let id):
                print(id)

            case .failure(let error):
                print("EditProfileInteractor, savePicture - \(error)")
            }
        }
    }
    
    private func updateLocalInfo(localInfo: ProfileInfo, newInfo: UserInfo) {
        CoreDataService.shared.managedObjectContext.performAndWait {
            localInfo.aboutMe = newInfo.description
            localInfo.genres = newInfo.genres
            localInfo.name = newInfo.name
            CoreDataService.shared.saveContext()
        }
    }
    
    private func saveUserInfoTextInfo(userInfo: UserInfo) {
        CoreDataService.shared.save(with: ProfileInfo.self, predicate: nil) { object, context in
            object.aboutMe = userInfo.description
            object.genres = userInfo.genres
            object.name = userInfo.name
            object.id = Int64(userInfo.id)
            object.photoId = userInfo.photoId
            CoreDataService.shared.saveContext()
        }
    }
    
    private func updatePhoto(localInfo: ProfileInfo, photoData: Data?, photoId: String = "") {
        CoreDataService.shared.managedObjectContext.performAndWait {
            localInfo.photoId = photoId
            localInfo.photoData = photoData
            CoreDataService.shared.saveContext()
        }
    }
}
