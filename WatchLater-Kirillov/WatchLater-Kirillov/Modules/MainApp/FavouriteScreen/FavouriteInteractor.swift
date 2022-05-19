//
//  FavouriteInteractor.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/26/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol FavouriteInteractorProtocol {
    var isViewedFillmFull: Bool { get }
    var isWillWatchFillmFull: Bool { get }
    
    func fetchNewPage(watched: Bool)
    func fetchMoviesForFillingPage(watched: Bool)
}

class FavouriteInteractor: FavouriteInteractorProtocol {
    
    var isViewedFillmFull: Bool {
        return viewedFilmsInfo.isFull
    }
    
    var isWillWatchFillmFull: Bool {
        return willWatchFilmsInfo.isFull
    }
    
    private let presenter: FavouritePresenterProtocol
    private let networkService: FetchFilmsServiceProtocol
    
    private let pageSize = 24
    private var viewedFilmsInfo = FilmsPaging(currentPage: -1,
                                              isFull: false)
    private var willWatchFilmsInfo = FilmsPaging(currentPage: -1,
                                                 isFull: false)
    
    init(presenter: FavouritePresenterProtocol,
         networkService: FetchFilmsServiceProtocol) {
        self.presenter = presenter
        self.networkService = networkService
    }

    func fetchMoviesForFillingPage(watched: Bool) {
        if isMovieSegmentFull(watched: watched) {
            presenter.notifyThatFilmsListIsFull(watched: watched, isFull: true)
            return
        }
        let page = getPageForOneFilm(watched: watched)
        FilmInfo.fetchPageFromCoreData(
            page: page,
            size: 1,
            watched: watched
        ) { [weak self] result in
            switch result {
            case .success(let filmsInfo):
                self?.handleResultOfFetchingOneFilmFromCoreData(
                    filmsInfo: filmsInfo,
                    page: page,
                    size: 1,
                    watched: watched
                )

            case .failure(let error):
                print("FavouriteInteractor, fetchNewPage - \(error)")
                self?.handleResultOfFetchingOneFilmFromCoreData(
                    filmsInfo: [FilmInfo](),
                    page: page,
                    size: 1,
                    watched: watched
                )
            }
        }
    }
    
    func fetchNewPage(watched: Bool) {
        // NSManageObjectContext нельзя использовать сраазуже в нескольких потоках, это не безопасно
        if isMovieSegmentFull(watched: watched) {
            presenter.notifyThatFilmsListIsFull(watched: watched, isFull: true)
            return
        }
        let page = getPageForMovieSegment(watched: watched)
        let size = pageSize
        FilmInfo.fetchPageFromCoreData(
            page: page,
            size: size,
            watched: watched
        ) { [weak self] result in
            switch result {
            case .success(let filmsInfo):
                self?.handleFilmsData(
                    filmsInfo: filmsInfo,
                    page: page,
                    size: size,
                    watched: watched
                )

            case .failure(let error):
                print("FavouriteInteractor, fetchNewPage - \(error)")
                self?.handleFilmsData(
                    filmsInfo: [FilmInfo](),
                    page: page,
                    size: size,
                    watched: watched
                )
            }
        }
    }
    
    private func handleFilmsData(filmsInfo: [FilmInfo],
                                 page: Int,
                                 size: Int,
                                 watched: Bool) {
        let filmsData = convertCoreDataFilmsStructToFilmData(films: filmsInfo)
        if filmsData.count < size {
            setMovieSegmentIsFull(value: true, watched: watched)
        }
        presenter.presentMovies(films: filmsData, watched: watched)
        networkService.fetchFilms(page: page, size: size, watched: watched) { [weak self] result in
            switch result {
            case .success(let films):
                let filmsMarked = self?.setWatchStatusToFetchedFilms(films: films, watched: watched)
                if !optionalsAreEqual(firstVal: filmsMarked, secondVal: filmsData) {
                    print("not equeal lLLALALAL")
                    if let unwrappedFilms = filmsMarked, unwrappedFilms.count == size {
                        self?.setMovieSegmentIsFull(value: false, watched: watched)
                    }
                    let startReplacePosition = size * page
                    self?.presenter.replaceLastPage(films: filmsMarked,
                                                    watched: watched,
                                                    startReplacePosition: startReplacePosition)
                    self?.actualiseFilmsInCoreData(filmsBack: filmsMarked, filmsLocal: filmsInfo)
                }
                
            case .failure(let error):
                print("Fetch Movies error - \(error.localizedDescription)")
            }
        }
    }
    
    private func handleResultOfFetchingOneFilmFromCoreData(
        filmsInfo: [FilmInfo],
        page: Int,
        size: Int,
        watched: Bool
    ) {
        let filmsData = convertCoreDataFilmsStructToFilmData(films: filmsInfo)
        presenter.addOneMovieToLastPage(film: filmsData, watched: watched)
        networkService.fetchFilms(page: page, size: 1, watched: watched) { [weak self] result in
            switch result {
            case .success(let films):
                let filmsMarked = self?.setWatchStatusToFetchedFilms(films: films, watched: watched)
                if !optionalsAreEqual(firstVal: filmsMarked, secondVal: filmsData) {
                    print("lLLALALAL not equeal lLLALALAL")
                    self?.presenter.replaceMovie(film: filmsMarked, watched: watched, at: page)
                    self?.actualiseFilmsInCoreData(filmsBack: filmsMarked, filmsLocal: filmsInfo)
                }
                
            case .failure(let error):
                print("Fetch Movies error - \(error.localizedDescription)")
            }
        }
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
        guard let back = filmsBack,
              !back.isEmpty
        else {
            CoreDataService.shared.deleteObjects(objects: filmsLocal) {
                CoreDataService.shared.saveContext()
            }
            return
        }
        changeNotEqualFilmsInfo(back: back, filmsLocal: filmsLocal)
        changeCoreDataObjectsAmount(back: back, filmsLocal: filmsLocal)
        CoreDataService.shared.saveContext()
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
            CoreDataService.shared.deleteObjects(objects: filmsForDeletion) {}
        } else {
            CoreDataService.shared.save(
                with: FilmInfo.self,
                predicate: nil,
                amount: back.count - smallSize
            ) { [weak self] objects, managedObjectContext in
                for i in 0..<back.count - smallSize {
                    self?.setFilmInfo(film: objects[i], back: back[i + smallSize])
                }
                CoreDataService.shared.saveContext()
            }
        }
    }
    
    private func setFilmInfo(film: FilmInfo, back: FilmData) {
        film.id = back.id
        film.titleDescription = back.description ?? Text.Fillings.noData
        film.posterID = back.posterId
        film.rating = getPrefix(string: String(back.rating ?? 0), prefixValue: 3)
        film.year = getPrefix(string: back.timestamp ?? Text.Fillings.noData, prefixValue: 4)
        film.genres = back.genres
        film.title = back.title
        film.isWatched = back.isWatched ?? false
    }
    
    private func compareFilms(back: FilmData, local: FilmInfo) -> Bool {
        let backYear = getPrefix(string: back.timestamp ?? Text.Fillings.noData, prefixValue: 4)
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
    
    private func getPageForMovieSegment(watched: Bool) -> Int {
        if watched {
            viewedFilmsInfo.currentPage += 1
            return viewedFilmsInfo.currentPage
        } else {
            willWatchFilmsInfo.currentPage += 1
            return willWatchFilmsInfo.currentPage
        }
    }
    
    private func setMovieSegmentIsFull(value: Bool, watched: Bool) {
        if watched {
            viewedFilmsInfo.isFull = value
        } else {
            willWatchFilmsInfo.isFull = value
        }
    }
    
    private func isMovieSegmentFull(watched: Bool) -> Bool {
        if watched {
            return viewedFilmsInfo.isFull
        } else {
            return willWatchFilmsInfo.isFull
        }
    }
    
    private func getPageForOneFilm(watched: Bool) -> Int {
        if watched {
            return (viewedFilmsInfo.currentPage + 1) * pageSize - 1
        } else {
            return (willWatchFilmsInfo.currentPage + 1) * pageSize - 1
        }
    }
}
