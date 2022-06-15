//
//  ProteinErrorView.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/15/22.
//

import UIKit
import SnapKit

final class ProteinErrorView: UIView {
    
    private lazy var failedImageView = makeFailedImageView()
    private lazy var titleLabel = makeTitleLabel()
    private lazy var descriptionLabel = makeDescriptionLabel()
    private lazy var tryAgainButton = makeTryAgainButton()
    
    private weak var delegate: ProteinViewControllerDelegate!
    
    init(delegate: ProteinViewControllerDelegate) {
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
        backgroundColor = Asset.primaryHalfTransparent.color
        addSubview(failedImageView)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(tryAgainButton)
    }
    
    @objc private func fetchProteinData() {
        delegate.fetchProteinData()
    }
}

extension ProteinErrorView {
    
    private func makeFailedImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = Asset.failedCircle.image
        return imageView
    }
    
    private func makeTitleLabel() -> UILabel {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: ProteinSizes.ErrorView.errorTitileFontSize)
        label.textColor = Asset.textColor.color
        label.textAlignment = .center
        label.text = Text.Common.error
        return label
    }
    
    private func makeDescriptionLabel() -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: ProteinSizes.ErrorView.errorDescriptionFontSize)
        label.textAlignment = .center
        label.textColor = Asset.textColor.color
        label.text = Text.Descriptions.failedToLoadMolecule
        label.numberOfLines = 0
        return label
    }
    
    private func makeTryAgainButton() -> CustomButton {
        let button = CustomButton()
        button.backgroundColor = Asset.redFailureTransparent.color
        button.titleLabel?.font = .boldSystemFont(ofSize: ProteinSizes.ErrorView.errorDescriptionFontSize)
        button.titleLabel?.textAlignment = .center
        button.setTitle(Text.Common.tryAgain, for: .normal)
        button.setTitleColor(Asset.redFailure.color, for: .normal)
        button.layer.cornerRadius = ProteinSizes.ErrorView.buttonCornerRadius
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(fetchProteinData), for: .touchUpInside)
        return button
    }
}

extension ProteinErrorView {
    
    private func setConstraints() {
        setTryAgainButtonConstraints()
        setImageViewConstraints()
        setTitleLabelConstratins()
        setDescriptionLabelConstraints()
    }
    
    private func setImageViewConstraints() {
        failedImageView.snp.makeConstraints { maker in
            maker.top.centerX.equalToSuperview()
            maker.width.height.equalTo(ProteinSizes.ErrorView.imageViewSize)
        }
    }
    
    private func setTryAgainButtonConstraints() {
        tryAgainButton.snp.makeConstraints { maker in
            maker.bottom.centerX.equalToSuperview()
            maker.width.equalTo(ProteinSizes.ErrorView.buttonWidth)
            maker.height.equalTo(ProteinSizes.ErrorView.buttonHeight)
        }
    }
    
    private func setTitleLabelConstratins() {
        titleLabel.snp.makeConstraints { maker in
            maker.top.equalTo(failedImageView.snp.bottom).offset(ProteinSizes.ErrorView.titleTopOffset)
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(ProteinSizes.ErrorView.titleHeight)
        }
    }
    
    private func setDescriptionLabelConstraints() {
        descriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(titleLabel.snp.bottom).offset(ProteinSizes.ErrorView.descriptionOffset)
            maker.leading.trailing.equalToSuperview()
            maker.bottom.equalTo(tryAgainButton.snp.top).offset(-ProteinSizes.ErrorView.descriptionOffset)
        }
    }
}
