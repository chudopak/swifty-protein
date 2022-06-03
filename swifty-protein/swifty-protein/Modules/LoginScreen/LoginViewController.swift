//
//  LoginViewController.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/3/22.
//

import UIKit

protocol LoginViewControllerFirstLaunchDelegate: AnyObject {
}

final class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.primaryBackground.color
    }
}
