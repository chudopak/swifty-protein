//
//  ProfileViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol ProfileViewControllerProtocol: AnyObject {
    func showUserInfo(userInfo: UserInfo)
    func openEditScreen()
    func changeProfileImage(imageData: (id: String, image: UIImage))
}

class ProfileViewController: BaseViewController {
    
    private var userInfo: UserInfo?
    private var router: ProfileRouter!
    private var interactor: ProfileInteractorProtocol!

    private lazy var editProfileScreenButton = makeEditProfileScreenButtonItem()
    private lazy var emptyView = makeEmptyViewForUntouchebleNavBar()
    private lazy var scrollView = makeScrollView()
    private lazy var profileImageView = makeProfileImageView()
    private lazy var spinner = makeActivityIndicator()
    private lazy var noPhotoLabel = makeNoPhotoLabel()
    private lazy var nameLabel = makeNameLabel()
    private lazy var descriptionLabel = makeDescriptionLabel()
    private lazy var favoriteGenresLabel = makeFavoutireGanresLabel()
    
    private lazy var genresStackViews = [UIStackView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationController()
        if profileImageView.image == nil {
            setImageView(loading: true)
        }
        if FirstLaunchChecker.isFirstProfileLaunch {
            router.presentEditProfileScreen(navigationController: navigationController!,
                                            userInfo: userInfo)
            FirstLaunchChecker.isFirstProfileLaunch = false
        } else {
            interactor.fetchUserInfo()
        }
    }
    
    func setupComponents(router: ProfileRouter, interactor: ProfileInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    private func setView() {
        view.backgroundColor = Asset.Colors.primaryBackground.color
        view.addSubview(emptyView)
        view.addSubview(scrollView)
        scrollView.addSubview(profileImageView)
        profileImageView.addSubview(spinner)
        profileImageView.addSubview(noPhotoLabel)
        scrollView.addSubview(nameLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(favoriteGenresLabel)
    }
    
    private func setNavigationController() {
        navigationItem.rightBarButtonItem = editProfileScreenButton
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = UIImageView(image: Asset.logoShort.image)
    }
    
    private func setImageView(loading: Bool = false, noPhoto: Bool = false) {
        spinner.isHidden = !loading
        noPhotoLabel.isHidden = !noPhoto
        if loading {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }
    
    private func getTextViewHeight(description: String) -> CGFloat {
        let textView = UITextView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: DetailsScreenSizes.TextView.width,
                height: CGFloat.greatestFiniteMagnitude
            )
        )
        textView.text = description
        textView.font = .systemFont(ofSize: DetailsScreenSizes.TextView.fontSize)
        textView.sizeToFit()
        return (textView.frame.height)
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
    
    private func createGenresStackViews(genres: [String]) {
        var i = 0
        var currentStackViewWidth: CGFloat = 0
        var labels = [UILabel]()
        labels.reserveCapacity(5)
        while i < genres.count {
            let label = createGenreLabel(genreTitle: genres[i])
            if currentStackViewWidth + label.bounds.size.width < ProfileScreenSizes.Genres.maxWidth {
                currentStackViewWidth += label.bounds.size.width + ProfileScreenSizes.Genres.labelSpace
                labels.append(label)
            } else {
                let stack = makeStackView(views: labels,
                                          viewsSpacing: ProfileScreenSizes.Genres.labelSpace)
                scrollView.addSubview(stack)
                currentStackViewWidth = 0
                genresStackViews.append(stack)
                labels.removeAll()
                currentStackViewWidth += label.bounds.size.width + ProfileScreenSizes.Genres.labelSpace
                labels.append(label)
            }
            i += 1
        }
        if !labels.isEmpty {
            let stack = makeStackView(views: labels,
                                      viewsSpacing: ProfileScreenSizes.Genres.labelSpace)
            scrollView.addSubview(stack)
            genresStackViews.append(stack)
        }
        setStackConstraints()
    }
    
    private func setEmpyGenresStack() {
        let label = makeNoGenresLabel()
        let stack = makeStackView(views: [label],
                                  viewsSpacing: ProfileScreenSizes.Genres.labelSpace)
        scrollView.addSubview(stack)
        genresStackViews.append(stack)
        setStackConstraints()
    }
    
    @objc private func presentEditProfileScreen() {
        router.presentEditProfileScreen(navigationController: navigationController!,
                                        userInfo: userInfo)
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    
    func showUserInfo(userInfo: UserInfo) {
        setImageView(loading: false, noPhoto: false)
        print(userInfo.genres, userInfo.name)
        if let data = userInfo.photoData,
           let image = UIImage(data: data) {
            profileImageView.image = image
        } else {
            profileImageView.image = nil
            setImageView(noPhoto: true)
        }
        nameLabel.text = userInfo.name
        setDescription(about: userInfo.description)
        createGenresLabels(userInfo: userInfo)
        setScrollViewButtonConstraint()
        self.userInfo = userInfo
    }
    
    func openEditScreen() {
        setImageView(loading: false)
        router.presentEditProfileScreen(navigationController: navigationController!,
                                        userInfo: userInfo)
    }
    
    func changeProfileImage(imageData: (id: String, image: UIImage)) {
        userInfo?.photoId = imageData.id
        userInfo?.photoData = imageData.image.jpegData(compressionQuality: 1)
        profileImageView.image = imageData.image
        setImageView(loading: false, noPhoto: false)
    }
    
    private func createGenresLabels(userInfo: UserInfo) {
        if !optionalsAreEqual(firstVal: self.userInfo?.genres, secondVal: userInfo.genres) {
            removeGenresStackViews()
            if userInfo.genres.count == 1
                && userInfo.genres[0].isEmpty {
                setEmpyGenresStack()
            } else {
                createGenresStackViews(genres: userInfo.genres)
            }
        }
    }
    
    private func setDescription(about: String) {
        let description = about.count < ProfileScreenSizes.Description.maxCharacter
                            ? about
                            : String(about.prefix(ProfileScreenSizes.Description.maxCharacter)) + "..."
        if self.userInfo?.description == nil
            || self.userInfo!.description != description {
            descriptionLabel.text = description
            descriptionLabel.snp.updateConstraints { maker in
                maker.height.equalTo(getTextViewHeight(description: description))
            }
        }
    }
}

extension ProfileViewController {
    
    private func makeEditProfileScreenButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(Asset.editFilmInfo.image, for: .normal)
        button.addTarget(self, action: #selector(presentEditProfileScreen), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    private func makeEmptyViewForUntouchebleNavBar() -> UIView {
        let view = UIView()
        return view
    }
    
    private func makeScrollView() -> UIScrollView {
        let view = UIScrollView()
        view.backgroundColor = .clear
        view.isScrollEnabled = true
        return view
    }
    
    private func makeProfileImageView() -> UIImageView {
        let image = UIImageView()
        image.backgroundColor = Asset.Colors.grayTransperent.color
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.layer.cornerRadius = ProfileScreenSizes.Picture.cornerRadius
        return image
    }
    
    private func makeActivityIndicator() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.style = .white
        spinner.color = .black
        return spinner
    }
    
    private func makeNoPhotoLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: ProfileScreenSizes.Picture.labelFontSize)
        label.numberOfLines = 2
        label.text = Text.Common.noImage
        label.textAlignment = .center
        label.textColor = Asset.Colors.grayTextHalfTranparent.color
        return label
    }
    
    private func makeNameLabel() -> UILabel {
        let label = UILabel()
        label.numberOfLines = 2
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.font = .boldSystemFont(ofSize: ProfileScreenSizes.Name.fontSize)
        label.textColor = .black
        return label
    }
    
    private func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.text = ""
        label.font = .boldSystemFont(ofSize: ProfileScreenSizes.Description.fontSize)
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.numberOfLines = 0
        return label
    }
    
    private func makeFavoutireGanresLabel() -> UILabel {
        let label = UILabel()
        label.text = Text.Common.favoriteGenres
        label.font = .boldSystemFont(ofSize: ProfileScreenSizes.FavouriteGanresTitle.fontSize)
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .clear
        return label
    }
    
    private func makeNoGenresLabel() -> UILabel {
        let label = UILabel()
        label.text = Text.Common.noFavoriteGenres
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.sizeToFit()
        return label
    }
    
    private func createGenreLabel(genreTitle: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0,
                                          y: 0,
                                          width: CGFloat.greatestFiniteMagnitude,
                                          height: ProfileScreenSizes.Genres.stackHeight))
        label.font = .boldSystemFont(ofSize: ProfileScreenSizes.Genres.labelFontSize)
        label.layer.borderWidth = ProfileScreenSizes.Genres.labelBoardWidth
        label.textColor = .black
        label.layer.cornerRadius = ProfileScreenSizes.Genres.labelCornerRadius
        label.textAlignment = .center
        if genreTitle.count > ProfileScreenSizes.Genres.maxCharsInLabel {
            var text = getPrefix(string: genreTitle,
                                 prefixValue: DetailsScreenSizes.Genres.maxCharsInLabel - 3)
            text += "..."
            label.text = text
        } else {
            label.text = genreTitle
        }
        label.sizeToFit()
        label.bounds.size.width += 2 * ProfileScreenSizes.Genres.labelCornerRadius
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

extension ProfileViewController {
    
    private func setConstraints() {
        setEmptyViewConstraints()
        setScrollViewConstraint()
        setProfileImageViewConstraints()
        setSpinnerConstraints()
        setNoPhotoLabelConstraints()
        setNameLabelConstraints()
        setDescriptionLabelConstraints()
        setFavoriteGenresLabelConstraints()
    }
    
    private func setEmptyViewConstraints() {
        emptyView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(ProfileScreenSizes.emtyViewHeight)
        }
    }
    
    private func setScrollViewConstraint() {
        scrollView.snp.remakeConstraints { maker in
            maker.top.equalTo(emptyView.snp.bottom)
            maker.bottom.equalTo(view.safeAreaLayoutGuide)
            maker.leading.trailing.equalToSuperview()
        }
    }
    
    private func setProfileImageViewConstraints() {
        profileImageView.snp.makeConstraints { maker in
            maker.width.equalTo(ProfileScreenSizes.Picture.width)
            maker.height.equalTo(ProfileScreenSizes.Picture.height)
            maker.top.equalTo(ProfileScreenSizes.Picture.topOffset)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setSpinnerConstraints() {
        spinner.snp.makeConstraints { maker in
            maker.leading.trailing.top.bottom.equalToSuperview()
        }
    }
    
    private func setNoPhotoLabelConstraints() {
        noPhotoLabel.snp.makeConstraints { maker in
            maker.leading.trailing.centerY.equalToSuperview()
            maker.height.equalTo(ProfileScreenSizes.Picture.labelHeight)
        }
    }
    
    private func setNameLabelConstraints() {
        nameLabel.snp.makeConstraints { maker in
            maker.top.equalTo(profileImageView.snp.bottom).offset(ProfileScreenSizes.Name.topOffset)
            maker.height.equalTo(ProfileScreenSizes.Name.height)
            maker.leading.trailing.equalTo(scrollView.layoutMarginsGuide)
        }
    }
    
    private func setDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(nameLabel.snp.bottom).offset(ProfileScreenSizes.Description.topOffset)
            maker.height.equalTo(ProfileScreenSizes.Description.startHeight)
            maker.width.equalTo(ProfileScreenSizes.Description.width)
            maker.centerX.equalToSuperview()
        }
    }
    
    private func setFavoriteGenresLabelConstraints() {
        favoriteGenresLabel.snp.makeConstraints { maker in
            maker.top.equalTo(descriptionLabel.snp.bottom).offset(ProfileScreenSizes.FavouriteGanresTitle.topOffset)
            maker.height.equalTo(ProfileScreenSizes.FavouriteGanresTitle.height)
            maker.width.equalTo(ProfileScreenSizes.FavouriteGanresTitle.width)
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
                    maker.top.equalTo(genresStackViews[i - 1].snp.bottom).offset(ProfileScreenSizes.Genres.stackTopOffset)
                    maker.height.equalTo(ProfileScreenSizes.Genres.stackHeight)
                    maker.centerX.equalToSuperview()
                }
            } else {
                genresStackViews[i].snp.makeConstraints { maker in
                    maker.top.equalTo(favoriteGenresLabel.snp.bottom).offset(ProfileScreenSizes.Genres.stackTopOffset)
                    maker.height.equalTo(ProfileScreenSizes.Genres.stackHeight)
                    maker.centerX.equalToSuperview()
                }
            }
        }
    }
    
    private func setScrollViewButtonConstraint() {
        if let lastStack = genresStackViews.last {
            scrollView.snp.remakeConstraints { maker in
                maker.top.equalTo(emptyView.snp.bottom)
                maker.bottom.equalTo(view.safeAreaLayoutGuide)
                maker.leading.trailing.equalToSuperview()
                maker.bottom.equalTo(lastStack).offset(ProfileScreenSizes.scrollViewBottomOffset)
            }
        } else {
            scrollView.snp.remakeConstraints { maker in
                maker.top.equalTo(emptyView.snp.bottom)
                maker.bottom.equalTo(view.safeAreaLayoutGuide)
                maker.leading.trailing.equalToSuperview()
                maker.bottom.equalTo(favoriteGenresLabel).offset(ProfileScreenSizes.scrollViewBottomOffset)
            }
        }
    }
}
