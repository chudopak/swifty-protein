//
//  SplashViewController.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/2/22.
//

import UIKit
import SnapKit

final class SplashViewController: UIViewController {
    
    private lazy var purpleMolecul = makeImageView(image: Asset.moleculePurpleOrange.image)
    private lazy var multipleColorMolecul = makeImageView(image: Asset.moleculeMutipleColor.image)
    private lazy var redBlueMolecul = makeImageView(image: Asset.moleculeRedBlue.image)
    private lazy var titleLabel = makeAppNameLabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
        setStartImageConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startFirstAnimationStage()
    }
    
    private func setView() {
        view.backgroundColor = Asset.primaryBackground.color
        view.addSubview(titleLabel)
        view.addSubview(purpleMolecul)
        view.addSubview(multipleColorMolecul)
        view.addSubview(redBlueMolecul)
    }
    
    private func startFirstAnimationStage() {
        UIView.animate(
            withDuration: SplashSizes.duration,
            delay: .zero,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.setFirstAnimationStageConstraints()
                self?.view.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                self?.startSecondAnimationStage()
            }
        )
    }
    
    private func startSecondAnimationStage() {
        UIView.animate(
            withDuration: SplashSizes.duration,
            delay: .zero,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.setSecondAnimationStageConstraints()
                self?.view.layoutIfNeeded()
            },
            completion: { [weak self] _ in
                self?.startThirdAnimationStage()
            }
        )
    }
    
    private func startThirdAnimationStage() {
        UIView.animate(
            withDuration: SplashSizes.duration,
            delay: .zero,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.setThirdAnimationStageConstraints()
                self?.view.layoutIfNeeded()
            },
            completion: { _ in
                WindowService.replaceRootViewController(with: LoginConfigurator().setupModule())
            }
        )
    }
}

// MARK: Creatin UI elements

extension SplashViewController {
    
    private func makeImageView(image: UIImage) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    
    private func makeAppNameLabel() -> UILabel {
        let label = UILabel()
        label.text = Text.appTitle
        label.textAlignment = .center
        label.textColor = Asset.titleTextColor.color
        label.font = UIFont(name: SplashSizes.TitleLabel.fontName,
                            size: SplashSizes.TitleLabel.fontSize)
        return label
    }
}

// MARK: Constraints

extension SplashViewController {
    
    private func setStartImageConstraints() {
        setCenterConstraints(view: titleLabel)
        setTopImageConstraints(view: multipleColorMolecul, center: titleLabel)
        setLeftImageConstraints(view: purpleMolecul, center: titleLabel)
        setRightImageConstraints(view: redBlueMolecul, center: titleLabel)
    }
    
    private func setFirstAnimationStageConstraints() {
        setTopImageConstraints(view: redBlueMolecul, center: titleLabel)
        setLeftImageConstraints(view: multipleColorMolecul, center: titleLabel)
        setRightImageConstraints(view: purpleMolecul, center: titleLabel)
    }
    
    private func setSecondAnimationStageConstraints() {
        setTopImageConstraints(view: purpleMolecul, center: titleLabel)
        setLeftImageConstraints(view: redBlueMolecul, center: titleLabel)
        setRightImageConstraints(view: multipleColorMolecul, center: titleLabel)
    }
    
    private func setThirdAnimationStageConstraints() {
        setTopImageConstraints(view: multipleColorMolecul, center: titleLabel)
        setLeftImageConstraints(view: purpleMolecul, center: titleLabel)
        setRightImageConstraints(view: redBlueMolecul, center: titleLabel)
    }
    
    private func setCenterConstraints(view: UIView) {
        view.snp.remakeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalTo(SplashSizes.TitleLabel.width)
            maker.height.equalTo(SplashSizes.TitleLabel.height)
        }
    }
    
    private func setTopImageConstraints(view: UIView, center: UIView) {
        view.snp.remakeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(center.snp.top).inset(-SplashSizes.TopMolecul.bottomOffset)
            maker.width.equalTo(SplashSizes.TopMolecul.width)
            maker.height.equalTo(SplashSizes.TopMolecul.height)
        }
    }
    
    private func setLeftImageConstraints(view: UIView, center: UIView) {
        view.snp.remakeConstraints { maker in
            maker.leading.equalToSuperview().inset(SplashSizes.LeftBottomMolecul.leadingOffset)
            maker.top.equalTo(center.snp.bottom).offset(SplashSizes.LeftBottomMolecul.topOffset)
            maker.width.equalTo(SplashSizes.LeftBottomMolecul.width)
            maker.height.equalTo(SplashSizes.LeftBottomMolecul.height)
        }
    }
    
    private func setRightImageConstraints(view: UIView, center: UIView) {
        view.snp.remakeConstraints { maker in
            maker.trailing.equalToSuperview().inset(SplashSizes.RightBottomMolecul.trailingOffset)
            maker.top.equalTo(center.snp.bottom).offset(SplashSizes.RightBottomMolecul.topOffset)
            maker.width.equalTo(SplashSizes.RightBottomMolecul.width)
            maker.height.equalTo(SplashSizes.RightBottomMolecul.height)
        }
    }
}
