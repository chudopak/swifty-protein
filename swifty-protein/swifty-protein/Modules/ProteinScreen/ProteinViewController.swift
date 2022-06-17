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
    
    private var selectedNode: SCNNode?
    private var savedGeometry: SCNGeometry?
    
    private var isDetailsViewAnimating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: SFSymbols.share),
            style: .plain,
            target: self,
            action: #selector(shareProtein)
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
    
    private func returnAtomInNormalState() {
        selectedNode?.removeAllActions()
        selectedNode?.scale = SCNVector3(1, 1, 1)
        selectedNode = nil
    }
    
    private func runScaleInOutAction() {
        guard let node = selectedNode
        else {
            return
        }
        let secuence = SCNAction.sequence([
            SCNAction.scale(to: 0.75, duration: 0.3),
            SCNAction.scale(to: 1.25, duration: 0.3)
        ])
        let action = SCNAction.repeatForever(secuence)
        node.runAction(action)
    }
    
    private func atomDetailsViewAnimateIn() {
        atomDetailsView.transform = CGAffineTransform(translationX: .zero,
                                                      y: ProteinSizes.AtomDetails.hegiht)
        atomDetailsView.alpha = .zero
        atomDetailsView.isHidden = false
        isDetailsViewAnimating = true
        UIView.animate(
            withDuration: ProteinSizes.AtomDetails.animationDuration,
            delay: .zero,
            usingSpringWithDamping: ProteinSizes.AtomDetails.springWithDamping,
            initialSpringVelocity: ProteinSizes.AtomDetails.springVelocity,
            options: .curveEaseIn,
            animations: { [weak self] in
                self?.atomDetailsView.transform = .identity
                self?.atomDetailsView.alpha = 1
            },
            completion: { [weak self] _ in
                self?.isDetailsViewAnimating = false
            }
        )
    }
    
    private func atomDetailsViewAnimateOut() {
        isDetailsViewAnimating = true
        UIView.animate(
            withDuration: ProteinSizes.AtomDetails.animationDuration,
            delay: .zero,
            usingSpringWithDamping: ProteinSizes.AtomDetails.springWithDamping,
            initialSpringVelocity: ProteinSizes.AtomDetails.springVelocity,
            options: .curveEaseIn,
            animations: { [weak self] in
                self?.atomDetailsView.transform = CGAffineTransform(translationX: .zero,
                                                                    y: ProteinSizes.AtomDetails.hegiht)
                self?.atomDetailsView.alpha = .zero
            },
            completion: { [weak self] _ in
                self?.isDetailsViewAnimating = false
                self?.atomDetailsView.isHidden = true
                self?.atomDetailsView.transform = .identity
                self?.atomDetailsView.alpha = 1
            }
        )
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
                self?.atomDetailsView.alpha = .zero
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
        if isDetailsViewAnimating {
            return
        }
        returnAtomInNormalState()
        guard sender.state == .ended,
              let view = sender.view as? SCNView
        else {
            if !atomDetailsView.isHidden {
                atomDetailsViewAnimateOut()
            }
            return
        }
        let location = sender.location(in: view)
        let results = view.hitTest(location, options: [.searchMode: 1])
                    .filter({ $0.node.name != nil && $0.node.name != ElementData.Prefixes.conect })
        guard let selectedNode = results.first?.node
        else {
            if !atomDetailsView.isHidden {
                atomDetailsViewAnimateOut()
            }
            return
        }
        self.selectedNode = selectedNode
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
                returnAtomInNormalState()
            } else {
                animateUpDetailsViewCenterTransition()
            }
        }
    }
    
    @objc private func shareProtein() {
        UIGraphicsBeginImageContextWithOptions(self.view.frame.size, true, 0.0)
        self.view.drawHierarchy(in: self.view.frame, afterScreenUpdates: false)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let image = img {
            let activityViewController = UIActivityViewController(
                activityItems: ["That is \(ligand) ligand", image],
                applicationActivities: nil
            )
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.excludedActivityTypes = [ .airDrop ]
            self.present(activityViewController, animated: true, completion: nil)
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
        runScaleInOutAction()
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
