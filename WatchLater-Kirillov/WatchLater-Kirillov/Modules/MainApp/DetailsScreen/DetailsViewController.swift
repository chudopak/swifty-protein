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
    func showFailedMoviewChangingStatusStateLocal()
    func showFailedMoviewChangingStatusStateBackend()
    func changeMovieWatchStatus()
}

protocol DetailsViewControllerDelegate: AnyObject {
    func setMovieDetailsAfterEditing(movieDetails: MovieDetails)
}

class DetailsViewController: BaseViewController {
    
    private var movieDetails: MovieDetails!
    private var movieDetailsBeforeEditing: MovieDetails!
    private var interactor: DetailsInteractorProtocol!
    private var router: DetailsRouter!
    private weak var previousVCDelegate: FilmInfoChangedInformerDelegate!
    
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
    private lazy var editScreenButton = makeEditScreenButtonItem()
    
    private lazy var genresStackViews = [UIStackView]()
    private lazy var backBarButton = makeBackButtonItem()
    
    private var genres: [String]?
    private var scrollViewButtonConstraint: ConstraintMakerEditable?
    
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
    
    func setupData(movieData: MovieData?,
                   filmData: FilmData?) {
        if let imdbData = movieData {
            setDetailsWithMovieData(data: imdbData)
        } else {
            setDetailsWithFilmData(data: filmData!)
        }
    }
    
    func setupComponents(interactor: DetailsInteractorProtocol,
                         router: DetailsRouter,
                         previousVCDelegate: FilmInfoChangedInformerDelegate) {
        self.interactor = interactor
        self.router = router
        self.previousVCDelegate = previousVCDelegate
    }
    
    private func setView() {
        title = Text.Common.aboutMovie
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
            navigationItem.rightBarButtonItem = editScreenButton
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
        navigationItem.leftBarButtonItem = backBarButton
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
        if !optionalsAreEqual(firstVal: genres, secondVal: movieDetails.genres) {
            genres = movieDetails.genres
            removeGenresStackViews()
            createGenresStackViews()
        }
        setScrollViewButtonConstraint()
    }
    
    private func createGenresStackViews() {
        guard let newGenres = genres
        else {
            return
        }
        var i = 0
        var currentStackViewWidth: CGFloat = 0
        var labels = [UILabel]()
        labels.reserveCapacity(5)
        while i < newGenres.count {
            let label = createGenreLabel(genreTitle: newGenres[i])
            if currentStackViewWidth + label.bounds.size.width < DetailsScreenSizes.Genres.maxWidth {
                currentStackViewWidth += label.bounds.size.width + DetailsScreenSizes.Genres.labelSpace
                labels.append(label)
            } else {
                let stack = makeStackView(views: labels,
                                          viewsSpacing: DetailsScreenSizes.Genres.labelSpace)
                scrollView.addSubview(stack)
                currentStackViewWidth = 0
                genresStackViews.append(stack)
                labels.removeAll()
                currentStackViewWidth += label.bounds.size.width + DetailsScreenSizes.Genres.labelSpace
                labels.append(label)
            }
            i += 1
        }
        if !labels.isEmpty {
            let stack = makeStackView(views: labels,
                                      viewsSpacing: DetailsScreenSizes.Genres.labelSpace)
            scrollView.addSubview(stack)
            genresStackViews.append(stack)
        }
        setStackConstraints()
    }
    
    private func removeGenresStackViews() {
        for stack in genresStackViews {
            for view in stack.arrangedSubviews {
                view.removeFromSuperview()
                view.snp.removeConstraints()
            }
            stack.snp.removeConstraints()
        }
        genresStackViews = [UIStackView]()
    }
    
    private func setDetailsWithMovieData(data: MovieData) {
        let imageType: ImageLinkType
        if let url = URL(string: data.image),
           UIApplication.shared.canOpenURL(url) {
            imageType = ImageLinkType.IMDB(data.image)
        } else {
            imageType = ImageLinkType.local(data.image)
        }
        let rating = getPrefix(string: data.rating ?? Text.Fillings.noData, prefixValue: 3)
        let year = data.year ?? Text.Fillings.noData
        movieDetails = MovieDetails(imageType: imageType,
                                    rating: rating,
                                    year: year,
                                    description: data.description,
                                    genres: data.genres,
                                    title: data.title,
                                    isWatched: data.isWatched,
                                    id: Int(data.id) ?? -1)
        movieDetailsBeforeEditing = movieDetails
    }
    
    private func setDetailsWithFilmData(data: FilmData) {
        let imageType = ImageLinkType.local(data.posterId ?? Text.Fillings.noData)
        let rating = getPrefix(string: String(data.rating ?? 0), prefixValue: 3)
        let year = getPrefix(string: data.timestamp ?? Text.Fillings.noData, prefixValue: 4)
        movieDetails = MovieDetails(imageType: imageType,
                                    rating: rating,
                                    year: year,
                                    description: data.description ?? Text.Fillings.noData,
                                    genres: data.genres,
                                    title: data.title,
                                    isWatched: data.isWatched,
                                    id: data.id)
        movieDetailsBeforeEditing = movieDetails
    }
    
    private func getPrefix(string: String, prefixValue: Int) -> String {
        var str = string.prefix(prefixValue)
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
    
    @objc private func addFilmToCollection() {
        // TODO: add film to local API
        addFilmButton.isHidden = true
        buttonsStack.isHidden = false
        navigationItem.rightBarButtonItem = editScreenButton
    }
    
    @objc private func markAsWatched() {
        interactor.changeFilmWatchStatus(id: movieDetails.id)
    }
    
    @objc private func markAsUnwatched() {
        interactor.changeFilmWatchStatus(id: movieDetails.id)
    }
    
    @objc private func presentEditMovieScreen() {
        router.presentEditViewController(navigationController: navigationController!,
                                         movieDetails: movieDetails)
    }
    
    @objc private func presentPreviousScreen() {
        if movieDetailsBeforeEditing != movieDetails {
            let image: String?
            switch movieDetails.imageType {
            case .IMDB(let imdb):
                image = imdb
                
            case .local(let local):
                image = (local == "-1") ? nil : local
            }
            let data = FilmData(
                id: movieDetails.id,
                title: movieDetails.title,
                description: movieDetails.description,
                rating: Double(movieDetails.rating),
                posterId: image,
                genres: movieDetails.genres,
                isWatched: movieDetails.isWatched,
                timestamp: movieDetails.year
            )
            previousVCDelegate.cangeFilmInfo(filmData: data)
        }
        router.presentPreviousViewController(navigationController: navigationController!)
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
    
    func showFailedMoviewChangingStatusStateLocal() {
        print("DetailsViewController, showFailedMoviewChangingStatusState - Called failed state")
    }
    
    func showFailedMoviewChangingStatusStateBackend() {
        // TODO: Show smth to user if failed
        changeMovieWatchStatus()
    }
    
    func changeMovieWatchStatus() {
        guard let status = movieDetails.isWatched
        else {
            return
        }
        movieDetails.isWatched = !status
        if !status {
            willWatchButton.isEnabled = true
            viewedButton.isEnabled = false
        } else {
            willWatchButton.isEnabled = false
            viewedButton.isEnabled = true
        }
    }
}

extension DetailsViewController: DetailsViewControllerDelegate {

    func setMovieDetailsAfterEditing(movieDetails: MovieDetails) {
        self.movieDetails = movieDetails
    }
}

extension DetailsViewController {
    
    private func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.isScrollEnabled = true
        return view
    }
    
    private func makePosterView() -> UIImageView {
        let view = UIImageView()
        view.clipsToBounds = true
        view.contentMode = .scaleToFill
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
        let colorSet = BaseBorderButton.ColorSet(
            enabledText: .black,
            enabledBackground: .clear,
            enabledBorder: .black,
            disabledText: Asset.Colors.grayTransperent.color,
            disabledBackground: .clear,
            disabledBorder: Asset.Colors.grayTransperent.color
        )
        let button = BaseBorderButton(colorSet: colorSet,
                                      text: "+ " + Text.Common.willWatch,
                                      fontSize: DetailsScreenSizes.buttonsFontSize)
        button.layer.cornerRadius = DetailsScreenSizes.buttonsCornerRadius
        button.layer.borderWidth = DetailsScreenSizes.buttonsBorderWidth
        button.isEnabled = true
        button.addTarget(self, action: #selector(addFilmToCollection), for: .touchUpInside)
        return button
    }
    
    private func makeWillWatchButton() -> BaseBorderButton {
        let colorSet = BaseBorderButton.ColorSet(
            enabledText: Asset.Colors.grayTextHalfTranparent.color,
            enabledBackground: .clear,
            enabledBorder: Asset.Colors.grayTextHalfTranparent.color,
            disabledText: Asset.Colors.deepBlue.color,
            disabledBackground: .clear,
            disabledBorder: Asset.Colors.deepBlue.color
        )
        let button = BaseBorderButton(colorSet: colorSet,
                                      text: Text.Common.willWatch,
                                      fontSize: DetailsScreenSizes.buttonsFontSize)
        button.isEnabled = false
        button.layer.cornerRadius = DetailsScreenSizes.buttonsCornerRadius
        button.layer.borderWidth = DetailsScreenSizes.buttonsBorderWidth
        button.addTarget(self, action: #selector(markAsUnwatched), for: .touchUpInside)
        return button
    }
    
    private func makeViewedButton() -> BaseBorderButton {
        let colorSet = BaseBorderButton.ColorSet(
            enabledText: Asset.Colors.grayTextHalfTranparent.color,
            enabledBackground: .clear,
            enabledBorder: Asset.Colors.grayTextHalfTranparent.color,
            disabledText: Asset.Colors.deepBlue.color,
            disabledBackground: .clear,
            disabledBorder: Asset.Colors.deepBlue.color
        )
        let button = BaseBorderButton(colorSet: colorSet,
                                      text: Text.Common.viewed,
                                      fontSize: DetailsScreenSizes.buttonsFontSize)
        button.isEnabled = true
        button.layer.cornerRadius = DetailsScreenSizes.buttonsCornerRadius
        button.layer.borderWidth = DetailsScreenSizes.buttonsBorderWidth
        button.addTarget(self, action: #selector(markAsWatched), for: .touchUpInside)
        return button
    }
    
    private func makeTextView() -> UILabel {
        let textView = UILabel()
        textView.text = ""
        textView.font = .systemFont(ofSize: DetailsScreenSizes.TextView.fontSize)
        textView.textColor = .black
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        textView.numberOfLines = 0
        return textView
    }
    
    private func createGenreLabel(genreTitle: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0,
                                          y: 0,
                                          width: CGFloat.greatestFiniteMagnitude,
                                          height: DetailsScreenSizes.Genres.stackHeight))
        label.font = .boldSystemFont(ofSize: DetailsScreenSizes.Genres.labelFontSize)
        label.layer.borderWidth = DetailsScreenSizes.Genres.labelBoardWidth
        label.textColor = .black
        label.layer.cornerRadius = DetailsScreenSizes.Genres.labelCornerRadius
        label.textAlignment = .center
        if genreTitle.count > DetailsScreenSizes.Genres.maxCharsInLabel {
            var text = getPrefix(string: genreTitle,
                                 prefixValue: DetailsScreenSizes.Genres.maxCharsInLabel - 3)
            text += "..."
            label.text = text
        } else {
            label.text = genreTitle
        }
        label.sizeToFit()
        label.bounds.size.width += 2 * DetailsScreenSizes.Genres.labelCornerRadius
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
        view.spacing = viewsSpacing
        view.translatesAutoresizingMaskIntoConstraints = false
        for i in views {
            view.addArrangedSubview(i)
        }
        return view
    }
    
    private func makeEditScreenButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(Asset.editFilmInfo.image, for: .normal)
        button.addTarget(self, action: #selector(presentEditMovieScreen), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    private func makeBackButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(Asset.arrow.image, for: .normal)
        button.addTarget(self, action: #selector(presentPreviousScreen), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
}

extension DetailsViewController {
    
    private func setConstraints() {
        setPosterViewConstraints()
        setSpinnerConstraints()
        setNoImageLabelConstraints()
        setTitleLabelConstratints()
        setYearRatingStackViewConstratints()
        setAddFilmButtonConstratints()
        setButtonsStackConstratints()
        setTextViewConstraints()
    }
    
    private func setScrollViewConstraints() {
        scrollView.snp.makeConstraints { maker in
            maker.leading.trailing.top.bottom.equalToSuperview()
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
            maker.width.equalTo(DetailsScreenSizes.Year.width)
        }
        ratingLabel.snp.makeConstraints { maker in
            maker.width.equalTo(DetailsScreenSizes.Rating.width)
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
            maker.width.equalTo(DetailsScreenSizes.ViewedButton.width)
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
        }
    }
    
    private func setStackConstraints() {
        for i in 0..<genresStackViews.count {
            for label in genresStackViews[i].arrangedSubviews {
                label.snp.makeConstraints { maker in
                    maker.width.equalTo(label.bounds.size.width)
                }
            }
            if i != 0 {
                genresStackViews[i].snp.makeConstraints { maker in
                    maker.top.equalTo(genresStackViews[i - 1].snp.bottom).offset(DetailsScreenSizes.Genres.stackTopOffset)
                    maker.height.equalTo(DetailsScreenSizes.Genres.stackHeight)
                    maker.centerX.equalToSuperview()
                }
            } else {
                genresStackViews[i].snp.makeConstraints { maker in
                    maker.top.equalTo(textView.snp.bottom).offset(DetailsScreenSizes.Genres.stackTopOffset)
                    maker.height.equalTo(DetailsScreenSizes.Genres.stackHeight)
                    maker.centerX.equalToSuperview()
                }
            }
        }
    }
    
    private func setScrollViewButtonConstraint() {
        if let lastStack = genresStackViews.last {
            scrollView.snp.remakeConstraints { maker in
                maker.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
                maker.bottom.equalTo(lastStack).offset(DetailsScreenSizes.scrollViewButtonOffset)
            }
        } else {
            scrollView.snp.remakeConstraints { maker in
                maker.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
                maker.bottom.equalTo(textView).offset(DetailsScreenSizes.scrollViewButtonOffset)
            }
        }
    }
}
