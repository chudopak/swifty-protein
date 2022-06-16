//
//  AtomsService.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/16/22.
//

import UIKit

protocol AtomsServiceProtocol {
    func fetchAtomData(name: String, completion: @escaping (AtomDetails?) -> Void)
}

final class AtomsService: AtomsServiceProtocol {
    
    private enum PeriodicTableFile {
        static let name = "PeriodicTable"
        static let fileExtension = "json"
    }
    
    private var atoms: [AtomDetails]?
    
    func fetchAtomData(name: String, completion: @escaping (AtomDetails?) -> Void) {
        if atoms == nil {
            guard let periodicTable = getPeriodicTable()
            else {
                completion(nil)
                return
            }
            atoms = periodicTable
        }
        completion(findAtom(name: name))
    }
    
    private func getPeriodicTable() -> [AtomDetails]? {
        guard let fileName = Bundle.main.path(forResource: PeriodicTableFile.name,
                                              ofType: PeriodicTableFile.fileExtension),
              let data = try? Data(contentsOf: URL(fileURLWithPath: fileName), options: .mappedIfSafe),
              let atomsParsed = decodeMessage(data: data, type: PeriodicTable.self)
        else {
            return nil
        }
        return atomsParsed.elements
    }
    
    private func findAtom(name: String) -> AtomDetails? {
        guard let atomsUnwrapped = atoms
        else {
            return nil
        }
        for atom in atomsUnwrapped where atom.symbol.lowercased() == name.lowercased() {
            return atom
        }
        return nil
    }
}
