//
//  FirstLauchChecker.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/12/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

enum FirstLaunchChecker {
    private static let firstLauchKey = "First Launch"

    static var isFirstLaunch: Bool {
        get {
            UserDefaults.standard.bool(forKey: firstLauchKey)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: firstLauchKey)
        }
    }
}
