//
//  ViewController.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/2/22.
//

import UIKit

class ViewController: UIViewController {

    lazy var label: UILabel = {
        let label = UILabel()
        label.text = Text.Common.hello
        label.textColor = .green
        label.textAlignment = .center
        label.bounds.size = CGSize(width: 100, height: 50)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
        view.addSubview(label)
        label.center = view.center
    }
}
