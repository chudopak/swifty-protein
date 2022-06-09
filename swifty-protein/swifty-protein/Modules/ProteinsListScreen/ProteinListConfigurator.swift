//
//  ProteinListConfigurator.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/8/22.
//

import UIKit

final class ProteinListConfigurator {
    
    func setupModule() -> ProteinListViewController {
        let vc = ProteinListViewController()
        let ligandsService = LigandsService(networkLayer: NetworkLayer())
        let presenter = ProteinListPresenter(viewController: vc,
                                             ligandsService: ligandsService)
        vc.setupComponents(presenter: presenter)
        return vc
    }
}
