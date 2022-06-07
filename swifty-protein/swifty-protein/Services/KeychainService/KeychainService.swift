//
//  KeychainService.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/7/22.
//

import UIKit
import KeychainSwift

enum KeychainService {
    
    enum Keys: String {
        case password
        case recreatePasswordAnswer
    }
    
    private static let keychain = KeychainSwift()
    
    static func set(data: String, key: Keys) -> Bool {
        return keychain.set(data, forKey: key.rawValue)
    }
    
    static func set(data: Bool, key: Keys) -> Bool {
        return keychain.set(data, forKey: key.rawValue)
    }
    
    static func set(data: Data, key: Keys) -> Bool {
        return keychain.set(data, forKey: key.rawValue)
    }
    
    static func getString(key: Keys) -> String? {
        return keychain.get(key.rawValue)
    }
    
    static func getBool(key: Keys) -> Bool? {
        return keychain.getBool(key.rawValue)
    }
    
    static func getData(key: Keys) -> Data? {
        return keychain.getData(key.rawValue)
    }
    
    static func delete(key: Keys) -> Bool {
        return keychain.delete(key.rawValue)
    }
    
    static func clear() -> Bool {
        return keychain.clear()
    }
}
