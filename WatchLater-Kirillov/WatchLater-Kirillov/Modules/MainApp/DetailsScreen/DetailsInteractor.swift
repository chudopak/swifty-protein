//
//  DetailsInteractor.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/6/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol DetailsInteractorProtocol {
}

final class DetailsInteractor: DetailsInteractorProtocol {
    
    private let presenter: DetailsPresenterProtocol
    private let imageDownloadingService: ImageDownloadingServiceProtocol
    
    init(presenter: DetailsPresenterProtocol,
         imageDownloadingService: ImageDownloadingServiceProtocol) {
        self.presenter = presenter
        self.imageDownloadingService = imageDownloadingService
    }
}
