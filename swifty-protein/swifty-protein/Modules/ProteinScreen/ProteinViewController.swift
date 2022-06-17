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
    func showAtomDetails(atom: AtomDetails?)
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
    private lazy var atomDetailsView = makeAtomDetailsView()
    
    private var defaultDetailsViewCenter = CGPoint.zero
    private var detailsViewInitialCenter = CGPoint.zero
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        presenter.fetchProteinData(name: ligand)
        setView()
        registerGestureRecognizer()
        registerPanGeesture()
        setConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        defaultDetailsViewCenter = atomDetailsView.center
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
        view.addSubview(atomDetailsView)
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
    
    private func registerGestureRecognizer() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(searchNode(sender:))
        )
        sceneView.addGestureRecognizer(tap)
    }
    
    private func registerPanGeesture() {
        let gesture = UIPanGestureRecognizer(
            target: self,
            action: #selector(moveDetailsView(sender:))
        )
        atomDetailsView.addGestureRecognizer(gesture)
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
        atomDetailsView.isHidden = true
    }
    
    private func atomDetailsViewAnimateIn() {
        atomDetailsView.transform = CGAffineTransform(translationX: 0,
                                                      y: ProteinSizes.AtomDetails.hegiht)
        atomDetailsView.alpha = 0
        atomDetailsView.isHidden = false
        UIView.animate(
            withDuration: ProteinSizes.AtomDetails.animationDuration,
            delay: .zero,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseIn,
            animations: { [weak self] in
                self?.atomDetailsView.transform = .identity
                self?.atomDetailsView.alpha = 1
            },
            completion: nil
        )
    }
    
    private func atomDetailsViewAnimateOut() {
        UIView.animate(
            withDuration: ProteinSizes.AtomDetails.animationDuration,
            delay: .zero,
            usingSpringWithDamping: 0.7,
            initialSpringVelocity: 1,
            options: .curveEaseIn,
            animations: { [weak self] in
                self?.atomDetailsView.transform = CGAffineTransform(translationX: 0,
                                                                    y: ProteinSizes.AtomDetails.hegiht)
                self?.atomDetailsView.alpha = 0
            },
            completion: { [weak self] _ in
                self?.atomDetailsView.isHidden = true
                self?.atomDetailsView.transform = .identity
                self?.atomDetailsView.alpha = 1
            }
        )
    }
    
    private func manageSelectedNode(node: SCNNode) {
        print("Node NAme - \(node.name!)")
        presenter.getAtomDetails(name: node.name)
    }
    
    private func animateDownDetailsViewCenterTransition() {
        let targetCenter = CGPoint(
            x: defaultDetailsViewCenter.x,
            y: defaultDetailsViewCenter.y + atomDetailsView.bounds.height
        )
        let defaultCenter = defaultDetailsViewCenter
        UIView.animate(
            withDuration: ProteinSizes.AtomDetails.panAnimationDuration,
            delay: .zero,
            options: .curveEaseIn,
            animations: { [weak self] in
                self?.atomDetailsView.center = targetCenter
                self?.atomDetailsView.alpha = 0
            },
            completion: { [weak self] _ in
                self?.atomDetailsView.isHidden = true
                self?.atomDetailsView.center = defaultCenter
                self?.atomDetailsView.alpha = 1
            }
        )
    }
    
    private func animateUpDetailsViewCenterTransition() {
        let defaultCenter = defaultDetailsViewCenter
        UIView.animate(
            withDuration: ProteinSizes.AtomDetails.panAnimationDuration,
            delay: .zero,
            options: .curveEaseIn,
            animations: { [weak self] in
                self?.atomDetailsView.center = defaultCenter
            },
            completion: nil
        )
    }
    
    @objc private func searchNode(sender: UITapGestureRecognizer) {
        guard sender.state == .ended,
              let view = sender.view as? SCNView
        else {
            atomDetailsViewAnimateOut()
            return
        }
        let location = sender.location(in: view)
        let results = view.hitTest(location, options: [.searchMode: 1])
                    .filter({ $0.node.name != nil && $0.node.name != ElementData.Prefixes.conect })
        guard let selectedNode = results.first?.node
        else {
            atomDetailsViewAnimateOut()
            return
        }
        presenter.getAtomDetails(name: selectedNode.name)
    }
    
    @objc private func moveDetailsView(sender: UIPanGestureRecognizer) {
        guard let detailsView = sender.view as? ProteinAtomDetailsView
        else {
            return
        }
        let translation = sender.translation(in: detailsView.superview)
        switch sender.state {
        case .began:
            detailsViewInitialCenter = detailsView.center

        case .changed:
            let newCenter: CGPoint
            if detailsViewInitialCenter.y + translation.y > defaultDetailsViewCenter.y {
                newCenter = CGPoint(x: detailsViewInitialCenter.x, y: detailsViewInitialCenter.y + translation.y)
            } else {
                newCenter = detailsViewInitialCenter
            }
            detailsView.center = newCenter
            
        default:
            if detailsView.center.y - defaultDetailsViewCenter.y > detailsView.bounds.height / 2 {
                animateDownDetailsViewCenterTransition()
            } else {
                animateUpDetailsViewCenterTransition()
            }
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
    
    func showAtomDetails(atom: AtomDetails?) {
        if let atomDetails = atom {
            atomDetailsView.setDetaildFields(atom: atomDetails)
        } else {
            atomDetailsView.showErrorView()
        }
        atomDetailsViewAnimateIn()
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
    
    private func makeAtomDetailsView() -> ProteinAtomDetailsView {
        let atomDetailsView = ProteinAtomDetailsView()
        atomDetailsView.layer.cornerRadius = ProteinSizes.AtomDetails.cornerRadius
        return atomDetailsView
    }
}

extension ProteinViewController {
    
    private func setConstraints() {
        setSceneViewConstraints()
        setSpinnerConstraints()
        setErrorViewConstraints()
        setAtomDetailsViewConstraints()
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
    private func setAtomDetailsViewConstraints() {
        atomDetailsView.snp.makeConstraints { maker in
            maker.leading.trailing.equalToSuperview()
            maker.height.equalTo(ProteinSizes.AtomDetails.hegiht)
            maker.bottom.equalToSuperview().offset(ProteinSizes.AtomDetails.bottomOffset)
        }
    }
}
