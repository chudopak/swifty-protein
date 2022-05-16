//
//  FavouriteInteractor.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol FavouriteInteractorProtocol {
    func fetchMovies(page: Int, size: Int, watched: Bool)
    func checkChanges(page: Int, size: Int, watched: Bool)
}

class FavouriteInteractor: FavouriteInteractorProtocol {
    
    private let presenter: FavouritePresenterProtocol
    private let networkService: FetchFilmsServiceProtocol
    private let coreDataService: CoreDataService
    
    init(presenter: FavouritePresenterProtocol,
         networkService: FetchFilmsServiceProtocol,
         coreDataService: CoreDataService) {
        self.presenter = presenter
        self.networkService = networkService
        self.coreDataService = coreDataService
    }
    
    // TODO: - replace it or delete (not using this right now)
    func checkChanges(page: Int,
                      size: Int,
                      watched: Bool) {
        networkService.fetchFilms(page: page, size: size, watched: watched) { [weak self] result in
            switch result {
            case .success(let films):
                let filmsMarked = self?.setWatchStatusToFetchedFilms(films: films, watched: watched)
                self?.presenter.compareMoviesWithCurrent(films: filmsMarked, watched: watched)
                
            case .failure(let error):
                print("Compare Movies error - \(error.localizedDescription)")
            }
        }
    }
    
    func fetchMovies(page: Int,
                     size: Int,
                     watched: Bool) {
        let filmsInfo = fetchNewPageFromCoreData(page: page,
                                                 size: size,
                                                 watched: watched)
        let filmsData = convertCoreDataFilmsStructToFilmData(films: filmsInfo)
        presenter.presentMovies(films: filmsData, watched: watched)
        networkService.fetchFilms(page: page, size: size, watched: watched) { [weak self] result in
            switch result {
            case .success(let films):
                let filmsMarked = self?.setWatchStatusToFetchedFilms(films: films, watched: watched)
                if !optionalsAreEqual(firstVal: filmsMarked, secondVal: filmsData) {
                    print("not equeal lLLALALAL")
                    self?.presenter.replaceLastPage(films: filmsMarked, watched: watched)
                    self?.actualiseFilmsInCoreData(filmsBack: filmsMarked, filmsLocal: filmsInfo)
                }
                
            case .failure(let error):
                print("Fetch Movies error - \(error.localizedDescription)")
            }
        }
    }
    
    private func fetchNewPageFromCoreData(page: Int, size: Int, watched: Bool) -> [FilmInfo] {
        let predicate = NSPredicate(
            format: "%K = \(watched)",
            #keyPath(FilmInfo.isWatched)
        )
        let sort = NSSortDescriptor(key: "id", ascending: true)
        let fetchData = GetModel(predicate: predicate,
                                 sortDescriptors: [sort],
                                 fetchLimit: size,
                                 fetchOffset: page * size)
        if let films = coreDataService.get(type: FilmInfo.self,
                                           fetchRequestData: fetchData) {
            return films
        }
        return [FilmInfo]()
    }
    
    private func convertCoreDataFilmsStructToFilmData(films: [FilmInfo]) -> [FilmData] {
        var filmsData = [FilmData]()
        filmsData.reserveCapacity(films.count)
        for film in films {
            let convertedFilm = FilmData(id: film.id,
                                         title: film.title,
                                         description: film.titleDescription,
                                         rating: Double(film.rating),
                                         posterId: film.posterID,
                                         genres: film.genres,
                                         isWatched: film.isWatched,
                                         timestamp: film.year)
            filmsData.append(convertedFilm)
        }
        return filmsData
    }
    
    private func setWatchStatusToFetchedFilms(films: [FilmData]?, watched: Bool) -> [FilmData]? {
        guard var films = films
        else {
            return nil
        }
        for i in 0..<films.count {
            films[i].isWatched = watched
        }
        return films
    }
    
    private func actualiseFilmsInCoreData(filmsBack: [FilmData]?, filmsLocal: [FilmInfo]) {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let back = filmsBack,
                  !back.isEmpty
            else {
                self?.coreDataService.deleteObjects(objects: filmsLocal) { [weak self] in
                    self?.coreDataService.saveContext()
                }
                return
            }
            self?.changeNotEqualFilmsInfo(back: back, filmsLocal: filmsLocal)
            self?.changeCoreDataObjectsAmount(back: back,
                                              filmsLocal: filmsLocal)
            self?.coreDataService.saveContext()
        }
    }
    
    private func changeNotEqualFilmsInfo(back: [FilmData], filmsLocal: [FilmInfo]) {
        let smallSize = back.count < filmsLocal.count ? back.count : filmsLocal.count
        for i in 0..<smallSize where !compareFilms(back: back[i], local: filmsLocal[i]) {
            setFilmInfo(film: filmsLocal[i], back: back[i])
        }
    }
    
    private func changeCoreDataObjectsAmount(back: [FilmData], filmsLocal: [FilmInfo]) {
        let smallSize = back.count < filmsLocal.count ? back.count : filmsLocal.count
        if smallSize < filmsLocal.count {
            let filmsForDeletion = Array(filmsLocal[smallSize..<filmsLocal.count])
            coreDataService.deleteObjects(objects: filmsForDeletion) {}
        } else {
            for i in smallSize..<back.count {
                coreDataService.save(
                    with: FilmInfo.self,
                    predicate: nil
                ) { [weak self, i] object, managedObjectContext in
                    self?.setFilmInfo(film: object, back: back[i])
                }
            }
        }
    }
    
    private func setFilmInfo(film: FilmInfo, back: FilmData) {
        film.id = back.id
        film.titleDescription = back.description ?? ""
        film.posterID = back.posterId
        film.rating = getPrefix(string: String(back.rating ?? 0), prefixValue: 3)
        film.year = getPrefix(string: back.timestamp ?? "1970", prefixValue: 4)
        film.genres = back.genres
        film.title = back.title
        film.isWatched = back.isWatched ?? false
    }
    
    private func compareFilms(back: FilmData, local: FilmInfo) -> Bool {
        let backYear = getPrefix(string: back.timestamp ?? "1970", prefixValue: 4)
        let backRating = getPrefix(string: String(back.rating ?? 0), prefixValue: 3)
        guard let backDescripiton = back.description,
              local.titleDescription == backDescripiton,
              optionalsAreEqual(firstVal: back.posterId, secondVal: local.posterID),
              optionalsAreEqual(firstVal: back.genres, secondVal: local.genres),
              backYear == local.year,
              backRating == local.rating
        else {
            return false
        }
        return true
    }
}
