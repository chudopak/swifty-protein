//
//  WindowService.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/3/22.
//

import UIKit

enum WindowService {
    
    private static let transitionDuration: TimeInterval = 0.3
    
    static var isMainScreenExist: Bool {
        return proteinListNavigationController != nil
    }
    
    private static var loginViewController: UIViewController?
    private static var proteinListNavigationController: UIViewController?
    
    static func replaceWindowWithNewOne(rootViewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
            fatalError("WindowService, replaceWindowWithNewOne - Can't create new window")
        }
        let overlayWindow = UIWindow(windowScene: windowScene)
        overlayWindow.windowLevel = UIWindow.Level.alert
        sceneDelegate.window = overlayWindow
        sceneDelegate.window!.rootViewController = rootViewController
        sceneDelegate.window!.makeKeyAndVisible()
        animate(window: sceneDelegate.window!)
    }
    
    static func replaceRootViewController(with rootViewController: UIViewController) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let sceneDelegate = windowScene.delegate as? SceneDelegate
        else {
            fatalError("WindowService, replaceRootViewController - Can't find the old window")
        }
        sceneDelegate.window!.rootViewController = rootViewController
        sceneDelegate.window!.makeKeyAndVisible()
        animate(window: sceneDelegate.window!)
    }
    
    static func setLoginViewController(vc: UIViewController) {
        loginViewController = vc
    }
    
    static func setProteinListNavigationController(vc: UIViewController) {
        proteinListNavigationController = vc
    }
    
    static func presentLoginViewController() {
        guard let vc = loginViewController
        else {
            return
        }
        replaceRootViewController(with: vc)
    }
    
    static func presentProteinListNavigationController() {
        guard let vc = proteinListNavigationController
        else {
            return
        }
        replaceRootViewController(with: vc)
    }
    
    private static func animate(window: UIWindow) {
        UIView.transition(
            with: window,
            duration: transitionDuration,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
    }
}
