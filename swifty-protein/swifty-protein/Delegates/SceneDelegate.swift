//
//  SceneDelegate.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/2/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else {
            return
        }
        
        self.window = UIWindow(windowScene: windowScene)
        let splashVC = SplashConfigurator().setupModule()
        self.window!.rootViewController = splashVC
        self.window!.makeKeyAndVisible()
    }
}
