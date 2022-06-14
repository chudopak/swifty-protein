//
//  ProteinPresenter.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/9/22.
//

import UIKit

protocol ProteinPresenterProtocol {
    func fetchProteinData(name: String)
}

final class ProteinPresenter: ProteinPresenterProtocol {
    
    private weak var viewController: ProteinViewControllerProtocol!
    private let ligandsService: LigandsServiceProtocol
    
    init(viewController: ProteinViewControllerProtocol,
         ligandsService: LigandsServiceProtocol) {
        self.viewController = viewController
        self.ligandsService = ligandsService
    }
    
    func fetchProteinData(name: String) {
        ligandsService.fetchProteinData(name: name) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let proteinData):
                    for i in proteinData.elements {
                        print(i.coordinates, i.name, i.color)
                    }
                    
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
