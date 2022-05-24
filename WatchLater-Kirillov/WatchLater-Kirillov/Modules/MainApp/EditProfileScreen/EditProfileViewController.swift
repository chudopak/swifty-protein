//
//  EditProfileViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

protocol EditProfileViewControllerProtocol: AnyObject {
    func successfulUploadData(info: UserInfo?)
    func setUserProfilePicture(image: UIImage)
}

class EditProfileViewController: BaseViewController {
    
    private var userProfileInfo: UserInfo?
    
    private var router: EditProfileRouter!
    private var interactor: EditProfileInteractorProtocol!
    
    private lazy var saveChangesButton = makeSaveChangesButtonItem()
    private lazy var backBarButton = makeBackButtonItem()
    
    private lazy var emptyView = makeEmptyViewForUntouchebleNavBar()
    private lazy var scrollView = makeScrollView()
    private lazy var uploadPhotoButton = makeUploadPhotoButton()
    private lazy var uploadPhotoLabel = makeUploadPhotoLabel()
    private lazy var uploadImageView = makeUploadImageView()
    private lazy var profileImageView = makeProfileImageView()
    private lazy var deleteProfileImageButton = makeDeleteProfileImageButton()
    private lazy var nameTextField = makeNameTextField()
    private lazy var aboutTextField = makeAboutTextField()
    private lazy var favoriteGenresTextField = makeFavoriteGenresTextField()
    
    private var isKeyboardUp = false
    
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
        setUserInfo()
    }
    
    func setUserInfo(info: UserInfo?) {
        userProfileInfo = info
    }
    
    func setupComponents(router: EditProfileRouter,
                         interactor: EditProfileInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
    
    private func setView() {
        title = Text.TabBar.profile
        view.backgroundColor = Asset.Colors.primaryBackground.color
        view.addSubview(emptyView)
        view.addSubview(scrollView)
        scrollView.addSubview(uploadPhotoButton)
        uploadPhotoButton.addSubview(uploadPhotoLabel)
        uploadPhotoButton.addSubview(uploadImageView)
        scrollView.addSubview(profileImageView)
        profileImageView.addSubview(deleteProfileImageButton)
        makeVisible(uploadButton: true)
        scrollView.addSubview(nameTextField)
        scrollView.addSubview(aboutTextField)
        scrollView.addSubview(favoriteGenresTextField)
    }
    
    private func setNavigationController() {
        navigationItem.leftBarButtonItem = backBarButton
        navigationController!.navigationBar.prefersLargeTitles = true
        navigationItem.titleView = UIImageView(image: Asset.logoShort.image)
    }
    
    private func setGestures() {
        let hideKeyboardGuesture = UITapGestureRecognizer(target: self,
                                                          action: #selector(hideKeyboard))
        hideKeyboardGuesture.cancelsTouchesInView = false
        view.addGestureRecognizer(hideKeyboardGuesture)
    }
    
    private func setUserInfo() {
        nameTextField.text = userProfileInfo?.name
        aboutTextField.text = userProfileInfo?.description
        favoriteGenresTextField.text = convertGenresToString(genres: userProfileInfo?.genres ?? [String]())
        guard let data = userProfileInfo?.photoData,
              let image = UIImage(data: data)
        else {
            return
        }
        profileImageView.image = image
        makeVisible(profileImageView: true)
    }
    
    private func makeVisible(profileImageView imageView: Bool = false,
                             uploadButton: Bool = false) {
        profileImageView.isHidden = !imageView
        uploadPhotoButton.isHidden = !uploadButton
        uploadImageView.isHidden = !uploadButton
        uploadPhotoLabel.isHidden = !uploadButton
    }
    
    private func showSaveButton() {
        if navigationItem.rightBarButtonItem == nil {
            navigationItem.rightBarButtonItem = saveChangesButton
        }
    }
    
    private func getUserInfo() -> UserInfo {
        let name = nameTextField.text ?? ""
        let about = aboutTextField.text ?? ""
        let genres = (favoriteGenresTextField.text ?? "").components(separatedBy: ",")
        var trimmedGenres = [String]()
        trimmedGenres.reserveCapacity(genres.count)
        for genre in genres {
            let item = genre.trimmingCharacters(in: .whitespaces)
            if !item.isEmpty {
                trimmedGenres.append(item)
            }
        }
        print(trimmedGenres)
        let info = UserInfo(id: 0, name: name, description: about, genres: trimmedGenres, photoId: "", photoData: profileImageView.image?.jpegData(compressionQuality: 1))
        return info
    }
    
    private func convertGenresToString(genres: [String]) -> String {
        var genresStr: String = ""
        for i in 0..<genres.count {
            if i == genres.count - 1 {
                genresStr += genres[i]
            } else {
                genresStr += genres[i] + ", "
            }
        }
        return genresStr
    }
    
    @objc private func hideKeyboard() {
        if nameTextField.isEditing {
            nameTextField.resignFirstResponder()
        } else if aboutTextField.isEditing {
            aboutTextField.resignFirstResponder()
        } else if favoriteGenresTextField.isEditing {
            favoriteGenresTextField.resignFirstResponder()
        }
    }
    
    @objc private func saveChanges() {
        print("Saving Changes")
        interactor.saveAllChanges(userInfo: getUserInfo())
    }
    
    @objc private func getBackToPreviousScreen() {
        if userProfileInfo != nil {
            router.getBackToPreviousScreen(navigationController: navigationController!)
        }
    }
    
    @objc private func uploadProfileImage() {
        print("Uploading Changes")
        pickPhoto()
    }
    
    @objc private func clearImage() {
        profileImageView.image = nil
        makeVisible(uploadButton: true)
        showSaveButton()
    }
    
    @objc private func nameDoneButtonPressed() {
        nameTextField.resignFirstResponder()
        if aboutTextField.text == nil
            || aboutTextField.text!.isEmpty {
            aboutTextField.becomeFirstResponder()
        }
    }
    
    @objc private func aboutDoneButtonPressed() {
        aboutTextField.resignFirstResponder()
        if favoriteGenresTextField.text == nil
            || favoriteGenresTextField.text!.isEmpty {
            favoriteGenresTextField.becomeFirstResponder()
        }
    }
    
    @objc private func favoriteGenresDoneButtonPressed() {
        favoriteGenresTextField.resignFirstResponder()
        if nameTextField.text == nil
            || nameTextField.text!.isEmpty {
            nameTextField.becomeFirstResponder()
        }
    }
    
    @objc private func textFieldDidChange() {
        showSaveButton()
    }
}

extension EditProfileViewController {
    
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
            setScrollViewConstraint()
            isKeyboardUp = false
        }
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
        makeVisible(profileImageView: true)
        showSaveButton()
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
        let alert = UIAlertController(
            title: nil,
            message: nil,
            preferredStyle: .actionSheet
        )
        alert.view.tintColor = Asset.Colors.deepBlue.color
        let actCancel = UIAlertAction(
            title: Text.Common.cancel,
            style: .cancel,
            handler: nil
        )
        alert.addAction(actCancel)
        
        let actPhoto = UIAlertAction(
            title: Text.Common.takeAPicture,
            style: .default
        ) { _ in
            self.takeNewPhoto()
        }
        alert.addAction(actPhoto)
        let actLibrary = UIAlertAction(
            title: Text.Common.library,
            style: .default
        ) { _ in
            self.choosePhotoFromLibrary()
        }
        
        alert.addAction(actLibrary)
        present(alert, animated: true, completion: nil)
    }
}

extension EditProfileViewController: EditProfileViewControllerProtocol {

    func successfulUploadData(info: UserInfo?) {
        userProfileInfo = info
        if let userInfo = userProfileInfo {
            nameTextField.text = userInfo.name
            aboutTextField.text = userInfo.description
            favoriteGenresTextField.text = convertGenresToString(genres: userInfo.genres)
        }
        hideKeyboard()
        SaveAnimateView.hud(inView: navigationController!.view,
                            image: Asset.checkmarkWhite.image,
                            text: Text.Common.saved,
                            animated: true)
    }
    
    func setUserProfilePicture(image: UIImage) {
        profileImageView.image = image
        makeVisible(profileImageView: true)
    }
}

extension EditProfileViewController {
    
    private func makeSaveChangesButtonItem() -> UIBarButtonItem {
        let button = UIButton()
        button.setTitle(Text.Common.save, for: .normal)
        button.setTitleColor(Asset.Colors.deepBlue.color, for: .normal)
        button.setTitleColor(Asset.Colors.deepBlueHalfTransparent.color, for: .highlighted)
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
        imageView.contentMode = .scaleToFill
        imageView.backgroundColor = .red
        return imageView
    }
    
    private func makeDeleteProfileImageButton() -> BaseBorderButton {
        let colorSet = BaseBorderButton.ColorSet(
            enabledText: .white,
            enabledBackground: Asset.Colors.deepBlue.color,
            enabledBorder: .white,
            disabledText: .white,
            disabledBackground: Asset.Colors.deepBlue.color,
            disabledBorder: .white
        )
        let button = BaseBorderButton(
            colorSet: colorSet,
            text: "",
            fontSize: DetailsScreenSizes.buttonsFontSize
        )
        button.isEnabled = true
        button.layer.cornerRadius = EditProfileScreenSize.ProfileImage.buttonHeight / 2
        button.layer.borderWidth = EditProfileScreenSize.ProfileImage.borderWidth
        button.setImage(Asset.xMarkCircle.image, for: .normal)
        button.addTarget(self, action: #selector(clearImage), for: .touchUpInside)
        return button
    }
    
    private func makeNameTextField() -> BaseTextField {
        let textField = makeTextField(placeholder: Text.Common.name,
                                      autoCapitalisatioinType: .words)
        textField.addTarget(self, action: #selector(nameDoneButtonPressed), for: .editingDidEndOnExit)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }
    
    private func makeAboutTextField() -> BaseTextField {
        let textField = makeTextField(placeholder: Text.Common.aboutYourself,
                                      autoCapitalisatioinType: .none)
        textField.addTarget(self, action: #selector(aboutDoneButtonPressed), for: .editingDidEndOnExit)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }
    
    private func makeFavoriteGenresTextField() -> BaseTextField {
        let textField = makeTextField(placeholder: Text.Common.favoriteGenres,
                                      autoCapitalisatioinType: .words)
        textField.addTarget(self, action: #selector(favoriteGenresDoneButtonPressed), for: .editingDidEndOnExit)
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        return textField
    }
    
    private func makeTextField(
        placeholder: String,
        autoCapitalisatioinType: UITextAutocapitalizationType
    ) -> BaseTextField {
        let inset = UIEdgeInsets(
            top: EditProfileScreenSize.TextField.textRectangleTopOffset,
            left: EditProfileScreenSize.TextField.textRectangleSideOffset,
            bottom: EditProfileScreenSize.TextField.textRectangleTopOffset,
            right: EditProfileScreenSize.TextField.textRectangleSideOffset
        )
        let textField = BaseTextField(inset: inset)
        textField.textAlignment = .left
        textField.autocapitalizationType = autoCapitalisatioinType
        textField.textColor = Asset.Colors.loginTextColor.color
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.keyboardType = .default
        textField.textContentType = .none
        textField.addBottomBoarder(
            color: Asset.Colors.textFieldBoarderColor.color,
            height: EditProfileScreenSize.TextField.bottomBoarderLineHeight,
            sideOffset: EditProfileScreenSize.TextField.textRectangleSideOffset
        )
        textField.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: Asset.Colors.loginPlaceholderTextColor.color]
        )
        return textField
    }
}

extension EditProfileViewController {
    
    private func setConstraints() {
        setEmptyViewConstraints()
        setScrollViewConstraint()
        setUploadButtonConstraints()
        setUploadPhotoLabelConstraints()
        setUploadImageViewConstraints()
        setProfileImageViewConstraitns()
        setDeleteImageButtonConstraints()
        setNameTextFieldConstraints()
        setAboutTextFieldConstraints()
        setFavoriteGenresTextFieldConstraints()
        scrollView.snp.makeConstraints { maker in
            maker.bottom.equalTo(favoriteGenresTextField)
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
            maker.leading.trailing.equalToSuperview()
        }
    }
    
    private func setScrollViewKeyboardUpConstraint(keyboardHeight: CGFloat) {
        scrollView.snp.remakeConstraints { maker in
            maker.top.equalTo(emptyView.snp.bottom)
            maker.bottom.equalTo(view).inset(keyboardHeight)
            maker.leading.trailing.equalToSuperview()
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
    
    private func setProfileImageViewConstraitns() {
        profileImageView.snp.makeConstraints { maker in
            maker.width.equalTo(EditProfileScreenSize.ProfileImage.imageWidth)
            maker.height.equalTo(EditProfileScreenSize.ProfileImage.imageHeight)
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().inset(EditProfileScreenSize.ProfileImage.imageTopOffset)
        }
    }
    
    private func setDeleteImageButtonConstraints() {
        deleteProfileImageButton.snp.makeConstraints { maker in
            maker.width.equalTo(EditProfileScreenSize.ProfileImage.buttonWidth)
            maker.height.equalTo(EditProfileScreenSize.ProfileImage.buttonHeight)
            maker.top.equalToSuperview().inset(EditProfileScreenSize.ProfileImage.buttonTopOffset)
            maker.trailing.equalToSuperview().inset(EditProfileScreenSize.ProfileImage.buttonRightOffset)
        }
    }
    
    private func setNameTextFieldConstraints() {
        nameTextField.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(view)
            maker.height.equalTo(EditProfileScreenSize.TextField.height)
            maker.top.equalTo(uploadPhotoButton.snp.bottom).offset(EditProfileScreenSize.TextField.topOffset)
        }
    }
    
    private func setAboutTextFieldConstraints() {
        aboutTextField.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(view)
            maker.height.equalTo(EditProfileScreenSize.TextField.height)
            maker.top.equalTo(nameTextField.snp.bottom)
        }
    }
    
    private func setFavoriteGenresTextFieldConstraints() {
        favoriteGenresTextField.snp.makeConstraints { maker in
            maker.leading.trailing.equalTo(view)
            maker.height.equalTo(EditProfileScreenSize.TextField.height)
            maker.top.equalTo(aboutTextField.snp.bottom)
        }
    }
}
