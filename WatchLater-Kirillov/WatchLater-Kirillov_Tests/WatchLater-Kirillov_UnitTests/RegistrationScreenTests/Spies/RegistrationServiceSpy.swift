//
//  RegistrationServiceSpy.swift
//  WatchLater-Kirillov_UnitTests
//
//  Created by Stepan Kirillov on 5/27/22.
//

import UIKit
@testable import WatchLater_Kirillov_Dev

class RegistrationServiceSpy: RegistrationServiceProtocol {
    
    var isCalled = false
    
    func register(with data: RegistrationData, completion: @escaping (RegistrationResponseState) -> Void) {
        isCalled = true
        completion(.success)
    }
}
