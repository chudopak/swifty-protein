//
//  SceneDelegate.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/2/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    private var shouldReplaceWithLoginVC = false
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        window = UIWindow(windowScene: windowScene)
        let loginVC = SplashConfigurator().setupModule()
        window!.rootViewController = loginVC
        window!.makeKeyAndVisible()
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        shouldReplaceWithLoginVC = true
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        if shouldReplaceWithLoginVC {
            WindowService.presentLoginViewController()
            shouldReplaceWithLoginVC = false
        }
    }
}
