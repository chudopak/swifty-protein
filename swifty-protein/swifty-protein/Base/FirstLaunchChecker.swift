//
//  FirstLaunchChecker.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/3/22.
//

import UIKit

enum FirstLaunchChecker {
    
    enum Constant {
        static let firstLauchKey = "First Launch"
    }

    static var isFirstLaunch: Bool {
        get {
            !UserDefaults.standard.bool(forKey: Constant.firstLauchKey)
        } set {
            UserDefaults.standard.setValue(!newValue, forKey: Constant.firstLauchKey)
        }
    }
}
