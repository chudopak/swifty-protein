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
    private lazy var yearRatingStackView = makeStackView(
        views: [yearLabel, ratingLabel],
        viewsSpacing: DetailsScreenSizes.YearRatingStackView.labelsOffset
    )
    private lazy var addFilmButton = makeAddFilmButton()
    private lazy var willWatchButton = makeWillWatchButton()
    private lazy var viewedButton = makeViewedButton()
    private lazy var buttonsStack = makeStackView(
        views: [willWatchButton, viewedButton],
        viewsSpacing: DetailsScreenSizes.ButtonsStack.buttonsOffset
    )
    private lazy var textView = makeTextView()
    
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
        scrollView.addSubview(addFilmButton)
        scrollView.addSubview(buttonsStack)
        scrollView.addSubview(textView)
    }
    
    private func setButtons() {
        if let isWatched = movieDetails.isWatched {
            buttonsStack.isHidden = false
            addFilmButton.isHidden = true
            if isWatched {
                willWatchButton.isEnabled = true
                viewedButton.isEnabled = false
            } else {
                willWatchButton.isEnabled = false
                viewedButton.isEnabled = true
            }
        } else {
            buttonsStack.isHidden = true
            addFilmButton.isHidden = false
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
        setButtons()
        textView.snp.updateConstraints { maker in
            maker.height.equalTo(getTextViewHeight())
        }
        textView.text = movieDetails.description
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
                                    isWatched: data.isWatched)
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
    
    private func getTextViewHeight() -> CGFloat {
        let textView = UITextView(frame: CGRect(x: 0,
                                                y: 0,
                                                width: DetailsScreenSizes.TextView.width,
                                                height: CGFloat.greatestFiniteMagnitude))
        textView.text = movieDetails.description
        textView.font = .systemFont(ofSize: DetailsScreenSizes.TextView.fontSize)
        textView.sizeToFit()
        return (textView.frame.height)
    }
    
    @objc private func addFilmToAPI() {
        // TODO: add film to local API
        addFilmButton.isHidden = true
        buttonsStack.isHidden = false
//        print("Year rating - \(yearLabel.frame.size.width)  \(ratingLabel.frame.size.width)")
//        print("Buttons - \(willWatchButton.frame.size.width) \(viewedButton.frame.size.width)")
    }
    
    @objc private func makrAsWatched() {
        // TODO: add film to local API as Viewed
        willWatchButton.isEnabled = true
        viewedButton.isEnabled = false
    }
    
    @objc private func makrAsUnwatched() {
        // TODO: mark as unwatched
        willWatchButton.isEnabled = false
        viewedButton.isEnabled = true
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
    
    private func makeAddFilmButton() -> BaseBorderButton {
        let colorSet = BaseBorderButton.ColorSet(enabledText: .black,
                                                 enabledBackground: .clear,
                                                 enabledBorder: .black,
                                                 disabledText: Asset.Colors.grayTransperent.color,
                                                 disabledBackground: .clear,
                                                 disabledBorder: Asset.Colors.grayTransperent.color)
        let button = BaseBorderButton(colorSet: colorSet,
                                      text: "+ " + Text.Common.willWatch,
                                      fontSize: DetailsScreenSizes.buttonsFontSize)
        button.layer.cornerRadius = DetailsScreenSizes.buttonsCornerRadius
        button.layer.borderWidth = DetailsScreenSizes.buttonsBorderWidth
        button.isEnabled = true
        button.addTarget(self, action: #selector(addFilmToAPI), for: .touchUpInside)
        return button
    }
    
    private func makeWillWatchButton() -> BaseBorderButton {
        let colorSet = BaseBorderButton.ColorSet(enabledText: Asset.Colors.grayTransperent.color,
                                                 enabledBackground: .clear,
                                                 enabledBorder: Asset.Colors.grayTransperent.color,
                                                 disabledText: Asset.Colors.deepBlue.color,
                                                 disabledBackground: .clear,
                                                 disabledBorder: Asset.Colors.deepBlue.color)
        let button = BaseBorderButton(colorSet: colorSet,
                                      text: Text.Common.willWatch,
                                      fontSize: DetailsScreenSizes.buttonsFontSize)
        button.isEnabled = false
        button.layer.cornerRadius = DetailsScreenSizes.buttonsCornerRadius
        button.layer.borderWidth = DetailsScreenSizes.buttonsBorderWidth
        button.addTarget(self, action: #selector(makrAsUnwatched), for: .touchUpInside)
        return button
    }
    
    private func makeViewedButton() -> BaseBorderButton {
        let colorSet = BaseBorderButton.ColorSet(enabledText: Asset.Colors.grayTransperent.color,
                                                 enabledBackground: .clear,
                                                 enabledBorder: Asset.Colors.grayTransperent.color,
                                                 disabledText: Asset.Colors.deepBlue.color,
                                                 disabledBackground: .clear,
                                                 disabledBorder: Asset.Colors.deepBlue.color)
        let button = BaseBorderButton(colorSet: colorSet,
                                      text: Text.Common.viewed,
                                      fontSize: DetailsScreenSizes.buttonsFontSize)
        button.isEnabled = true
        button.layer.cornerRadius = DetailsScreenSizes.buttonsCornerRadius
        button.layer.borderWidth = DetailsScreenSizes.buttonsBorderWidth
        button.addTarget(self, action: #selector(makrAsWatched), for: .touchUpInside)
        return button
    }
    
    private func makeTextView() -> UITextView {
        let textView = UITextView()
        textView.text = ""
        textView.font = .systemFont(ofSize: DetailsScreenSizes.TextView.fontSize)
        textView.textColor = .black
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.isScrollEnabled = false
        return textView
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
        setAddFilmButtonConstratints()
        setButtonsStackConstratints()
        setTextViewConstraints()
        scrollView.snp.makeConstraints { maker in
            maker.bottom.equalTo(textView).offset(10)
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
        yearLabel.snp.makeConstraints { maker in
            maker.width.equalTo(42)
        }
        ratingLabel.snp.makeConstraints { maker in
            maker.width.equalTo(36)
        }
        yearRatingStackView.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(DetailsScreenSizes.YearRatingStackView.topOffset)
            maker.height.equalTo(DetailsScreenSizes.YearRatingStackView.height)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setAddFilmButtonConstratints() {
        addFilmButton.snp.makeConstraints { maker in
            maker.top.equalTo(yearRatingStackView.snp.bottom).offset(DetailsScreenSizes.AddFilmButton.topOffset)
            maker.height.equalTo(DetailsScreenSizes.AddFilmButton.height)
            maker.width.equalTo(DetailsScreenSizes.AddFilmButton.width)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setButtonsStackConstratints() {
        willWatchButton.snp.makeConstraints { maker in
            maker.width.equalTo(DetailsScreenSizes.WillWatchButton.width)
        }
        viewedButton.snp.makeConstraints { maker in
            maker.width.equalTo(125)
        }
        buttonsStack.snp.makeConstraints { maker in
            maker.top.equalTo(yearRatingStackView.snp.bottom).offset(DetailsScreenSizes.ButtonsStack.topOffset)
            maker.height.equalTo(DetailsScreenSizes.ButtonsStack.height)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setTextViewConstraints() {
        textView.snp.makeConstraints { maker in
            maker.top.equalTo(buttonsStack.snp.bottom).offset(DetailsScreenSizes.TextView.topOffset)
            maker.height.equalTo(DetailsScreenSizes.TextView.startHeight)
            maker.width.equalTo(DetailsScreenSizes.TextView.width)
            maker.centerX.equalToSuperview()
//            maker.leading.trailing.equalTo(scrollView.layoutMarginsGuide).inset(DetailsScreenSizes.TextView.sideOffset)
        }
    }
}
