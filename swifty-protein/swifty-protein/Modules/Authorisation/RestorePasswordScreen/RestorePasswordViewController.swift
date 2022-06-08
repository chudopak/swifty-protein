//
//  RestorePasswordViewController.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/8/22.
//

import UIKit

protocol RestorePasswordViewControllerProtocol: AnyObject {
}

final class RestorePasswordViewController: UIViewController {
    
    private var presenter: RestorePasswordPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.primaryBackground.color
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    func setupComponents(presenter: RestorePasswordPresenterProtocol) {
        self.presenter = presenter
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
        navigationController?.navigationBar.isHidden = false
        let imageView = UIImageView(image: Asset.moleculePurpleOrange.image)
        imageView.contentMode = .scaleAspectFit
        let titleView = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: NavigationBarTitleView.width,
                height: NavigationBarTitleView.height
            )
        )
        imageView.frame = titleView.bounds
        titleView.addSubview(imageView)
        navigationItem.titleView = titleView
    }
}

extension RestorePasswordViewController: RestorePasswordViewControllerProtocol {
}
