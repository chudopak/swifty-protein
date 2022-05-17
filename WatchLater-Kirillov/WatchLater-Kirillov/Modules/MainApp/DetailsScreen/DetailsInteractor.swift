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
        let isChanged = changeObjectInCoreData(id: id)
        presenter.sendFilmsWatchStatus(status: isChanged)
        filmsService.changeFilmWatchStatus(id: id) { [weak self, isChanged] result in
            switch result {
            case .failure(let error):
                print("DetailsInteractor, changeFilmWatchStatus - ", error.localizedDescription)
                self?.presenter.sendFailedToChangeStatusInBackend(isLocalChanged: isChanged)
            
            default:
                break
            }
        }
    }
    
    private func changeObjectInCoreData(id: Int) -> Bool {
        let predicate = NSPredicate(
            format: "%K = \(id)",
            #keyPath(FilmInfo.id)
        )
        let fetchData = GetModel(
            predicate: predicate,
            sortDescriptors: [],
            fetchLimit: 1,
            fetchOffset: .zero
        )
        guard let objects = CoreDataService.shared.get(type: FilmInfo.self,
                                                       fetchRequestData: fetchData),
              let object = objects.first
        else {
            return false
        }
        object.isWatched = !object.isWatched
        CoreDataService.shared.saveContext()
        return true
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
