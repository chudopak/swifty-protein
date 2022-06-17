//
//  PopUpView.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/7/22.
//

import UIKit
import SnapKit

final class Popup: UIView {
    
    enum ButtonType {
        case cancel, custom
    }
    
    struct ButtonInfo {
        let title: String
        let type: ButtonType
        let action: (() -> Void)?
        let tag: Int
    }
    
    private lazy var containerView = makeContainerView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var descriptionLabel = makeDescriptionLabel()
    private lazy var blurView = makeBlurView()
    private var buttonsStackView: UIStackView?
    private var separateButtonsLine: UIView?
    
    private var stackViewHeight: CGFloat = 0
    private var popupTitle = ""
    private var popupDescription: String = ""
    private let popupSizes = PopupSizes()
    
    private lazy var buttons = [CustomButton]()
    private lazy var buttonActions = [Int: (() -> Void)?]()
    
    init(title: String, description: String) {
        super.init(frame: UIScreen.main.bounds)
        popupTitle = title
        if description.count > popupSizes.descriptionLabelMaxTextSize {
            popupDescription = String(description.prefix(popupSizes.descriptionLabelMaxTextSize)) + "..."
        } else {
            popupDescription = description
        }
        setView()
        setGestures()
        setBlurViewConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showPopup() {
        animateIn()
    }
    
    func addButton(title: String, type: ButtonType, action: (() -> Void)?) {
        if buttons.count < popupSizes.maxButtons {
            let buttonInfo = ButtonInfo(
                title: title,
                type: type,
                action: action,
                tag: buttons.count
            )
            let button = makeButton(info: buttonInfo)
            setStackView(button: button)
        }
    }
    
    private func setView() {
        addSubview(blurView)
        addSubview(containerView)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.bounds.size.height = titleLabel.bounds.height
            + descriptionLabel.bounds.height
            + popupSizes.titleLabelTopOffset
            + popupSizes.descriptionLabelTopOffset
            + popupSizes.bottomSpace
        containerView.bounds.size.width = popupSizes.width
        containerView.isHidden = true
    }
    
    private func setGestures() {
        let hidePopupGesture = UITapGestureRecognizer(
            target: self,
            action: #selector(hidePopup)
        )
        hidePopupGesture.cancelsTouchesInView = false
        addGestureRecognizer(hidePopupGesture)
    }
    
    private func setStackView(button: CustomButton) {
        if let stackView = buttonsStackView,
           buttons.count == 2 {
            stackView.addArrangedSubview(button)
            calculateStackAndContainerHeight()
        } else if buttonsStackView == nil {
            buttonsStackView = makeStackView(axis: .horizontal)
            separateButtonsLine = makeSeparateButtonsLine()
            containerView.addSubview(buttonsStackView!)
            containerView.addSubview(separateButtonsLine!)
            calculateStackAndContainerHeight()
        } else if buttonsStackView != nil,
                  buttons.count <= popupSizes.maxButtons {
            buttonsStackView?.removeFromSuperview()
            separateButtonsLine?.removeFromSuperview()
            buttonsStackView = makeStackView(axis: .vertical)
            separateButtonsLine = makeSeparateButtonsLine()
            containerView.addSubview(buttonsStackView!)
            containerView.addSubview(separateButtonsLine!)
            calculateStackAndContainerHeight()
        }
    }
    
    private func calculateStackAndContainerHeight() {
        let height: CGFloat = buttons.count > 2
                                    ? CGFloat(buttons.count) * popupSizes.buttonHeight
                                    : popupSizes.buttonHeight
        stackViewHeight = height
        if buttons.count != 2 && !buttons.isEmpty {
            let previousStackHeight = buttons.count - 1 > 2 || buttons.count - 1 == 0
                                        ? CGFloat(buttons.count - 1) * popupSizes.buttonHeight
                                        : popupSizes.buttonHeight
            containerView.bounds.size.height -= previousStackHeight
            containerView.bounds.size.height += height
        }
    }
    
    private func animateOut() {
        let height = bounds.size.height * 0.5 + containerView.bounds.size.height * 0.5
        UIView.animate(
            withDuration: popupSizes.animationDuration,
            delay: popupSizes.animationDelay,
            usingSpringWithDamping: popupSizes.animationSpringDampings,
            initialSpringVelocity: popupSizes.animationSpringVelocity,
            options: .curveEaseIn,
            animations: { [weak self] in
                self?.containerView.transform = CGAffineTransform(translationX: 0, y: -height)
                self?.alpha = 0
            },
            completion: { [weak self] completion in
                if completion {
                    self?.removeFromSuperview()
                }
            }
        )
    }
    
    private func animateIn() {
        setConstraints()
        layoutIfNeeded()
        let height = bounds.size.height * 0.5 + containerView.bounds.size.height * 0.5
        containerView.transform = CGAffineTransform(translationX: 0, y: -height)
        containerView.alpha = 0
        containerView.isHidden = false
        UIView.animate(
            withDuration: popupSizes.animationDuration,
            delay: popupSizes.animationDelay,
            usingSpringWithDamping: popupSizes.animationSpringDampings,
            initialSpringVelocity: popupSizes.animationSpringVelocity,
            options: .curveEaseIn,
            animations: { [weak self] in
                self?.containerView.transform = .identity
                self?.containerView.alpha = 1
            },
            completion: nil
        )
    }
    
    @objc private func hidePopup() {
        if buttons.isEmpty {
            animateOut()
        }
    }
    
    @objc func buttonTapped(sender: UIButton) {
        if let action = buttonActions[sender.tag] {
            action?()
        }
        animateOut()
    }
}

extension Popup {
    
    private func makeBlurView() -> UIVisualEffectView {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        return blurEffectView
    }
    
    private func makeContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = Asset.primaryBackground.color
        view.layer.cornerRadius = popupSizes.cornerRadius
        view.clipsToBounds = true
        return view
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.text = popupTitle
        label.textColor = Asset.textColor.color
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 17)
        label.bounds.size = CGSize(
            width: popupSizes.titleLabelWidth,
            height: popupSizes.titleLabelHeight
        )
        return label
    }
    
    private func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.text = popupDescription
        label.textColor = Asset.textColor.color
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.bounds.size.width = popupSizes.descriptionLabelWidth
        label.sizeToFit()
        return label
    }
    
    private func makeButton(info: ButtonInfo) -> CustomButton {
        let button = CustomButton()
        button.setTitle(info.title, for: .normal)
        switch info.type {
        case .cancel:
            button.titleLabel?.font = .boldSystemFont(ofSize: 17)
            button.setTitleColor(Asset.redFailure.color, for: .normal)

        case .custom:
            button.titleLabel?.font = .systemFont(ofSize: 17)
            button.setTitleColor(Asset.textColor.color, for: .normal)
        }
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        buttonActions[info.tag] = info.action
        buttons.append(button)
        button.backgroundColor = Asset.primaryBackground.color
        button.tag = info.tag
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }
    
    private func makeStackView(axis: NSLayoutConstraint.Axis) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = popupSizes.stackViewSpacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = Asset.grayTransparent.color
        for button in buttons {
            stackView.addArrangedSubview(button)
        }
        stackView.distribution = .fillEqually
        return stackView
    }
    
    private func makeSeparateButtonsLine() -> UIView {
        let view = UIView()
        view.backgroundColor = Asset.grayTransparent.color
        view.bounds.size.height = 1
        return view
    }
}

extension Popup {
    private func setConstraints() {
        setContainerViewConstraints()
        setTitleLabelConstraints()
        setDescriptionLabelConstraints()
        setStackViewConstraints()
        setSeparateButtonsLineConstraints()
    }
    
    private func setContainerViewConstraints() {
        containerView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalTo(containerView.bounds.width)
            maker.height.equalTo(containerView.bounds.height)
        }
    }
    
    private func setTitleLabelConstraints() {
        titleLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalToSuperview().inset(popupSizes.titleLabelTopOffset)
            maker.width.equalTo(titleLabel.bounds.width)
            maker.height.equalTo(titleLabel.bounds.height)
        }
    }
    
    private func setDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.top.equalTo(titleLabel.snp.bottom).offset(popupSizes.descriptionLabelTopOffset)
            maker.width.equalTo(descriptionLabel.bounds.width)
            maker.height.equalTo(descriptionLabel.bounds.height)
        }
    }
    
    private func setBlurViewConstraints() {
        blurView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setSeparateButtonsLineConstraints() {
        guard let view = separateButtonsLine,
              let stackView = buttonsStackView
        else {
            return
        }
        view.snp.makeConstraints { maker in
            maker.bottom.equalTo(stackView.snp.top).offset(popupSizes.separateButtonsLineHeight)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(view.bounds.height)
        }
    }
    
    private func setStackViewConstraints() {
        guard let stackView = buttonsStackView
        else {
            return
        }
        stackView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.width.bottom.equalToSuperview()
            maker.height.equalTo(stackViewHeight)
        }
    }
}
