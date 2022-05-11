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
    func setPoster(result: Result<UIImage, Error>)
}

class DetailsViewController: BaseViewController {
    
    private var movieDetails: MovieDetails!
    private var interactor: DetailsInteractorProtocol!
    
    private lazy var scrollView = makeScrollView()
    private lazy var posterView = makePosterView()
    private lazy var spinner = makeActivityIndicator()
    private lazy var noImageLabel = makeNoImageLabel()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var ratingLabel = makeRatingLabel()
    private lazy var yearLabel = makeYearLabel()
    private lazy var yearRatingStackView = makeStackView(views: [yearLabel, ratingLabel],
                                                         viewsSpacing: DetailsScreenSizes.YearRatingStackView.labelsOffset)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationController()
        setViewInfo()
    }
    
    func setupData(imdbData: MovieData?,
                   localData: FilmInfoTmp?) {
        if let imdbData = imdbData {
            setDetailsWithIMDBData(data: imdbData)
        } else {
            setDetailsWithLocalData(data: localData!)
        }
    }
    
    func setupComponents(interactor: DetailsInteractorProtocol) {
        self.interactor = interactor
    }
    
    private func setView() {
        title = Text.Common.aboutMovie
        print(movieDetails)
        view.backgroundColor = Asset.Colors.primaryBackground.color
        view.addSubview(scrollView)
        scrollView.addSubview(posterView)
        posterView.addSubview(spinner)
        posterView.addSubview(noImageLabel)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(yearRatingStackView)
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
    
    private func setViewInfo() {
        setImageViewMode(loading: true)
        switch movieDetails.imageType {
        case .IMDB(let url):
            interactor.loadPosterWithURL(urlString: url)
        
        case .local(let id):
            interactor.loadPosterWithID(id: id)
        }
        titleLabel.text = movieDetails.title
        yearLabel.text = movieDetails.year
        ratingLabel.text = movieDetails.rating
    }
    
    private func setDetailsWithIMDBData(data: MovieData) {
        let imageType = ImageLinkType.IMDB(data.image)
        // TODO: fix "unnowned" and "0"
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
    
    private func setImageViewMode(loading: Bool = false,
                                  noImage: Bool = false,
                                  imageVisible: Bool = false) {
        spinner.isHidden = !loading
        noImageLabel.isHidden = !noImage
        if loading {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }
}

extension DetailsViewController: DetailsViewControllerProtocol {
    
    func setPoster(result: Result<UIImage, Error>) {
        switch result {
        case .success(let image):
            posterView.image = image
            setImageViewMode(imageVisible: true)
            
        case .failure:
            setImageViewMode(noImage: true)
            posterView.image = nil
        }
    }
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
//        view.backgroundColor = .red
        view.backgroundColor = Asset.Colors.grayTransperent.color
        return view
    }
    
    private func makeActivityIndicator() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.style = .white
        spinner.color = .black
        return spinner
    }
    
    private func makeNoImageLabel() -> UILabel {
        let font = UIFont.systemFont(ofSize: DetailsScreenSizes.Poster.noPosterFontSize)
        let label = makeLabel(font: font,
                              text: Text.Common.noPoster,
                              textColor: Asset.Colors.disabledAuthorizationButtonText.color)
        label.textAlignment = .center
        label.numberOfLines = 2
        label.backgroundColor = .clear
        return label
    }
    
    private func makeTitleLabel() -> UILabel {
        let font = UIFont.boldSystemFont(ofSize: DetailsScreenSizes.Title.fontSize)
        let label = makeLabel(font: font,
                              text: "",
                              textColor: .black)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }
    
    private func makeYearLabel() -> UILabel {
        let font = UIFont.systemFont(ofSize: DetailsScreenSizes.Year.fontSize)
        let label = makeLabel(font: font,
                              text: "",
                              textColor: .black)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }
    
    private func makeRatingLabel() -> UILabel {
        let font = UIFont.systemFont(ofSize: DetailsScreenSizes.Rating.fontSize)
        let label = makeLabel(font: font,
                              text: "",
                              textColor: Asset.Colors.deepBlue.color)
        label.numberOfLines = 1
        label.textAlignment = .center
        label.layer.cornerRadius = DetailsScreenSizes.Rating.cornerRadius
        label.layer.borderColor = Asset.Colors.deepBlue.color.cgColor
        label.layer.borderWidth = DetailsScreenSizes.Rating.boardWidth
        label.clipsToBounds = true
        label.backgroundColor = .clear
        return label
    }
    
    private func makeLabel(font: UIFont,
                           text: String,
                           textColor: UIColor) -> UILabel {
        let label = UILabel()
        label.font = font
        label.text = text
        label.textColor = textColor
        return label
    }
    
    private func makeStackView(views: [UIView], viewsSpacing: CGFloat) -> UIStackView {
        let view = UIStackView()
        view.axis = .horizontal
        view.distribution = .fillEqually
        view.spacing = viewsSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        for i in views {
            view.addArrangedSubview(i)
        }
        return view
    }
}

extension DetailsViewController {
    
    private func setConstraints() {
        setScrollViewConstraints()
        setPosterViewConstraints()
        setSpinnerConstraints()
        setNoImageLabelConstraints()
        setTitleLabelConstratints()
        setYearRatingStackViewConstratints()
        scrollView.snp.makeConstraints { maker in
            maker.bottom.equalTo(yearRatingStackView).offset(10)
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
    
    private func setSpinnerConstraints() {
        spinner.snp.makeConstraints { maker in
            maker.top.bottom.trailing.leading.equalToSuperview()
        }
    }
    
    private func setNoImageLabelConstraints() {
        noImageLabel.snp.makeConstraints { maker in
            maker.top.bottom.trailing.leading.equalToSuperview()
        }
    }
    
    private func setTitleLabelConstratints() {
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(posterView.snp.bottom).offset(DetailsScreenSizes.Title.topOffset)
            maker.leading.trailing.equalTo(scrollView.layoutMarginsGuide)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setYearRatingStackViewConstratints() {
        yearRatingStackView.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(DetailsScreenSizes.YearRatingStackView.topOffset)
            maker.height.equalTo(DetailsScreenSizes.YearRatingStackView.height)
            maker.width.equalTo(DetailsScreenSizes.YearRatingStackView.width)
            maker.centerX.equalToSuperview()
        }
    }
}
