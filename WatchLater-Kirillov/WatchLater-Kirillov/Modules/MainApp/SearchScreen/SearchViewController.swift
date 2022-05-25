//
//  SearchViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/29/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    func displayIMDBMovies(movies: [MovieData])
    func showFailedStateIMDB(isSearching: Bool)
    func displayLocalMovies(movies: [MovieData])
    func showFailedStateLocal()
}

protocol SearchViewControllerDelegate: AnyObject {
    func presentDetailsScreen(movieData: MovieData?,
                              filmData: FilmData?)
}

class SearchViewController: BaseViewController, UITextFieldDelegate {
    
    private let imdbSegment = 0
    private let localSegment = 1
    
    private var isKeyboardUp = false
    
    private lazy var segmentControl = makeSegmentControl()
    private lazy var textField = makeTextField()
    private lazy var label = makeStartTypingLabel()
    private lazy var resultsTableView = makeResultsTableView()
    private lazy var spiner = makeSpinner()
    
    private weak var filmChangedDelegate: FilmInfoChangedInformerDelegate!
    private var interactor: SearchInteractorProtocol!
    private var router: SearchRouter!
    
    private var imdbSearchText = SearchText(previous: "", current: "")
    private var localSearchText = SearchText(previous: "", current: "")
    
    private var localSearchResult = [MovieData]() {
        didSet {
            if segmentControl.selectedSegmentIndex == localSegment {
                resultsTableView.moviesData = localSearchResult
            }
        }
    }
    
    private var imdbSearchResult = [MovieData]() {
        didSet {
            if segmentControl.selectedSegmentIndex == imdbSegment {
                resultsTableView.moviesData = imdbSearchResult
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setGestures()
        setConstraints()
        setKeyBoboardObservers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationController()
    }
    
    func setupComponents(interactor: SearchInteractorProtocol,
                         router: SearchRouter,
                         filmChangedDelegate: FilmInfoChangedInformerDelegate) {
        self.interactor = interactor
        self.router = router
        self.filmChangedDelegate = filmChangedDelegate
    }
    
    private func setView() {
        view.backgroundColor = Asset.Colors.primaryBackground.color
        title = NSLocalizedString(Text.TabBar.search, comment: "")
        view.addSubview(segmentControl)
        view.addSubview(textField)
        view.addSubview(label)
        view.addSubview(resultsTableView)
        view.addSubview(spiner)
        resultsTableView.isHidden = true
        spiner.isHidden = true
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
    
    private func setGestures() {
        let hideKeyboardGuesture = UITapGestureRecognizer(target: self,
                                                          action: #selector(textFieldHideKeyboard))
        hideKeyboardGuesture.cancelsTouchesInView = false
        view.addGestureRecognizer(hideKeyboardGuesture)
    }
    
    private func makeVisible(tableView tableViewVisibility: Bool = false,
                             label labelVisibility: Bool = false,
                             spinner spinnerVisibility: Bool = false,
                             errorView errorVisibility: Bool = false) {
        if errorVisibility {
            label.isHidden = !errorVisibility
            label.text = Text.Authorization.somethingWentWrong
        } else {
            label.isHidden = !labelVisibility
            label.text = Text.SearchScreen.startTypingLabelText
        }
        resultsTableView.isHidden = !tableViewVisibility
        spiner.isHidden = !spinnerVisibility
        if spinnerVisibility {
            spiner.startAnimating()
        } else {
            spiner.stopAnimating()
        }
    }
    
    private func getSearchArea() -> SearchArea {
        switch segmentControl.selectedSegmentIndex {
        case imdbSegment:
            return SearchArea.IMDB
        
        default:
            return SearchArea.local
        }
    }
    
    private func searchMovies(expression: String) {
        switch getSearchArea() {
        case .IMDB:
            if imdbSearchText.previous != expression {
                makeVisible(spinner: true)
                interactor.cancelCurrentTask(expression: imdbSearchText.previous) { [weak self] in
                    DispatchQueue.main.async { [weak self] in
                        self?.resultsTableView.moviesData = [MovieData]()
                    }
                    self?.interactor.searchMoviesIMDB(expression: expression)
                }
            }
            imdbSearchText.previous = expression
        
        case .local:
            if localSearchText.previous != expression {
                interactor.searchMoviesLocal(expression: expression)
            }
            localSearchText.previous = expression
        }
    }
    
    @objc private func changeSearchSource(_ sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
        case imdbSegment:
            localSearchText.current = textField.text ?? ""
            textField.text = imdbSearchText.current
            if interactor.isSearching {
                makeVisible(spinner: true)
            } else if !imdbSearchText.current.isEmpty {
                makeVisible(tableView: true)
            } else {
                makeVisible(label: true)
            }
            resultsTableView.moviesData = imdbSearchResult
            resultsTableView.searchArea = .IMDB
            
        case localSegment:
            imdbSearchText.current = textField.text ?? ""
            textField.text = localSearchText.current
            if !localSearchText.current.isEmpty {
                makeVisible(tableView: true)
            } else {
                makeVisible(label: true)
            }
            resultsTableView.moviesData = localSearchResult
            resultsTableView.searchArea = .local
            
        default:
            break
        }
    }
    
    @objc private func textFieldDidChange() {
        if let text = textField.text,
           !text.isEmpty {
            searchMovies(expression: text)
        } else {
            makeVisible(label: true)
            if getSearchArea() == .IMDB {
                interactor.cancelCurrentTask(expression: imdbSearchText.previous) { [weak self] in
                    DispatchQueue.main.async {
                        self?.resultsTableView.moviesData = [MovieData]()
                    }
                }
                imdbSearchText.previous = ""
            }
        }
    }
    
    @objc private func textFieldHideKeyboard() {
        textField.resignFirstResponder()
    }
    
    @objc private func textFieldDonePressed() {
        if let text = textField.text,
           !text.isEmpty {
            searchMovies(expression: text)
        }
        textField.resignFirstResponder()
    }
}

extension SearchViewController {
    
    private func setKeyBoboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if !isKeyboardUp {
                setScrollViewKeyboardUpConstraint(keyboardHeight: keyboardSize.height)
                isKeyboardUp = true
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        if isKeyboardUp {
            setScrollViewKeyboardUpConstraint(keyboardHeight: 0)
            isKeyboardUp = false
        }
    }
}

extension SearchViewController: SearchViewControllerProtocol {
    
    func displayIMDBMovies(movies: [MovieData]) {
        makeVisible(tableView: true)
        imdbSearchResult = movies
    }
    
    func displayLocalMovies(movies: [MovieData]) {
        makeVisible(tableView: true)
        localSearchResult = movies
    }
    
    func showFailedStateIMDB(isSearching: Bool) {
        if let text = textField.text,
           !text.isEmpty {
            if isSearching {
                makeVisible(spinner: true)
            } else {
                makeVisible(errorView: true)
            }
        } else {
            makeVisible(label: true)
        }
    }
    
    func showFailedStateLocal() {
        if let text = textField.text,
           !text.isEmpty {
            makeVisible(errorView: true)
        } else {
            makeVisible(label: true)
        }
    }
}

extension SearchViewController: SearchViewControllerDelegate {
    
    func presentDetailsScreen(movieData: MovieData?,
                              filmData: FilmData?) {
        router.presentDetailsViewController(navigationController: navigationController!,
                                            movieData: movieData,
                                            filmData: filmData,
                                            screenVCDelegate: filmChangedDelegate)
    }
}

extension SearchViewController {
    
    private func makeSegmentControl() -> UISegmentedControl {
        let controll = UISegmentedControl(items: [Text.SearchScreen.imdb, Text.SearchScreen.collection])
        controll.selectedSegmentIndex = 0
        controll.backgroundColor = Asset.Colors.grayTransperent.color
        controll.tintColor = .white
        controll.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 15),
                                         .foregroundColor: Asset.Colors.black.color],
                                        for: .normal)
        controll.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 15),
                                         .foregroundColor: Asset.Colors.black.color],
                                        for: .selected)
        if #available(iOS 13.0, *) {
            controll.selectedSegmentTintColor = .white
        }
        controll.addTarget(self, action: #selector(changeSearchSource), for: .valueChanged)
        return controll
    }
    
    private func makeTextField() -> UITextField {
        let textField = UITextField()
        let imageView = UIImageView()
        imageView.image = Asset.searchIconGray.image
        let containerView = UIView(frame: SearchScreenSizes.TextField.searchImageContainerViewRect)
        containerView.addSubview(imageView)
        imageView.center = containerView.center
        imageView.bounds.size = SearchScreenSizes.TextField.searchImageViewSize
        textField.leftView = containerView
        textField.leftViewMode = .always
        textField.attributedPlaceholder = NSAttributedString(string: Text.SearchScreen.enterFilm, attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.loginPlaceholderTextColor.color])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.backgroundColor = Asset.Colors.grayTransperent.color
        textField.textAlignment = .left
        textField.autocapitalizationType = .none
        textField.layer.cornerRadius = SearchScreenSizes.TextField.cornerRadius
        textField.textColor = Asset.Colors.textColor.color
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .search
        textField.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        textField.addTarget(
            self,
            action: #selector(textFieldDonePressed),
            for: .editingDidEndOnExit
        )
        return (textField)
    }
    
    private func makeStartTypingLabel() -> UILabel {
        let label = UILabel()
        label.text = Text.SearchScreen.startTypingLabelText
        label.textAlignment = .left
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: SearchScreenSizes.StartTypingLabel.fontSize)
        label.textColor = Asset.Colors.grayTextHalfTranparent.color
        return label
    }
    
    private func makeResultsTableView() -> SearchedFilmsTableView {
        let networkLayer = NetworkLayer(refreshService: RefreshTokenService())
        let imageService = ImageDownloadingService(networkManager: networkLayer)
        return SearchedFilmsTableView(imageDownloadingService: imageService,
                                      delegate: self)
    }
    
    private func makeSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.style = .white
        spinner.color = .black
        return spinner
    }
}

extension SearchViewController {
    
    private func setConstraints() {
        setSegmentControlConstratints()
        setTextFieldConstratints()
        setStartTypingLabelConstratints()
        setTableViewConstratints()
        setSpinnerConsrtaints()
    }
    
    private func setSegmentControlConstratints() {
        segmentControl.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(view.layoutMarginsGuide)
            maker.top.equalTo(view.safeAreaLayoutGuide).inset(SearchScreenSizes.SegmentControl.topOffset)
            maker.height.equalTo(SearchScreenSizes.SegmentControl.height)
        }
    }
    
    private func setTextFieldConstratints() {
        textField.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(view.layoutMarginsGuide)
            maker.top.equalTo(segmentControl.snp.bottom).offset(SearchScreenSizes.TextField.topOffset)
            maker.height.equalTo(SearchScreenSizes.TextField.height)
        }
    }
    
    private func setStartTypingLabelConstratints() {
        label.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(view.layoutMarginsGuide)
            maker.top.equalTo(textField.snp.bottom).offset(SearchScreenSizes.StartTypingLabel.topOffset)
            maker.height.equalTo(SearchScreenSizes.StartTypingLabel.height)
        }
    }
    
    private func setTableViewConstratints() {
        resultsTableView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(textField.snp.bottom).offset(SearchScreenSizes.TextField.topOffset)
            maker.bottom.equalTo(view)
        }
    }
    
    private func setSpinnerConsrtaints() {
        spiner.snp.makeConstraints { maker in
            maker.top.equalTo(textField.snp.bottom).offset(SearchScreenSizes.Spinner.topOffset)
            maker.width.height.equalTo(SearchScreenSizes.Spinner.spinnerSize)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setScrollViewKeyboardUpConstraint(keyboardHeight: CGFloat) {
        resultsTableView.snp.updateConstraints { maker in
//            maker.leading.trailing.equalToSuperview()
//            maker.top.equalTo(textField.snp.bottom).offset(SearchScreenSizes.TextField.topOffset)
            maker.bottom.equalTo(view).inset(keyboardHeight)
        }
    }
}
