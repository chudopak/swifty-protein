//
//  AppDelegate.swift
//  StartProject-ios
//
//  Created by Rustam Nurgaliev on 13.03.2021.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import MemoryLeakTracker

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        configureMemoryLeakTracker(for: application)
        setBarsAppearance()
        guard #available(iOS 13.0, *) else {
            self.window = UIWindow(frame: UIScreen.main.bounds)
            let splashVC = SplashConfigurator().setupController()
            self.window!.rootViewController = splashVC
            self.window!.makeKeyAndVisible()
            return true
        }
        return true
    }
    
// MARK: UISceneSession Lifecycle

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
    
    private func setupPushNotifications(on application: UIApplication) {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        let userNotificationCenter = UNUserNotificationCenter.current()
        userNotificationCenter.requestAuthorization(
            options: authOptions,
            completionHandler: { _, _ in }
        )
        application.registerForRemoteNotifications()
        userNotificationCenter.delegate = self
    }
    
    private func configureMemoryLeakTracker(for application: UIApplication) {
        let memoryLeakTrackerConfiguration: MLTConfiguration
        #if PROD
        memoryLeakTrackerConfiguration = MLTConfiguration(isEnable: false)
        #else
        memoryLeakTrackerConfiguration = MLTConfiguration(
            isEnable: true,
            ignoreClasses: [],
            notificationType: [.console, .push],
            messageTrigger: 3,
            logOnConsole: false
        )
        #endif
        MemoryLeakTracker.shared.configure(memoryLeakTrackerConfiguration)
        setupPushNotifications(on: application)
        
        print(NetworkConfiguration.url)
    }
    
    private func setBarsAppearance() {
        setNavigationBarAppearance()
        setTabBarAppearance()
    }
    
    private func setNavigationBarAppearance() {
        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.titleTextAttributes =
                [.foregroundColor: Asset.Colors.navigationBarTextColor.color]
            navBarAppearance.largeTitleTextAttributes =
                [.foregroundColor: Asset.Colors.navigationBarTextColor.color]
            navBarAppearance.backgroundColor = Asset.Colors.navigationBarBackground.color
            UINavigationBar.appearance().standardAppearance = navBarAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        } else {
            UINavigationBar.appearance().barTintColor = Asset.Colors.navigationBarBackground.color
            UINavigationBar.appearance().titleTextAttributes =
                [.foregroundColor: Asset.Colors.navigationBarTextColor.color]
            UINavigationBar.appearance().largeTitleTextAttributes =
                [.foregroundColor: Asset.Colors.navigationBarTextColor.color]
        }
    }
    
    private func setTabBarAppearance() {
        UITabBar.appearance().backgroundColor = Asset.Colors.tabBarBackground.color
        UITabBar.appearance().barTintColor = Asset.Colors.tabBarBackground.color
        UITabBar.appearance().tintColor = Asset.Colors.deepBlue.color
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: Asset.Colors.deepBlue.color], for: .selected)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    // MARK: - UNUserNotificationCenterDelegate
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.badge, .alert, .sound])
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
}
