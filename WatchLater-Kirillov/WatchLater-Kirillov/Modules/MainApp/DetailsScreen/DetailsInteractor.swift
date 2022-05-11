//
//  DetailsInteractor.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/6/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol DetailsInteractorProtocol {
    func loadPosterWithURL(urlString: String)
    func loadPosterWithID(id: String)
}

final class DetailsInteractor: DetailsInteractorProtocol {
    
    private let presenter: DetailsPresenterProtocol
    private let imageDownloadingService: ImageDownloadingServiceProtocol
    
    init(presenter: DetailsPresenterProtocol,
         imageDownloadingService: ImageDownloadingServiceProtocol) {
        self.presenter = presenter
        self.imageDownloadingService = imageDownloadingService
    }
    
    func loadPosterWithURL(urlString: String) {
        imageDownloadingService.downloadJPEG(urlString: urlString) { [weak self] result in
            self?.handleResult(result: result)
        }
    }
    
    func loadPosterWithID(id: String) {
        imageDownloadingService.downloadData(id: id) { [weak self] result in
            self?.handleResult(result: result)
        }
    }
    
    private func handleResult(result: Result<(id: String, image: UIImage), Error>) {
        switch result {
        case .success(let data):
            presenter.sendPosterToView(result: .success(data.image))
        
        case .failure(let error):
            print(error.localizedDescription)
            presenter.sendPosterToView(result: .failure(error))
        }
    }
}
