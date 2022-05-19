//
//  EditMovieViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/11/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol EditMovieViewControllerProtocol: AnyObject {
}

class EditMovieViewController: BaseViewController {
    
    private var router: EditMovieRouter!
    private var movieDetails: MovieDetails!
    
    private lazy var backButton = makeBackButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.primaryBackground.color
        title = Text.Common.aboutMovie
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationController()
    }
    
    func setupComponents(router: EditMovieRouter) {
        self.router = router
    }
    
    func setupMovieData(data: MovieDetails) {
        self.movieDetails = data
    }
    
    private func setNavigationController() {
        navigationItem.leftBarButtonItem = backButton
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = UIImageView(image: Asset.logoShort.image)
    }
    
    @objc private func sendMovieDetailsToDetailsScreen() {
        let details = MovieDetails(imageType: movieDetails.imageType, rating: movieDetails.rating, year: movieDetails.year, description: "BALALALA", genres: nil, title: movieDetails.title, isWatched: movieDetails.isWatched, id: movieDetails.id)
        router.sendMovieDetailsToDetailsScreen(movieDetails: details,
                                               navigationController: navigationController!)
    }
}

extension EditMovieViewController: EditMovieViewControllerProtocol {
}

extension EditMovieViewController {
    
    private func makeBackButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(Asset.arrow.image, for: .normal)
        button.addTarget(self, action: #selector(sendMovieDetailsToDetailsScreen), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
}
