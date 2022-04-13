//
//  LoginViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/12/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import SnapKit

class LoginViewController: BaseViewController {
    
    private lazy var watchLaterLogoImageView = makeWatchLaterLogoImageView()
    private lazy var fieldsView = LoginFieldsView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.primaryBackground.color
        view.addSubview(watchLaterLogoImageView)
        view.addSubview(fieldsView)
        setGestures()
        setConstraints()
    }
    
    private func setGestures() {
        let hideKeyboardGuesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard(_:)))
        hideKeyboardGuesture.cancelsTouchesInView = false
        view.addGestureRecognizer(hideKeyboardGuesture)
    }
    
    @objc private func hideKeyboard(_ guestureRecognizer: UIGestureRecognizer) {
        fieldsView.hideKeyboard()
    }
}

// MARK: Extension for element creation
extension LoginViewController {
    
    private func makeWatchLaterLogoImageView() -> UIImageView {
        let imageView = UIImageView(image: Asset.watchLaterLogoFull.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
}

// MARK: Constraints
extension LoginViewController {
    
    private func setConstraints() {
        setWatchLaterLogoConstraints()
        setFieldsViewConstraints()
    }
    
    private func setWatchLaterLogoConstraints() {
        watchLaterLogoImageView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().inset(LoginScreenSizes.WatchLaterLogo.topOffset)
            maker.width.equalTo(LoginScreenSizes.WatchLaterLogo.width)
            maker.height.equalTo(LoginScreenSizes.WatchLaterLogo.height)
        }
    }
    
    private func setFieldsViewConstraints() {
        fieldsView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(watchLaterLogoImageView).inset(LoginScreenSizes.FieldsView.topOffset)
            maker.width.equalTo(LoginScreenSizes.FieldsView.width)
            maker.height.equalTo(LoginScreenSizes.FieldsView.height)
        }
    }
}
