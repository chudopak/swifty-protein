//
//  UIWindowService.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/21/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

enum UIWindowService {
    
    static func replaceWindowWithNewOne(rootViewController: UIViewController) {
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate
            else {
                fatalError("Can't create new window")
            }
            let overlayWindow = UIWindow(windowScene: windowScene)
            overlayWindow.windowLevel = UIWindow.Level.alert
            sceneDelegate.window = overlayWindow
            sceneDelegate.window!.rootViewController = rootViewController
            sceneDelegate.window!.makeKeyAndVisible()
            animate(window: sceneDelegate.window!)
        } else {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            let overlayWindow = UIWindow(frame: UIScreen.main.bounds)
            overlayWindow.windowLevel = UIWindow.Level.alert
            overlayWindow.rootViewController = rootViewController
            overlayWindow.makeKeyAndVisible()
            appdelegate.window = overlayWindow
            animate(window: appdelegate.window!)
        }
    }
    
    static func replaceRootViewController(with rootViewController: UIViewController) {
        if #available(iOS 13.0, *) {
            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                  let sceneDelegate = windowScene.delegate as? SceneDelegate
            else {
                fatalError("Can't create new window")
            }
            sceneDelegate.window!.rootViewController = rootViewController
            sceneDelegate.window!.makeKeyAndVisible()
            animate(window: sceneDelegate.window!)
        } else {
            let appdelegate = UIApplication.shared.delegate as! AppDelegate
            appdelegate.window!.rootViewController = rootViewController
            appdelegate.window!.makeKeyAndVisible()
            animate(window: appdelegate.window!)
        }
    }
    
    private static func animate(window: UIWindow) {
        UIView.transition(with: window,
                          duration: 0.3,
                          options: .transitionCrossDissolve,
                          animations: nil,
                          completion: nil)
    }
}
