//
//  KeychainService.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/21/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import KeychainSwift

enum KeychainService {
    
    enum Keys: String {
        case accessToken
        case refreshToken
    }
    
    static let keychain = KeychainSwift()
    
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
