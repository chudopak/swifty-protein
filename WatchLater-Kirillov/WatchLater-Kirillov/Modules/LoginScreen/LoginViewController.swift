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
    private lazy var emailTextField = makeTextField(placeholderString: Text.Authorization.Placeholder.email)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.primaryBackground.color
        view.addSubview(watchLaterLogoImageView)
        view.addSubview(emailTextField)
        setConstraints()
    }
}

// MARK: Extension for element creation
extension LoginViewController {
    
    private func makeWatchLaterLogoImageView() -> UIImageView {
        let imageView = UIImageView(image: Asset.watchLaterLogoFull.image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }
    
    private func makeTextField(placeholderString: String, bottomBoarderHeight: CGFloat = 0.5) -> UITextField {
        let textField = UITextField()
        textField.addBottomBoarder(color: Asset.Colors.textFieldBoarderColor.color, height: bottomBoarderHeight)
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholderString,
            attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.loginPlaceholderTextColor.color])
        textField.textAlignment = .center
        textField.autocapitalizationType = .none
        textField.textColor = Asset.Colors.loginTextColor.color
        return textField
    }
}

// MARK: Constraints
extension LoginViewController {
    
    private func setConstraints() {
        setWatchLaterLogoConstraints()
        setEmailTextFieldConstraints()
    }
    
    private func setWatchLaterLogoConstraints() {
        watchLaterLogoImageView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().inset(LoginScreenSizes.WatchLaterLogo.topOffset)
            maker.width.equalTo(LoginScreenSizes.WatchLaterLogo.width)
            maker.height.equalTo(LoginScreenSizes.WatchLaterLogo.height)
        }
    }
    
    private func setEmailTextFieldConstraints() {
        emailTextField.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(watchLaterLogoImageView).inset(LoginScreenSizes.EmailField.topOffset)
            maker.width.equalTo(LoginScreenSizes.EmailField.width)
            maker.height.equalTo(LoginScreenSizes.EmailField.height)
        }
    }
}
