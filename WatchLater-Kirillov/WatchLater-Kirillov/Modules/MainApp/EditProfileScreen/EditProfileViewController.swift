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
    
    private lazy var emptyView = makeEmptyViewForUntouchebleNavBar()
    private lazy var scrollView = makeScrollView()
    private lazy var uploadPhotoButton = makeUploadPhotoButton()
    private lazy var uploadPhotoLabel = makeUploadPhotoLabel()
    private lazy var uploadImageView = makeUploadImageView()
    private lazy var profileImageView = makeProfileImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setConstraints()
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
        view.addSubview(emptyView)
        view.addSubview(scrollView)
        scrollView.addSubview(uploadPhotoButton)
        uploadPhotoButton.addSubview(uploadPhotoLabel)
        uploadPhotoButton.addSubview(uploadImageView)
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
    
    @objc private func uploadProfileImage() {
        print("Uploading Changes")
        pickPhoto()
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate,
                                     UINavigationControllerDelegate {
    
    func choosePhotoFromLibrary() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func takeNewPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        profileImageView.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func pickPhoto() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            showPhotoMenu()
        } else {
            choosePhotoFromLibrary()
        }
    }
    
    func showPhotoMenu() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = Asset.Colors.deepBlue.color

        let actCancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(actCancel)
        
        let actPhoto = UIAlertAction(title: "Take Photo", style: .default, handler: { _ in
            self.takeNewPhoto()
        })
        
        alert.addAction(actPhoto)
        
        let actLibrary = UIAlertAction(title: "Chose From Library", style: .default, handler: { _ in
            self.choosePhotoFromLibrary()
        })
        
        alert.addAction(actLibrary)
        present(alert, animated: true, completion: nil)
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
    
    private func makeUploadPhotoButton() -> UIButton {
        let button = UIButton()
        button.backgroundColor = Asset.Colors.grayTransperent.color
        button.layer.cornerRadius = EditProfileScreenSize.UploadPhotoButton.cornerRadius
        button.addTarget(self, action: #selector(uploadProfileImage), for: .touchUpInside)
        return button
    }
    
    private func makeUploadPhotoLabel() -> UILabel {
        let label = UILabel()
        label.textColor = Asset.Colors.grayTextHalfTranparent.color
        label.text = Text.Common.uploadPhoto
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: EditProfileScreenSize.UploadPhotoButton.labelFontSize)
        label.textAlignment = .center
        return label
    }
    
    private func makeUploadImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = Asset.uploadSymbol.image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    private func makeProfileImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.isUserInteractionEnabled = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }
}

extension EditProfileViewController {
    
    private func setConstraints() {
        setEmptyViewConstraints()
        setScrollViewConstraint()
        setUploadButtonConstraints()
        setUploadPhotoLabelConstraints()
        setUploadImageViewConstraints()
        scrollView.snp.makeConstraints { maker in
            maker.bottom.equalTo(uploadPhotoButton)
                        .offset(EditProfileScreenSize.scrollViewButtonOffset)
        }
    }
    
    private func setEmptyViewConstraints() {
        emptyView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(EditProfileScreenSize.emtyViewHeight)
        }
    }
    
    private func setScrollViewConstraint() {
        scrollView.snp.remakeConstraints { maker in
            maker.top.equalTo(emptyView.snp.bottom)
            maker.bottom.equalTo(view.safeAreaLayoutGuide)
            maker.leading.trailing.equalTo(view.layoutMarginsGuide)
        }
    }
    
    private func setUploadButtonConstraints() {
        uploadPhotoButton.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().inset(EditProfileScreenSize.UploadPhotoButton.topOffset)
            maker.height.equalTo(EditProfileScreenSize.UploadPhotoButton.height)
            maker.width.equalTo(EditProfileScreenSize.UploadPhotoButton.width)
        }
    }
    
    private func setUploadPhotoLabelConstraints() {
        uploadPhotoLabel.snp.makeConstraints { maker in
            maker.height.equalTo(EditProfileScreenSize.UploadPhotoButton.labelHeight)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalToSuperview().inset(EditProfileScreenSize.UploadPhotoButton.labelBottomOffset)
        }
    }
    
    private func setUploadImageViewConstraints() {
        uploadImageView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(EditProfileScreenSize.UploadPhotoButton.imageTopOffset)
            maker.centerX.equalToSuperview()
            maker.height.equalTo(EditProfileScreenSize.UploadPhotoButton.uploadImageHeight)
            maker.width.equalTo(EditProfileScreenSize.UploadPhotoButton.uploadImageWidth)
        }
    }
}
