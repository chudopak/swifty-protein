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
    func changeFilmWatchStatus(id: Int)
}

final class DetailsInteractor: DetailsInteractorProtocol {
    
    private let presenter: DetailsPresenterProtocol
    private let imageDownloadingService: ImageDownloadingServiceProtocol
    private let filmsService: FetchFilmsServiceProtocol
    
    init(presenter: DetailsPresenterProtocol,
         imageDownloadingService: ImageDownloadingServiceProtocol,
         filmsService: FetchFilmsServiceProtocol) {
        self.presenter = presenter
        self.imageDownloadingService = imageDownloadingService
        self.filmsService = filmsService
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
    
    func changeFilmWatchStatus(id: Int) {
        filmsService.changeFilmWatchStatus(id: id) { [weak self] result in
            switch result {
            case .success(let status):
                self?.presenter.sendFilmsWatchStatus(status: status)

            case .failure(let error):
                print("DetailsInteractor, changeFilmWatchStatus - ", error.localizedDescription)
                self?.presenter.sendFilmsWatchStatus(status: false)
            }
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
