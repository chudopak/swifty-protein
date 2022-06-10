//
//  ProteinModel.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/10/22.
//

import UIKit

struct ProteinData {
    let name: String
    let elements: [ElementData]
}

struct ElementData {
    let index: Int
    let name: String
    let color: UIColor
    let coordinates: Coordinates
    var conections: [Int]
    
    enum AtomDataPositions {
        static let wordsInLine = 12
        static let atom = 0
        static let index = 1
        static let x = 6
        static let y = 7
        static let z = 8
        static let name = 11
    }
    
    enum ConectDataPositions {
        static let conect = 0
        static let atomIndex = 1
        static let minWordsInline = 3
    }
    
    enum Prefixes {
        static let atom = "ATOM"
        static let conect = "CONECT"
    }
}

struct Coordinates {
    let x: Double
    let y: Double
    let z: Double
}

enum CPKColors {
    
    static let other = "other"
    
    static let elements: [String: UIColor] = {
        var elem = [String: UIColor]()
        elem["h"] = Asset.hydrogen.color
        elem["c"] = Asset.carbon.color
        elem["n"] = Asset.nitrogen.color
        elem["o"] = Asset.oxygen.color
        elem["f"] = Asset.fluorine.color
        elem["cl"] = Asset.chlorine.color
        elem["br"] = Asset.bromine.color
        elem["i"] = Asset.iodine.color
        elem["he"] = Asset.nobleGases.color
        elem["ne"] = Asset.nobleGases.color
        elem["ar"] = Asset.nobleGases.color
        elem["kr"] = Asset.nobleGases.color
        elem["xe"] = Asset.nobleGases.color
        elem["p"] = Asset.phosphorus.color
        elem["s"] = Asset.sulfur.color
        elem["li"] = Asset.alkaliMetals.color
        elem["na"] = Asset.alkaliMetals.color
        elem["k"] = Asset.alkaliMetals.color
        elem["rb"] = Asset.alkaliMetals.color
        elem["cs"] = Asset.alkaliMetals.color
        elem["fr"] = Asset.alkaliMetals.color
        elem["be"] = Asset.alkalineEarthMetals.color
        elem["mg"] = Asset.alkalineEarthMetals.color
        elem["ca"] = Asset.alkalineEarthMetals.color
        elem["sr"] = Asset.alkalineEarthMetals.color
        elem["ba"] = Asset.alkalineEarthMetals.color
        elem["ra"] = Asset.alkalineEarthMetals.color
        elem["ti"] = Asset.titanium.color
        elem["fe"] = Asset.iron.color
        elem["other"] = Asset.otherElements.color
        return elem
    }()
    
    static func getColor(string: String) -> UIColor {
        guard let color = elements[string.lowercased()]
        else {
            return elements[CPKColors.other]!
        }
        return color
    }
}
