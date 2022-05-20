//
//  EditProfileViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

class EditProfileViewController: BaseViewController {
    
    private var router: EditProfileRouter!
    
    private lazy var saveChangesButton = makeSaveChangesButtonItem()
    private lazy var backBarButton = makeBackButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationController()
    }
    
    func setupComponents(router: EditProfileRouter) {
        self.router = router
    }
    
    private func setView() {
        title = Text.TabBar.profile
        view.backgroundColor = Asset.Colors.primaryBackground.color
    }
    
    private func setNavigationController() {
        navigationItem.leftBarButtonItem = backBarButton
        navigationItem.rightBarButtonItem = saveChangesButton
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = UIImageView(image: Asset.logoShort.image)
    }
    
    @objc private func saveChanges() {
        print("Saving Changes")
    }
    
    @objc private func getBackToPreviousScreen() {
        router.getBackToPreviousScreen(navigationController: navigationController!)
    }
}

extension EditProfileViewController {
    
    private func makeSaveChangesButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setTitle(Text.Common.dave, for: .normal)
        button.setTitleColor(Asset.Colors.deepBlue.color, for: .normal)
        button.addTarget(self, action: #selector(saveChanges), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
    
    private func makeBackButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setImage(Asset.arrow.image, for: .normal)
        button.addTarget(self, action: #selector(getBackToPreviousScreen), for: .touchUpInside)
        return UIBarButtonItem(customView: button)
    }
}
