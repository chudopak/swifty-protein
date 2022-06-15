//
//  ProteinViewController.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/9/22.
//

import UIKit
import SceneKit
import SnapKit

protocol ProteinViewControllerProtocol: AnyObject {
    func renderScene(with proteinData: ProteinData)
}

final class ProteinViewController: UIViewController {
    
    private var presenter: ProteinPresenter!
    
    private var ligand = ""
    
    private lazy var sceneView = makeSceneView()
    private lazy var spinner = makeSpinner()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        presenter.fetchProteinData(name: ligand)
        setView()
        setConstraints()
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
        view.addSubview(spinner)
        view.addSubview(sceneView)
        sceneView.isHidden = true
        spinner.startAnimating()
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

    func renderScene(with proteinData: ProteinData) {
        sceneView.scene = ProteinScene(proteinData: proteinData)
        sceneView.isHidden = false
        spinner.stopAnimating()
        spinner.isHidden = true
    }
}

extension ProteinViewController {
    
    private func makeSceneView() -> SCNView {
        let view = SCNView()
        view.backgroundColor = .clear
        view.allowsCameraControl = true
        view.autoenablesDefaultLighting = true
        return view
    }
    
    private func makeSpinner() -> UIActivityIndicatorView {
        let spinner = UIActivityIndicatorView()
        spinner.style = .large
        spinner.color = Asset.textColor.color
        return spinner
    }
}

extension ProteinViewController {
    
    private func setConstraints() {
        setSceneViewConstraints()
        setSpinnerConstraints()
    }
    
    private func setSceneViewConstraints() {
        sceneView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
    }
    
    private func setSpinnerConstraints() {
        spinner.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalTo(ProteinSizes.Spinner.width)
            maker.height.equalTo(ProteinSizes.Spinner.height)
        }
    }
}
