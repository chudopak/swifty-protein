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
        fontSize: 16,
        alignment: .center,
        text: Text.AtomDescription.electronicConfiguration
    )
    private lazy var electronicConfig = makeLabel(fontSize: 16, alignment: .center)
    private lazy var atomMassTitle = makeFieldLabel(
        fontSize: 16,
        alignment: .center,
        text: Text.AtomDescription.atomMass
    )
    private lazy var atomMass = makeLabel(fontSize: 16, alignment: .center)
    
    private lazy var electronicConfigStack = makeStackView(
        views: [electronicConfigTitle, electronicConfig],
        axis: .vertical,
        spacing: 5
    )
    private lazy var atomMassStack = makeStackView(
        views: [atomMassTitle, atomMass],
        axis: .vertical,
        spacing: 5
    )
    
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
        nameLabel.text = Locale.current.languageCode == "ru" ? atom.name_ru : atom.name_en
        nameLabel.textColor = CPKColors.getColor(string: atom.symbol)
        atomNumber.text = String(atom.atomicNumber)
        atomNumber.textColor = CPKColors.getColor(string: atom.symbol)
        atomMass.text = atom.atomicMass ?? "unnowned"
        electronicConfig.text = atom.electronicConfiguration
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
    }
    
    private func makeVisible(errorView: Bool = false, detailsView: Bool = false) {
        symbolLabel.isHidden = !detailsView
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
        return stackView
    }
    
    private func makeContainerView() -> UIView {
        let view = UIView()
        view.backgroundColor = Asset.atomBackground.color
        view.layer.cornerRadius = ProteinSizes.AtomDetails.containerCornerRadius
        return view
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
}
