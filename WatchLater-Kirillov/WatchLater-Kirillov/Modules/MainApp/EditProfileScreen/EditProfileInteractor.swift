//
//  EditProfileInteractor.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/23/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol EditProfileInteractorProtocol {
}

final class EditProfileInteractor: EditProfileInteractorProtocol {

    private let presenter: EditProfilePresenterProtocol
    private let imageDownloadingService: ImageDownloadingServiceProtocol
    
    init(presenter: EditProfilePresenterProtocol,
         imageDownloadingService: ImageDownloadingServiceProtocol) {
        self.presenter = presenter
        self.imageDownloadingService = imageDownloadingService
    }
}
