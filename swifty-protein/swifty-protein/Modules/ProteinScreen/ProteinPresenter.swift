//
//  ProteinPresenter.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/9/22.
//

import UIKit

protocol ProteinPresenterProtocol {
    func fetchProteinData(name: String)
    func getAtomDetails(name: String?)
}

final class ProteinPresenter: ProteinPresenterProtocol {
    
    private weak var viewController: ProteinViewControllerProtocol!
    private let ligandsService: LigandsServiceProtocol
    private let atomsService: AtomsServiceProtocol
    
    init(viewController: ProteinViewControllerProtocol,
         ligandsService: LigandsServiceProtocol,
         atomsService: AtomsServiceProtocol) {
        self.viewController = viewController
        self.ligandsService = ligandsService
        self.atomsService = atomsService
    }
    
    func fetchProteinData(name: String) {
        ligandsService.fetchProteinData(name: name) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let proteinData):
                    self?.viewController.renderScene(with: proteinData)
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.viewController.showFailedView()
                }
            }
        }
    }
    
    func getAtomDetails(name: String?) {
        guard let atomName = name
        else {
            viewController.showAtomDetails(atom: nil)
            return
        }
        atomsService.fetchAtomData(name: atomName) { [weak self] atom in
            self?.viewController.showAtomDetails(atom: atom)
        }
    }
}
