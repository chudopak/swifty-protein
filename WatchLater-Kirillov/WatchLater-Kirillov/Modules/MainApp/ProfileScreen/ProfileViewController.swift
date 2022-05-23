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
    
    private var isFirstLaunch: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
//        FirstLaunchChecker.isFirstProfileLaunch = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationController()
        setImageView(loading: true)
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
    
    @objc private func presentEditProfileScreen() {
        router.presentEditProfileScreen(navigationController: navigationController!,
                                        userInfo: userInfo)
    }
}

extension ProfileViewController: ProfileViewControllerProtocol {
    
    func showUserInfo(userInfo: UserInfo) {
        setImageView(loading: false, noPhoto: false)
        self.userInfo = userInfo
        print(userInfo.genres, userInfo.name)
        guard let data = userInfo.photoData,
              let image = UIImage(data: data)
        else {
            // TODO: SHOW NO IMAGE
            print("NoDATA")
            profileImageView.image = nil
            setImageView(noPhoto: true)
            return
        }
        profileImageView.image = image
    }
    
    func openEditScreen() {
        setImageView(loading: false)
        router.presentEditProfileScreen(navigationController: navigationController!,
                                        userInfo: userInfo)
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
        label.textColor = Asset.Colors.grayTransperent.color
        return label
    }
}

extension ProfileViewController {
    
    private func setConstraints() {
        setEmptyViewConstraints()
        setScrollViewConstraint()
        setProfileImageViewConstraints()
        setSpinnerConstraints()
        setNoPhotoLabelConstraints()
        scrollView.snp.makeConstraints { maker in
            maker.bottom.equalTo(profileImageView).offset(ProfileScreenSizes.scrollViewBottomOffset)
        }
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
}
