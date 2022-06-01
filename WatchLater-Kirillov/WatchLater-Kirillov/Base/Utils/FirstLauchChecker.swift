//
//  FirstLauchChecker.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/12/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit

enum FirstLaunchChecker {
    
    enum Constant {
        static let firstLauchKey = "First Launch"
        static let firstProfileLauchKey = "First Profile Launch"
    }

    static var isFirstLaunch: Bool {
        get {
            UserDefaults.standard.bool(forKey: Constant.firstLauchKey)
        } set {
            UserDefaults.standard.setValue(newValue, forKey: Constant.firstLauchKey)
        }
    }
    
    static var isFirstProfileLaunch: Bool {
        get {
            !UserDefaults.standard.bool(forKey: Constant.firstProfileLauchKey)
        } set {
            UserDefaults.standard.setValue(!newValue, forKey: Constant.firstProfileLauchKey)
        }
    }
}
