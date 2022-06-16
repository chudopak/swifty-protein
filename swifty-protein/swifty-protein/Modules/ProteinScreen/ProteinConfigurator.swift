//
//  ProteinConfigurator.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/9/22.
//

import UIKit

final class ProteinConfigurator {
    
    func setupModule(ligand: String) -> ProteinViewController {
        let vc = ProteinViewController()
        let ligandService = LigandsService(networkLayer: NetworkLayer())
        let presenter = ProteinPresenter(
            viewController: vc,
            ligandsService: ligandService,
            atomsService: AtomsService()
        )
        vc.setupComponents(presenter: presenter)
        vc.setLigandName(ligand)
        return vc
    }
}
