//
//  ProteinListViewController.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/8/22.
//

import UIKit

protocol ProteinListViewControllerProtocol {
}

final class ProteinListViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Asset.primaryBackground.color
    }
}

extension ProteinListViewController: ProteinListViewControllerProtocol {
}
