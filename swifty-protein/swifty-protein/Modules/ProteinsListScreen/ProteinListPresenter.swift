//
//  ProteinListPresenter.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/9/22.
//

import UIKit

protocol ProteinListPresenterProtocol {
    func fetchLigands()
    func searchLigandsInList(ligands: [String], searchData: String)
}

final class ProteinListPresenter: ProteinListPresenterProtocol {
    
    private weak var viewController: ProteinListViewControllerProtocol!
    private let ligandsService: LigandsServiceProtocol
    
    init(viewController: ProteinListViewControllerProtocol,
         ligandsService: LigandsServiceProtocol) {
        self.viewController = viewController
        self.ligandsService = ligandsService
    }
    
    func fetchLigands() {
        ligandsService.getLigands { [weak self] ligands in
            DispatchQueue.main.async {
                guard let ligands = ligands
                else {
                    self?.viewController.showErrorPopup()
                    return
                }
                self?.viewController.setLigands(ligands, isFull: true)
            }
        }
    }
    
    func searchLigandsInList(ligands: [String], searchData: String) {
        let filtered = ligands.filter { ligand in
            return ligand.lowercased().contains(searchData.lowercased())
        }
        viewController.setLigands(filtered, isFull: false)
    }
}
