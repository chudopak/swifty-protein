//
//  KeyboardView.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/3/22.
//

import UIKit
import SnapKit
import LocalAuthentication

protocol KeyboardDelegate: AnyObject {
    func handleKeyboardTap(key: KeyboardView.KeyType)
}

protocol BiometryDelegate: AnyObject {
    func handleBiometry()
}

final class KeyboardView: UIView {
    
    enum KeyType {
        case number(Int)
        case delete
    }
    
    private weak var delegate: KeyboardDelegate!
    weak var biometryDelegate: BiometryDelegate? {
        didSet {
            if biometryDelegate == nil {
                biometryButton.isHidden = true
            } else {
                biometryButton.isHidden = false
            }
        }
    }
    
    private lazy var zero = makeNumberButton(number: 0)
    private lazy var one = makeNumberButton(number: 1)
    private lazy var two = makeNumberButton(number: 2)
    private lazy var three = makeNumberButton(number: 3)
    private lazy var four = makeNumberButton(number: 4)
    private lazy var five = makeNumberButton(number: 5)
    private lazy var six = makeNumberButton(number: 6)
    private lazy var seven = makeNumberButton(number: 7)
    private lazy var eight = makeNumberButton(number: 8)
    private lazy var nine = makeNumberButton(number: 9)
    private lazy var deleteButton = makeDeleteButton()
    private lazy var biometryButton = makeBiometryButton()
    
    init(delegate: KeyboardDelegate) {
        super.init(frame: .zero)
        self.delegate = delegate
        setView()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setView() {
        addSubview(zero)
        addSubview(one)
        addSubview(two)
        addSubview(three)
        addSubview(four)
        addSubview(five)
        addSubview(six)
        addSubview(seven)
        addSubview(eight)
        addSubview(nine)
        addSubview(deleteButton)
        addSubview(biometryButton)
        biometryButton.isHidden = true
    }
    
    private func getBiometryType() -> BiometryType {
        let authContext = LAContext()
        var error: NSError?
       _ = authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
       switch authContext.biometryType {
       case .none:
           return .none

       case .touchID:
           return .touchID

       case .faceID:
           return .faceID

       @unknown default:
           return .none
       }
    }
    
    @objc private func numberButtonTapped(sender: UIButton) {
        delegate.handleKeyboardTap(key: .number(sender.tag))
    }
    
    @objc private func deleteButtonTapped() {
        delegate.handleKeyboardTap(key: .delete)
    }
    
    @objc private func biometryButtonTapped() {
        biometryDelegate?.handleBiometry()
    }
}

// MARK: Creating UI elements

extension KeyboardView {
    
    private func makeNumberButton(number: Int) -> CustomButton {
        let button = CustomButton()
        button.layer.cornerRadius = KeyboardSizes.KeyboardButton.cornerRadius
        button.layer.borderWidth = KeyboardSizes.KeyboardButton.boarderWidth
        button.tag = number
        button.setTitle(String(number), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        button.backgroundColor = .clear
        button.setTitleColor(Asset.textColor.color, for: .normal)
        button.layer.borderColor = Asset.textColor.color.cgColor
        button.addTarget(self, action: #selector(numberButtonTapped(sender:)), for: .touchUpInside)
        return button
    }
    
    private func makeDeleteButton() -> CustomButton {
        let button = CustomButton()
        let image = UIImage(systemName: SFSymbols.deleteLeft)
        button.setImage(image, for: .normal)
        button.tintColor = Asset.textColor.color
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(
            top: KeyboardSizes.DeleteButton.verticalInset,
            left: KeyboardSizes.DeleteButton.horizontalInset,
            bottom: KeyboardSizes.DeleteButton.verticalInset,
            right: KeyboardSizes.DeleteButton.horizontalInset
        )
        button.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        return button
    }
    
    private func makeBiometryButton() -> CustomButton {
        let button = CustomButton()
        switch getBiometryType() {
        case .faceID:
            button.setImage(UIImage(systemName: SFSymbols.faceId), for: .normal)
            
        default:
            button.setImage(UIImage(systemName: SFSymbols.touchId), for: .normal)
        }
        button.tintColor = Asset.textColor.color
        button.imageView?.contentMode = .scaleAspectFit
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.imageEdgeInsets = UIEdgeInsets(
            top: KeyboardSizes.DeleteButton.verticalInset,
            left: KeyboardSizes.DeleteButton.horizontalInset,
            bottom: KeyboardSizes.DeleteButton.verticalInset,
            right: KeyboardSizes.DeleteButton.horizontalInset
        )
        button.addTarget(self, action: #selector(biometryButtonTapped), for: .touchUpInside)
        return button
    }
}

// MARK: Constraints

extension KeyboardView {
    
    private func setConstraints() {
        setLeftButtonConstraints(view: one, topView: self, isFirstRow: true)
        setCenterButtonConstraints(view: two, topView: self, isFirstRow: true)
        setRightButtonConstraints(view: three, topView: self, isFirstRow: true)
        
        setLeftButtonConstraints(view: four, topView: one)
        setCenterButtonConstraints(view: five, topView: two)
        setRightButtonConstraints(view: six, topView: three)
        
        setLeftButtonConstraints(view: seven, topView: four)
        setCenterButtonConstraints(view: eight, topView: five)
        setRightButtonConstraints(view: nine, topView: six)
        
        setCenterButtonConstraints(view: zero, topView: eight)
        setRightButtonConstraints(view: deleteButton, topView: nine)
        setLeftButtonConstraints(view: biometryButton, topView: seven)
    }
    
    private func setLeftButtonConstraints(
        view: UIView,
        topView: UIView,
        isFirstRow: Bool = false
    ) {
        view.snp.makeConstraints { maker in
            maker.height.equalTo(KeyboardSizes.KeyboardButton.height)
            maker.width.equalTo(KeyboardSizes.KeyboardButton.width)
            maker.leading.equalToSuperview()
            if isFirstRow {
                maker.top.equalToSuperview()
            } else {
                maker.top.equalTo(topView.snp.bottom).offset(KeyboardSizes.KeyboardButton.sideOffset)
            }
        }
    }
    
    private func setCenterButtonConstraints(
        view: UIView,
        topView: UIView,
        isFirstRow: Bool = false
    ) {
        view.snp.makeConstraints { maker in
            maker.height.equalTo(KeyboardSizes.KeyboardButton.height)
            maker.width.equalTo(KeyboardSizes.KeyboardButton.width)
            maker.centerX.equalToSuperview()
            if isFirstRow {
                maker.top.equalToSuperview()
            } else {
                maker.top.equalTo(topView.snp.bottom).offset(KeyboardSizes.KeyboardButton.sideOffset)
            }
        }
    }
    
    private func setRightButtonConstraints(
        view: UIView,
        topView: UIView,
        isFirstRow: Bool = false
    ) {
        view.snp.makeConstraints { maker in
            maker.height.equalTo(KeyboardSizes.KeyboardButton.height)
            maker.width.equalTo(KeyboardSizes.KeyboardButton.width)
            maker.trailing.equalToSuperview()
            if isFirstRow {
                maker.top.equalToSuperview()
            } else {
                maker.top.equalTo(topView.snp.bottom).offset(KeyboardSizes.KeyboardButton.sideOffset)
            }
        }
    }
}
