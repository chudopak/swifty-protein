//
//  DetailsViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/6/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

protocol DetailsViewControllerProtocol: AnyObject {
}

class DetailsViewController: BaseViewController {
    
    private var movieDetails: MovieDetails!
    private var imageDowloadingServise: ImageDownloadingServiceProtocol!
    
    private lazy var scrollView = makeScrollView()
    private lazy var posterView = makePosterView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationController()
    }
    
    func setupData(imdbData: MovieData?,
                   localData: FilmInfoTmp?) {
        if let imdbData = imdbData {
            setDetailsWithIMDBData(data: imdbData)
        } else {
            setDetailsWithLocalData(data: localData!)
        }
    }
    
    func setupComponents(imageDowloadingServise: ImageDownloadingServiceProtocol) {
        self.imageDowloadingServise = imageDowloadingServise
    }
    
    private func setView() {
        title = Text.Common.aboutMovie
        print(movieDetails)
        view.backgroundColor = Asset.Colors.primaryBackground.color
        view.addSubview(scrollView)
        scrollView.addSubview(posterView)
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
        //TODO: fix "unnowned" and "0"
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
    
    private func getRatingString(rating: String) -> String {
        var str = rating.prefix(3)
        if str.suffix(1) == "." {
            str.remove(at: str.index(before: str.endIndex))
        }
        return String(str)
    }
}

extension DetailsViewController: DetailsViewControllerProtocol {
}

extension DetailsViewController {
    
    private func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = .clear
        return view
    }
    
    private func makePosterView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .red
//        view.backgroundColor = Asset.Colors.grayTransperent.color
        return view
    }
}

extension DetailsViewController {
    
    private func setConstraints() {
        setScrollViewConstraints()
        setPosterViewConstraints()
        scrollView.snp.makeConstraints { maker in
            maker.bottom.equalTo(posterView).offset(10)
        }
    }
    
    private func setScrollViewConstraints() {
        scrollView.snp.makeConstraints { maker in
            maker.leading.trailing.bottom.top.equalToSuperview()
        }
    }
    
    private func setPosterViewConstraints() {
        posterView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(DetailsScreenSizes.Poster.topOffset)
            maker.width.equalTo(DetailsScreenSizes.Poster.width)
            maker.height.equalTo(DetailsScreenSizes.Poster.height)
            maker.centerX.equalTo(scrollView.snp.centerXWithinMargins)
        }
    }
}
