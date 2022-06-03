//
//  WindowService.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/3/22.
//

import UIKit

enum WindowService {
    
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
    
    private static func animate(window: UIWindow) {
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil,
            completion: nil
        )
    }
}
