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
        return true
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
