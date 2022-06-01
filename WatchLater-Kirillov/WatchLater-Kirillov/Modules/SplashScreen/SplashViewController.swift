//
//  SplashViewController.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/11/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.

import UIKit
import SnapKit

protocol SplashViewControllerProtocol: AnyObject {
    func handleTokenValidating(result: RefreshResult)
    func handleTokenRefreeshing(result: RefreshResult)
}

class SplashViewController: BaseViewController {
    
    private lazy var watchLaterImageView = makeWatchLaterImageView()
    private lazy var eyeImageView = makeEyeImageView()
    private lazy var agonaImageView = makeAgonaImageView()
    
    private var interactor: SplashInteractorProtocol!
    private var router: SplashRouter!
    private var isAnimationFinished = false
    private var isTokenValidationFinished = false
    private var isTokenActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.Colors.primaryBackground.color
        view.addSubview(watchLaterImageView)
        view.addSubview(agonaImageView)
        watchLaterImageView.addSubview(eyeImageView)
        configureSplashScreenSizessAtLaunch()
        setConstraints()
        // TODO: - delete it later
//        KeychainService.delete(key: .accessToken)
//        KeychainService.delete(key: .refreshToken)
        interactor.validateToken()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewAnimation()
    }
    
    func setupComponents(interactor: SplashInteractorProtocol,
                         router: SplashRouter) {
        self.interactor = interactor
        self.router = router
    }
    
    private func presentNeededScreen() {
        if isTokenActive {
            router.presentMainTabBar()
        } else {
            router.presentLoginViewController()
        }
    }
    
    private func configureSplashScreenSizessAtLaunch() {
        watchLaterImageView.center = view.center
        watchLaterImageView.bounds.size = CGSize(
            width: SplashScreenSizes.watchLaterImageViewWidth * SplashScreenSizes.sizeRatioBeforeAnimation,
            height: SplashScreenSizes.watchLaterImageViewHeight * SplashScreenSizes.sizeRatioBeforeAnimation)
        
        eyeImageView.frame = CGRect(
            x: SplashScreenSizes.eyeImageViewXCenter * SplashScreenSizes.sizeRatioBeforeAnimation,
            y: SplashScreenSizes.eyeImageViewY * SplashScreenSizes.sizeRatioBeforeAnimation,
            width: SplashScreenSizes.eyeImageViewSide * SplashScreenSizes.sizeRatioBeforeAnimation,
            height: SplashScreenSizes.eyeImageViewSide * SplashScreenSizes.sizeRatioBeforeAnimation)
    }
    
    private func configureSplashScreenSizessAfterFadeInAnimation() {
        watchLaterImageView.bounds.size = CGSize(width: SplashScreenSizes.watchLaterImageViewWidth,
                                                 height: SplashScreenSizes.watchLaterImageViewHeight)
        eyeImageView.frame = CGRect(x: SplashScreenSizes.eyeImageViewXCenter,
                                    y: SplashScreenSizes.eyeImageViewY,
                                    width: SplashScreenSizes.eyeImageViewSide,
                                    height: SplashScreenSizes.eyeImageViewSide)
    }
    
    private func viewAnimation() {
        UIView.animate(withDuration: SplashScreenAnimation.FadeIn.duration,
                       delay: SplashScreenAnimation.FadeIn.delay,
                       options: .curveEaseIn, animations: { [weak self] in
                        self?.eyeImageView.alpha = SplashScreenAnimation.FadeIn.alpha
                        self?.watchLaterImageView.alpha = SplashScreenAnimation.FadeIn.alpha
                        self?.agonaImageView.alpha = SplashScreenAnimation.FadeIn.alpha
                        self?.configureSplashScreenSizessAfterFadeInAnimation()
                       }, completion: { [weak self] completed in
                        self?.animateEyePhaseOne()
                       })
    }
    
    private func animateEyePhaseOne() {
        UIView.animate(withDuration: SplashScreenAnimation.PhaseOne.duration,
                       delay: SplashScreenAnimation.PhaseOne.delay,
                       options: .curveLinear, animations: { [weak self] in
                        self?.eyeImageView.frame.origin.x = SplashScreenSizes.eyeImageViewXRight
                       }, completion: { [weak self] _ in
                        self?.animateEyePhaseTwo()
                       })
    }
    
    private func animateEyePhaseTwo() {
        UIView.animate(withDuration: SplashScreenAnimation.PhaseTwo.duration,
                       delay: SplashScreenAnimation.PhaseTwo.delay,
                       options: .curveLinear, animations: { [weak self] in
                        self?.eyeImageView.frame.origin.x = SplashScreenSizes.eyeImageViewXLeft
                       }, completion: { [weak self] _ in
                        self?.animateEyePhaseThree()
                       })
    }
    
    private func animateEyePhaseThree() {
        UIView.animate(withDuration: SplashScreenAnimation.PhaseThree.duration,
                       delay: SplashScreenAnimation.PhaseThree.delay,
                       options: .curveLinear, animations: { [weak self] in
                        self?.eyeImageView.frame.origin.x = SplashScreenSizes.eyeImageViewXCenter
                       }, completion: { [weak self] _ in
                        self?.isAnimationFinished = true
                        if let isFinished = self?.isTokenValidationFinished,
                              isFinished {
                            self?.presentNeededScreen()
                        }
                       })
    }
}

extension SplashViewController: SplashViewControllerProtocol {
    func handleTokenValidating(result: RefreshResult) {
        switch result {
        case .success:
            DispatchQueue.main.async { [weak self] in
                self?.isTokenValidationFinished = true
                self?.isTokenActive = true
                if let isAnimationFinished = self?.isAnimationFinished,
                   isAnimationFinished {
                    self?.presentNeededScreen()
                }
            }
            
        case .failure:
            interactor.recreateToken()
        }
    }
    
    func handleTokenRefreeshing(result: RefreshResult) {
        switch result {
        case .success:
            isTokenActive = true
            
        case .failure:
            break
        }
        DispatchQueue.main.async { [weak self] in
            self?.isTokenValidationFinished = true
            if let isAnimationFinished = self?.isAnimationFinished,
               isAnimationFinished {
                self?.presentNeededScreen()
            }
        }
    }
}

// MARK: Extension for element creation

extension SplashViewController {
    
    private func makeWatchLaterImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = Asset.watchLater.image
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = .zero
        return (imageView)
    }
    
    private func makeEyeImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = Asset.eye.image
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = .zero
        return (imageView)
    }
    
    private func makeAgonaImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = Asset.agonaLogo.image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = .zero
        return (imageView)
    }
}

// MARK: Constraints

extension SplashViewController {
    
    private func setConstraints() {
        agonaImageView.snp.makeConstraints { maker in
            maker.centerX.equalToSuperview()
            maker.bottom.equalToSuperview().inset(SplashScreenSizes.agonaImageViewBottomOffset)
            maker.width.equalTo(SplashScreenSizes.agonaImageViewWidth)
            maker.height.equalTo(SplashScreenSizes.agonaImageViewHeight)
        }
    }
}
