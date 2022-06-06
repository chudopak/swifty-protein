//
//  EditProfilePresenter.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/23/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol EditProfilePresenterProtocol {
    func successfulDataUpload(userInfo: UserInfo?)
}

final class EditProfilePresenter: EditProfilePresenterProtocol {

    private weak var viewController: EditProfileViewControllerProtocol!
    
    init(viewController: EditProfileViewControllerProtocol) {
        self.viewController = viewController
    }
    
    func successfulDataUpload(userInfo: UserInfo?) {
        DispatchQueue.main.async { [weak self] in
            self?.viewController.successfulUploadData(info: userInfo)
        }
    }
}
