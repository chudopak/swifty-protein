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
    private lazy var redGrayMolecul = makeImageView(image: Asset.moleculesRedGray.image)
    private lazy var redBlueMolecul = makeImageView(image: Asset.moleculeRedBlue.image)
    
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
        view.addSubview(purpleMolecul)
        view.addSubview(multipleColorMolecul)
        view.addSubview(redGrayMolecul)
        view.addSubview(redBlueMolecul)
    }
    
    private func startFirstAnimationStage() {
        UIView.animate(
            withDuration: SplashSizes.duration,
            delay: SplashSizes.delay,
            options: .curveEaseInOut,
            animations: { [weak self] in
                self?.setFirstAnimationStageConstraints()
                self?.view.layoutIfNeeded()
            },
            completion: nil
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
}

// MARK: Constraints

extension SplashViewController {
    
    private func setStartImageConstraints() {
        setCenterConstraints(view: purpleMolecul)
        setTopImageConstraints(view: multipleColorMolecul, center: purpleMolecul)
        setLeftImageConstraints(view: redGrayMolecul, center: purpleMolecul)
        setReightImageConstraints(view: redBlueMolecul, center: purpleMolecul)
    }
    
    private func setFirstAnimationStageConstraints() {
        setCenterConstraints(view: redGrayMolecul)
        setTopImageConstraints(view: redBlueMolecul, center: redGrayMolecul)
        setLeftImageConstraints(view: multipleColorMolecul, center: redGrayMolecul)
        setReightImageConstraints(view: purpleMolecul, center: redGrayMolecul)
    }
    
    private func setCenterConstraints(view: UIImageView) {
        view.snp.remakeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalTo(SplashSizes.CenterMolecul.width)
            maker.height.equalTo(SplashSizes.CenterMolecul.height)
        }
    }
    
    private func setTopImageConstraints(view: UIImageView, center: UIImageView) {
        view.snp.remakeConstraints { maker in
            maker.trailing.equalToSuperview().inset(SplashSizes.TopMolecul.trailingOffset)
            maker.bottom.equalTo(center.snp.top).inset(-SplashSizes.TopMolecul.bottomOffset)
            maker.width.equalTo(SplashSizes.TopMolecul.width)
            maker.height.equalTo(SplashSizes.TopMolecul.height)
        }
    }
    
    private func setLeftImageConstraints(view: UIImageView, center: UIImageView) {
        view.snp.remakeConstraints { maker in
            maker.leading.equalToSuperview().inset(SplashSizes.LeftBottomMolecul.leadingOffset)
            maker.top.equalTo(center.snp.bottom).offset(SplashSizes.LeftBottomMolecul.topOffset)
            maker.width.equalTo(SplashSizes.LeftBottomMolecul.width)
            maker.height.equalTo(SplashSizes.LeftBottomMolecul.height)
        }
    }
    
    private func setReightImageConstraints(view: UIImageView, center: UIImageView) {
        view.snp.remakeConstraints { maker in
            maker.trailing.equalToSuperview().inset(SplashSizes.RightBottomMolecul.trailingOffset)
            maker.top.equalTo(center.snp.bottom).offset(SplashSizes.RightBottomMolecul.topOffset)
            maker.width.equalTo(SplashSizes.RightBottomMolecul.width)
            maker.height.equalTo(SplashSizes.RightBottomMolecul.height)
        }
    }
}
