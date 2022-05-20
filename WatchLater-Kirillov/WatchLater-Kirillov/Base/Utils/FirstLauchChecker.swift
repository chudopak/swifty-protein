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
    private static let firstProfileLauchKey = "First Profile Launch"

    static var isFirstLaunch: Bool {
        get {
            UserDefaults.standard.bool(forKey: firstLauchKey)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: firstLauchKey)
        }
    }
    
    static var isFirstProfileLaunch: Bool {
        get {
            !UserDefaults.standard.bool(forKey: firstProfileLauchKey)
        } set {
            UserDefaults.standard.setValue(!newValue, forKey: firstProfileLauchKey)
        }
    }
}
