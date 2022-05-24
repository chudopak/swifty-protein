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
    }
    
    func saveChanges(userInfo: UserInfo) {
        ProfileInfo.fetchUserInfo { [weak self] result in
            switch result {
            case .success(let usersInfo):
                print(usersInfo.count)
                if let localInfo = usersInfo.first {
                    self?.updateLocalInfo(localInfo: localInfo, newInfo: userInfo) {
                        self?.presenter.successfulDataUpload(userInfo: userInfo)
                    }
                    self?.savePicture(image: userInfo.photoData)
                    self?.uploadImageToBackend(data: userInfo.photoData)
                } else {
                    self?.saveUserInfoTextInfo(userInfo: userInfo) {
                        self?.presenter.successfulDataUpload(userInfo: userInfo)
                    }
                    self?.uploadImageToBackend(data: userInfo.photoData)
                }

            case .failure:
                print("Failed to fetch userInfo")
                self?.saveUserInfoTextInfo(userInfo: userInfo) {
                    self?.presenter.successfulDataUpload(userInfo: userInfo)
                }
                self?.uploadImageToBackend(data: userInfo.photoData)
            }
        }
    }
    
    func savePicture(image: Data?) {
        ProfileInfo.fetchUserInfo { [weak self] result in
            switch result {
            case .success(let usersInfo):
                if let localInfo = usersInfo.first {
                    self?.updatePhoto(localInfo: localInfo, photoData: image)
                }

            case .failure:
                print("Failed to fetch userInfo")
            }
        }
    }
    
    private func uploadImageToBackend(data: Data?) {
        guard let unwrappedData = data
        else {
            return
        }
        imageService.uploadImage(data: unwrappedData) { [weak self] result in
            switch result {
            case .success(let id):
                self?.saveNewPhotoId(id: id)

            case .failure(let error):
                self?.saveNewPhotoId(id: "")
                print("EditProfileInteractor, savePicture - \(error)")
            }
        }
    }
    
    private func saveNewPhotoId(id: String) {
        ProfileInfo.fetchUserInfo { result in
            switch result {
            case .success(let usersInfo):
                if let localInfo = usersInfo.first {
                    CoreDataService.shared.managedObjectContext.performAndWait {
                        localInfo.photoId = id
                    }
                }

            case .failure:
                print("EditProfileInteractor, saveNewPhotoId - Failed to fetch userInfo")
            }
        }
    }
    
    private func updateLocalInfo(
        localInfo: ProfileInfo,
        newInfo: UserInfo,
        completion: @escaping () -> Void
    ) {
        CoreDataService.shared.managedObjectContext.performAndWait {
            localInfo.aboutMe = newInfo.description
            localInfo.genres = newInfo.genres
            localInfo.name = newInfo.name
            CoreDataService.shared.saveContext()
            completion()
        }
    }
    
    private func saveUserInfoTextInfo(userInfo: UserInfo, completion: @escaping () -> Void) {
        CoreDataService.shared.save(with: ProfileInfo.self, predicate: nil) { object, context in
            object.aboutMe = userInfo.description
            object.genres = userInfo.genres
            object.name = userInfo.name
            object.id = Int64(userInfo.id)
            object.photoId = userInfo.photoId
            CoreDataService.shared.saveContext()
            completion()
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
