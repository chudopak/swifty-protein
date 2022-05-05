//
//  SearchViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/29/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol SearchViewControllerProtocol: AnyObject {
    func displayMovies(movies: [MovieData])
}

class SearchViewController: BaseViewController, UITextFieldDelegate {
    
    enum SearchArea {
        case IMDB, local
    }
    
    private lazy var segmentControl = makeSegmentControl()
    private lazy var textField = makeTextField()
    private lazy var startTypingLabel = makeStartTypingLabel()
    private lazy var resultsTableView = SearchedFilmsTableView()
    
    private var interactor: SearchInteractorProtocol!
    
    private var previousExpression = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setGestures()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationController()
    }
    
    func setupComponents(interactor: SearchInteractorProtocol) {
        self.interactor = interactor
    }
    
    private func setView() {
        view.backgroundColor = Asset.Colors.primaryBackground.color
        title = NSLocalizedString(Text.TabBar.search, comment: "")
        view.addSubview(segmentControl)
        view.addSubview(textField)
        view.addSubview(startTypingLabel)
        view.addSubview(resultsTableView)
        resultsTableView.isHidden = true
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
    
    private func changeTableViewVisibility(to state: Bool) {
        startTypingLabel.isHidden = state
        resultsTableView.isHidden = !state
    }
    
    private func getSearchArea() -> SearchArea {
        switch segmentControl.selectedSegmentIndex {
        case 0:
            return SearchArea.IMDB
        
        default:
            return SearchArea.local
        }
    }
    
    private func searchMovies(expression: String) {
        switch getSearchArea() {
        case .IMDB:
            if previousExpression != expression {
                interactor.cancelCurrentTask(expression: previousExpression) { [weak self] in
                    self?.interactor.searchMoviesIMDB(expression: expression)
                }  
            }
        
        case .local:
            // TODO: add core data
            print("Don't forget core data \(expression)")
        }
    }
    
    @objc private func changeSearchSource(_ sender: UISegmentedControl!) {
        switch sender.selectedSegmentIndex {
        case 0:
            print("IMDB")
            
        case 1:
            print("Backend")
            
        default:
            break
        }
    }
    
    @objc private func textFieldDidChange() {
        if let text = textField.text,
           !text.isEmpty {
            searchMovies(expression: text)
            previousExpression = text
            changeTableViewVisibility(to: true)
        } else {
            if getSearchArea() == .IMDB {
                interactor.cancelAllTasks()
            }
            previousExpression = ""
            changeTableViewVisibility(to: false)
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

extension SearchViewController: SearchViewControllerProtocol {
    
    func displayMovies(movies: [MovieData]) {
        resultsTableView.moviesData = movies
    }
}

extension SearchViewController {
    
    private func makeSegmentControl() -> UISegmentedControl {
        let controll = UISegmentedControl(items: [Text.SearchScreen.imdb, Text.SearchScreen.collection])
        controll.selectedSegmentIndex = 0
        controll.backgroundColor = Asset.Colors.grayTransperent.color
        controll.tintColor = .white
        controll.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 15),
                                         .foregroundColor: UIColor.black],
                                        for: .normal)
        controll.setTitleTextAttributes([.font: UIFont.boldSystemFont(ofSize: 15),
                                         .foregroundColor: UIColor.black],
                                        for: .selected)
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
}

extension SearchViewController {
    
    private func setConstraints() {
        setSegmentControlConstratints()
        setTextFieldConstratints()
        setStartTypingLabelConstratints()
        setTableViewConstratints()
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
        startTypingLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(view.layoutMarginsGuide)
            maker.top.equalTo(textField.snp.bottom).offset(SearchScreenSizes.StartTypingLabel.topOffset)
            maker.height.equalTo(SearchScreenSizes.StartTypingLabel.height)
        }
    }
    
    private func setTableViewConstratints() {
        resultsTableView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.top.equalTo(textField.snp.bottom).offset(SearchScreenSizes.TextField.topOffset)
            maker.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
