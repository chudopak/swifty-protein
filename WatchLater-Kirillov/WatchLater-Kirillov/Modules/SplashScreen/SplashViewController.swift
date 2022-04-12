//
//  SplashViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/11/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.

import UIKit
import SnapKit

class SplashViewController: BaseViewController {

    struct ElementSize {
        private let ratioScreenWithWatchLaterWidths: CGFloat = 0.527_2
        private let ratioWatchLaterHeightWithWatchLaterWidth: CGFloat = 0.434_0
        private let ratioEyeSideWithWatchLaterHeight: CGFloat = 0.410_9
        private let ratioEyeTopOffsetWithWatchLaterHeight: CGFloat = 0.309_6
        private let ratioEyeLeftOffsetWithWatchLeterWidthCenter: CGFloat = 0.431_5
        private let ratioEyeLeftOffsetWithWatchLeterWidthRight: CGFloat = 0.482_0
        private let ratioEyeLeftOffsetWithWatchLeterWidthLeft: CGFloat = 0.390_9
        private let ratioScreenWithAgonaWidth: CGFloat = 0.245_3
        private let ratioAgonaHeightWithAgonaWidth: CGFloat = 0.467_4
        private let ratioAgonaBottomOffsetToScreenHeight: CGFloat = 0.094_8
        
        let sizeRatioBeforeAnimation: CGFloat = 0.8
        
        var watchLaterImageViewWidth: CGFloat {
            return (UIScreen.main.bounds.size.width * ratioScreenWithWatchLaterWidths)
        }
        var watchLaterImageViewHeight: CGFloat {
            return (UIScreen.main.bounds.size.width * ratioScreenWithWatchLaterWidths * ratioWatchLaterHeightWithWatchLaterWidth)
        }
        var eyeImageViewSide: CGFloat {
            return (watchLaterImageViewHeight * ratioEyeSideWithWatchLaterHeight)
        }
        var eyeImageViewXCenter: CGFloat {
            return (watchLaterImageViewWidth * ratioEyeLeftOffsetWithWatchLeterWidthCenter)
        }
        var eyeImageViewXRight: CGFloat {
            return (watchLaterImageViewWidth * ratioEyeLeftOffsetWithWatchLeterWidthRight)
        }
        var eyeImageViewXLeft: CGFloat {
            return (watchLaterImageViewWidth * ratioEyeLeftOffsetWithWatchLeterWidthLeft)
        }
        var eyeImageViewY: CGFloat {
            return (watchLaterImageViewHeight * ratioEyeTopOffsetWithWatchLaterHeight)
        }
        var agonaImageViewWidth: CGFloat {
            return (UIScreen.main.bounds.size.width * ratioScreenWithAgonaWidth)
        }
        var agonaImageViewHeight: CGFloat {
            return (agonaImageViewWidth * ratioAgonaHeightWithAgonaWidth)
        }
        var agonaImageViewBottomOffset: CGFloat {
            return (UIScreen.main.bounds.size.height * ratioAgonaBottomOffsetToScreenHeight)
        }
    }
    
    private let elementSize = ElementSize()
    
    private lazy var watchLaterImageView = makeWatchLaterImageView()
    private lazy var eyeImageView = makeEyeImageView()
    private lazy var agonaImageView = makeAgonaImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(watchLaterImageView)
        view.addSubview(agonaImageView)
        watchLaterImageView.addSubview(eyeImageView)
        configureElementSizesAtLaunch()
        setConstraints()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewAnimation()
    }
    
    private func configureElementSizesAtLaunch() {
        watchLaterImageView.center = view.center
        watchLaterImageView.bounds.size = CGSize(
            width: elementSize.watchLaterImageViewWidth * elementSize.sizeRatioBeforeAnimation,
            height: elementSize.watchLaterImageViewHeight * elementSize.sizeRatioBeforeAnimation)
        
        eyeImageView.frame = CGRect(
            x: elementSize.eyeImageViewXCenter * elementSize.sizeRatioBeforeAnimation,
            y: elementSize.eyeImageViewY * elementSize.sizeRatioBeforeAnimation,
            width: elementSize.eyeImageViewSide * elementSize.sizeRatioBeforeAnimation,
            height: elementSize.eyeImageViewSide * elementSize.sizeRatioBeforeAnimation)
    }
    
    private func configureElementSizesAfterFadeInAnimation() {
        watchLaterImageView.bounds.size = CGSize(width: elementSize.watchLaterImageViewWidth,
                                                 height: elementSize.watchLaterImageViewHeight)
        eyeImageView.frame = CGRect(x: elementSize.eyeImageViewXCenter,
                                    y: elementSize.eyeImageViewY,
                                    width: elementSize.eyeImageViewSide,
                                    height: elementSize.eyeImageViewSide)
    }
    
    private func viewAnimation() {
        UIView.animate(withDuration: 0.7,
                       delay: 0.0,
                       options: .curveEaseIn, animations: { [weak self] in
                        self?.eyeImageView.alpha = 1.0
                        self?.watchLaterImageView.alpha = 1.0
                        self?.agonaImageView.alpha = 1.0
                        self?.configureElementSizesAfterFadeInAnimation()
                       }, completion: { [weak self] completed in
                        self?.animateEyePhaseOne()
                       })
    }
    
    private func animateEyePhaseOne() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: .curveLinear, animations: { [weak self] in
                        self?.eyeImageView.frame.origin.x = self!.elementSize.eyeImageViewXRight
                       }, completion: { [weak self] _ in
                        self?.animateEyePhaseTwo()
                       })
    }
    
    private func animateEyePhaseTwo() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.1,
                       options: .curveLinear, animations: { [weak self] in
                        self?.eyeImageView.frame.origin.x = self!.elementSize.eyeImageViewXLeft
                       }, completion: { [weak self] _ in
                        self?.animateEyePhaseThree()
                       })
    }
    
    private func animateEyePhaseThree() {
        UIView.animate(withDuration: 0.5,
                       delay: 0.1,
                       options: .curveLinear, animations: { [weak self] in
                        self?.eyeImageView.frame.origin.x = self!.elementSize.eyeImageViewXCenter
                       }, completion: { [weak self] _ in
                        self?.present(LoginRouter.makeLoginViewController(), animated: true, completion: nil)
                       })
    }
}

// MARK: Extension for element creation
extension SplashViewController {
    
    private func makeWatchLaterImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = Asset.watchLater.image
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.0
        return (imageView)
    }
    
    private func makeEyeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = Asset.eye.image
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.0
        return (imageView)
    }
    
    private func makeAgonaImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = Asset.agonaLogo.image
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0.0
        return (imageView)
    }
}
// MARK: Constraints
extension SplashViewController {
    
    private func setConstraints() {
        agonaImageView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().inset(elementSize.agonaImageViewBottomOffset)
            maker.width.equalTo(elementSize.agonaImageViewWidth)
            maker.height.equalTo(elementSize.agonaImageViewHeight)
        }
    }
}
