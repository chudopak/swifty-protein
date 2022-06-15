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
    func showFailedView()
}

protocol ProteinViewControllerDelegate: AnyObject {
    func fetchProteinData()
}

final class ProteinViewController: UIViewController {
    
    private enum ViewState {
        case error, loading, success
    }
    
    private var presenter: ProteinPresenter!
    
    private var ligand = ""
    
    private lazy var sceneView = makeSceneView()
    private lazy var spinner = makeSpinner()
    private lazy var errorView = ProteinErrorView(delegate: self)
    
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
        view.addSubview(errorView)
        setViewState(state: .loading)
    }
    
    private func setNavigationBar() {
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: nil
        )
    }
    
    private func setViewState(state: ViewState) {
        switch state {
        case .loading:
            sceneView.isHidden = true
            spinner.startAnimating()
            spinner.isHidden = false
            errorView.isHidden = true
            
        case .success:
            sceneView.isHidden = false
            spinner.stopAnimating()
            spinner.isHidden = true
            errorView.isHidden = true
            
        case .error:
            sceneView.isHidden = true
            spinner.stopAnimating()
            spinner.isHidden = true
            errorView.isHidden = false
        }
    }
}

extension ProteinViewController: ProteinViewControllerProtocol {

    func renderScene(with proteinData: ProteinData) {
        sceneView.scene = ProteinScene(proteinData: proteinData)
        setViewState(state: .success)
    }
    
    func showFailedView() {
        setViewState(state: .error)
    }
}

extension ProteinViewController: ProteinViewControllerDelegate {
    
    func fetchProteinData() {
        setViewState(state: .loading)
        presenter.fetchProteinData(name: ligand)
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
        setErrorViewConstraints()
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
    
    private func setErrorViewConstraints() {
        errorView.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
            maker.width.equalTo(ProteinSizes.ErrorView.width)
            maker.height.equalTo(ProteinSizes.ErrorView.height)
        }
    }
}
