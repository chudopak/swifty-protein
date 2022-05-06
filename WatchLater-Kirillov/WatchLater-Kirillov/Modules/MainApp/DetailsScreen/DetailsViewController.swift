//
//  DetailsViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/6/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class DetailsViewController: BaseViewController {
    
    private var movieDetails: MovieDetails!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = Text.Common.aboutMovie
        print(movieDetails)
        view.backgroundColor = .blue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationController()
    }
    
    func setupComponents(imdbData: MovieData?,
                         localData: FilmInfoTmp?) {
        if let imdbData = imdbData {
            setDetailsWithIMDBData(data: imdbData)
        } else {
            setDetailsWithLocalData(data: localData!)
        }
    }
    
    private func setNavigationController() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil)
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = UIImageView(image: Asset.logoShort.image)
    }
    
    private func setDetailsWithIMDBData(data: MovieData) {
        let imageType = ImageLinkType.IMDB(data.image)
        let rating = getRatingString(rating: data.rating ?? "0")
        let year = data.year ?? "unnowned"
        movieDetails = MovieDetails(imageType: imageType,
                                    rating: rating,
                                    year: year,
                                    description: data.description,
                                    genres: nil,
                                    title: data.title,
                                    isWatched: nil)
    }
    
    private func setDetailsWithLocalData(data: FilmInfoTmp) {
        let imageType = ImageLinkType.local(data.posterId ?? "-1")
        let rating = getRatingString(rating: String(data.rating ?? 0))
        movieDetails = MovieDetails(imageType: imageType,
                                    rating: rating,
                                    year: "year",
                                    description: data.description ?? "",
                                    genres: data.geners,
                                    title: data.title,
                                    isWatched: nil)
    }
    
    func getRatingString(rating: String) -> String {
        var str = rating.prefix(3)
        if str.suffix(1) == "." {
            str.remove(at: str.index(before: str.endIndex))
        }
        return String(str)
    }
}
