//
//  BaseViewController.swift
//  StartProject-ios
//
//  Created by Rustam Nurgaliev on 23.05.2021.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import MemoryLeakTracker

class BaseViewController: UIViewController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        MemoryLeakTracker.shared.append("\(self)")
    }
    
    deinit {
        MemoryLeakTracker.shared.remove("\(self)")
    }
}
