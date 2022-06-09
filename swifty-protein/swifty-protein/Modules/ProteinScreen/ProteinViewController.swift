//
//  ProteinViewController.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/9/22.
//

import UIKit

protocol ProteinViewControllerProtocol: AnyObject {
}

final class ProteinViewController: UIViewController {
    
    private var presenter: ProteinPresenter!
    
    private var ligand = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    func setupComponents(presenter: ProteinPresenter) {
        self.presenter = presenter
    }
    
    func setLigandName(_ name: String) {
        ligand = name
    }
    
    private func setView() {
        view.backgroundColor = Asset.primaryBackground.color
        title = ligand
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
    }
}

extension ProteinViewController: ProteinViewControllerProtocol {
}
