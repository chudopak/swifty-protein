//
//  ProteinAtomDetailsView.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/16/22.
//

import UIKit
import SnapKit

final class ProteinAtomDetailsView: UIView {
    
    private lazy var containerView = makeContainerView()
    private lazy var symbolLabel = makeBoldLabel(
        fontSize: ProteinSizes.AtomDetails.symbolFontSize,
        alignment: .left
    )
    private lazy var nameLabel = makeBoldLabel(
        fontSize: ProteinSizes.AtomDetails.atomNameFontSize,
        alignment: .left
    )
    private lazy var atomNumber = makeBoldLabel(
        fontSize: ProteinSizes.AtomDetails.atomNumberFontSize,
        alignment: .right
    )
    private lazy var electronicConfigTitle = makeFieldLabel(
        fontSize: ProteinSizes.AtomDetails.fontSize,
        alignment: .center,
        text: Text.AtomDescription.electronicConfiguration
    )
    private lazy var electronicConfig = makeLabel(
        fontSize: ProteinSizes.AtomDetails.fontSize,
        alignment: .center
    )
    private lazy var atomMassTitle = makeFieldLabel(
        fontSize: ProteinSizes.AtomDetails.fontSize,
        alignment: .center,
        text: Text.AtomDescription.atomMass
    )
    private lazy var atomMass = makeLabel(
        fontSize: ProteinSizes.AtomDetails.fontSize,
        alignment: .center
    )
    private lazy var boilingPointTitle = makeFieldLabel(
        fontSize: ProteinSizes.AtomDetails.fontSize,
        alignment: .left,
        text: Text.AtomDescription.boilingPoint
    )
    private lazy var boilingPoint = makeLabel(
        fontSize: ProteinSizes.AtomDetails.fontSize,
        alignment: .right
    )
    private lazy var yearDiscoveredTitle = makeFieldLabel(
        fontSize: ProteinSizes.AtomDetails.fontSize,
        alignment: .left,
        text: Text.AtomDescription.yearDiscovered
    )
    private lazy var yearDiscovered = makeLabel(
        fontSize: ProteinSizes.AtomDetails.fontSize,
        alignment: .right
    )
    private lazy var boilingPointStack = makeStackView(
        views: [boilingPointTitle, boilingPoint],
        axis: .horizontal,
        spacing: ProteinSizes.AtomDetails.stackHorizontalSpace
    )
    private lazy var yearDiscoveredStack = makeStackView(
        views: [yearDiscoveredTitle, yearDiscovered],
        axis: .horizontal,
        spacing: ProteinSizes.AtomDetails.stackHorizontalSpace
    )
    
    private lazy var auxiliaryInfoStack = makeStackView(
        views: [boilingPointStack, yearDiscoveredStack],
        axis: .vertical,
        spacing: ProteinSizes.AtomDetails.stackTopOffset
    )
    
    private lazy var electronicConfigStack = makeStackView(
        views: [electronicConfigTitle, electronicConfig],
        axis: .vertical,
        spacing: ProteinSizes.AtomDetails.stackVerticalSpace
    )
    private lazy var atomMassStack = makeStackView(
        views: [atomMassTitle, atomMass],
        axis: .vertical,
        spacing: ProteinSizes.AtomDetails.stackVerticalSpace
    )
    
    private lazy var errorLabel = makeErrorLabel()
    
    private lazy var dragViewButton = makeDragViewButton()
    private lazy var dragLabel = makeDragLabel()
    
    init() {
        super.init(frame: .zero)
        setView()
        setConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDetaildFields(atom: AtomDetails) {
        symbolLabel.text = atom.symbol
        symbolLabel.textColor = CPKColors.getColor(string: atom.symbol)
        nameLabel.text = Locale.current.languageCode == Localisation.ru
                                    ? atom.name_ru
                                    : atom.name_en
        nameLabel.textColor = CPKColors.getColor(string: atom.symbol)
        atomNumber.text = String(atom.atomicNumber)
        atomNumber.textColor = CPKColors.getColor(string: atom.symbol)
        atomMass.text = atom.atomicMass ?? Text.Common.unnowned
        electronicConfig.text = atom.electronicConfiguration
        if let boilingPointText = atom.boilingPoint {
            boilingPoint.text = String(boilingPointText)
        } else {
            boilingPoint.text = Text.Common.unnowned
        }
        if let yearDiscoveredText = atom.yearDiscovered {
            yearDiscovered.text = String(yearDiscoveredText)
        } else {
            yearDiscovered.text = Text.Common.unnowned
        }
        makeVisible(detailsView: true)
    }
    
    func showErrorView() {
        makeVisible(errorView: true)
    }
    
    private func setView() {
        clipsToBounds = true
        backgroundColor = Asset.atomInfoBackgroundColor.color
        addSubview(containerView)
        containerView.addSubview(symbolLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(atomNumber)
        addSubview(electronicConfigStack)
        addSubview(atomMassStack)
        addSubview(auxiliaryInfoStack)
        addSubview(errorLabel)
        addSubview(dragViewButton)
        dragViewButton.addSubview(dragLabel)
    }
    
    private func makeVisible(errorView: Bool = false, detailsView: Bool = false) {
        errorLabel.isHidden = !errorView
        containerView.isHidden = !detailsView
        auxiliaryInfoStack.isHidden = !detailsView
        electronicConfigStack.isHidden = !detailsView
        atomMassStack.isHidden = !detailsView
    }
}

extension ProteinAtomDetailsView {
    
    private func makeBoldLabel(
        fontSize: CGFloat,
        alignment: NSTextAlignment,
        text: String = ""
    ) -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: fontSize)
        label.textAlignment = alignment
        label.text = text
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    private func makeFieldLabel(
        fontSize: CGFloat,
        alignment: NSTextAlignment,
        text: String = ""
    ) -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: fontSize)
        label.textAlignment = alignment
        label.text = text
        label.textColor = Asset.textColor.color
        label.adjustsFontSizeToFitWidth = true
        label.sizeToFit()
        return label
    }
    
    private func makeLabel(
        fontSize: CGFloat,
        alignment: NSTextAlignment,
        text: String = ""
    ) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: fontSize)
        label.textAlignment = alignment
        label.text = text
        label.textColor = Asset.textColor.color
        label.sizeToFit()
        return label
    }
    
    private func makeStackView(
        views: [UIView],
        axis: NSLayoutConstraint.Axis,
        spacing: CGFloat
    ) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = axis
        stackView.spacing = spacing
        for view in views {
            stackView.addArrangedSubview(view)
        }
        stackView.clipsToBounds = true
        return stackView
    }
    
    private func makeContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = Asset.atomBackground.color
        view.layer.cornerRadius = ProteinSizes.AtomDetails.containerCornerRadius
        view.clipsToBounds = true
        return view
    }
    
    private func makeErrorLabel() -> UILabel {
        let label = makeLabel(
            fontSize: ProteinSizes.AtomDetails.errorFontSize,
            alignment: .center,
            text: Text.Descriptions.failedToLoadAtom
        )
        label.numberOfLines = 0
        return label
    }
    
    private func makeDragViewButton() -> CustomButton {
        let button = CustomButton()
        button.clipsToBounds = true
        return button
    }
    
    private func makeDragLabel() -> UILabel {
        let label = UILabel()
        label.backgroundColor = Asset.atomBackground.color
        label.layer.cornerRadius = ProteinSizes.AtomDetails.dragViewLabelCornerRadius
        label.clipsToBounds = true
        return label
    }
}

extension ProteinAtomDetailsView {
    
    private func setConstraints() {
        setContainerViewConstraints()
        setSymbolLabelConstraints()
        setNameLabelConstraints()
        setAtomNumberConstraints()
        setElectronicConfigStackConstraints()
        setAtomMassStackConstraints()
        setAuxiliaryTitlesConstraints()
        setAuxiliaryStackConstraints()
        setErrorLabelConstraints()
        setDragViewButtonConstraints()
        setDragLabelConstraints()
    }
    
    private func setContainerViewConstraints() {
        containerView.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(ProteinSizes.AtomDetails.containerTopOffset)
            maker.leading.equalToSuperview().inset(ProteinSizes.AtomDetails.elementsSideOffset)
            maker.width.height.equalTo(ProteinSizes.AtomDetails.containerSize)
        }
    }
    
    private func setSymbolLabelConstraints() {
        symbolLabel.snp.makeConstraints { maker in
            maker.width.height.equalTo(ProteinSizes.AtomDetails.symbolSize)
            maker.leading.equalToSuperview().inset(ProteinSizes.AtomDetails.containerElementsSideOffset)
            maker.top.equalToSuperview()
        }
    }
    
    private func setNameLabelConstraints() {
        nameLabel.snp.makeConstraints { maker in
            maker.height.equalTo(ProteinSizes.AtomDetails.atomNameHeight)
            maker.trailing.equalToSuperview()
            maker.bottom.leading.equalToSuperview().inset(ProteinSizes.AtomDetails.containerElementsSideOffset)
        }
    }
    
    private func setAtomNumberConstraints() {
        atomNumber.snp.makeConstraints { maker in
            maker.width.height.equalTo(ProteinSizes.AtomDetails.atomNumberSize)
            maker.top.trailing.equalToSuperview().inset(ProteinSizes.AtomDetails.containerElementsSideOffset)
        }
    }
    
    private func setElectronicConfigStackConstraints() {
        electronicConfigStack.snp.makeConstraints { maker in
            maker.top.equalToSuperview().inset(ProteinSizes.AtomDetails.stackSuperViewTopOffset)
            maker.height.equalTo(ProteinSizes.AtomDetails.stackHeight)
            maker.leading.equalTo(containerView.snp.trailing).offset(ProteinSizes.AtomDetails.elementsSideOffset)
            maker.trailing.equalToSuperview().inset(ProteinSizes.AtomDetails.elementsSideOffset)
        }
    }
    private func setAtomMassStackConstraints() {
        atomMassStack.snp.makeConstraints { maker in
            maker.top.equalTo(electronicConfigStack.snp.bottom).inset(-ProteinSizes.AtomDetails.stackTopOffset)
            maker.height.equalTo(ProteinSizes.AtomDetails.stackHeight)
            maker.leading.equalTo(containerView.snp.trailing).offset(ProteinSizes.AtomDetails.elementsSideOffset)
            maker.trailing.equalToSuperview().inset(ProteinSizes.AtomDetails.elementsSideOffset)
        }
    }
    
    private func setAuxiliaryTitlesConstraints() {
        let boilingWidth = boilingPointTitle.bounds.width
        boilingPointTitle.snp.makeConstraints { maker in
            maker.width.equalTo(boilingWidth)
        }
        let yearWidth = yearDiscoveredTitle.bounds.width
        yearDiscoveredTitle.snp.makeConstraints { maker in
            maker.width.equalTo(yearWidth)
        }
    }
    
    private func setAuxiliaryStackConstraints() {
        auxiliaryInfoStack.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(ProteinSizes.AtomDetails.elementsSideOffset)
            maker.height.equalTo(ProteinSizes.AtomDetails.auxiliaryStackHeight)
            maker.top.equalTo(containerView.snp.bottom).inset(-ProteinSizes.AtomDetails.stackTopOffset)
        }
    }
    
    private func setErrorLabelConstraints() {
        errorLabel.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(ProteinSizes.AtomDetails.elementsSideOffset)
            maker.top.bottom.equalToSuperview().inset(ProteinSizes.AtomDetails.containerTopOffset)
        }
    }
    
    private func setDragViewButtonConstraints() {
        dragViewButton.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview().inset(ProteinSizes.AtomDetails.elementsSideOffset)
            maker.top.equalToSuperview()
            maker.height.equalTo(ProteinSizes.AtomDetails.dragViewButtonHeight)
        }
    }
    
    private func setDragLabelConstraints() {
        dragLabel.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.height.equalTo(ProteinSizes.AtomDetails.dragViewLabelHeight)
            maker.width.equalTo(ProteinSizes.AtomDetails.dragViewLabelWidth)
        }
    }
}
