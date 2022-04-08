//
//  NetworkConfiguration.swift
//  StartProject-ios
//
//  Created by Rustam Nurgaliev on 23.05.2021.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

enum NetworkConfiguration {
    // MARK: Constants
    
    enum Environment: String {
        case prod
        case dev
        
        var address: String {
            switch self {
            case .prod:
                return "https://prod"
                
            case .dev:
                return "http://dev"
            }
        }
    }

    static var url: URL {
        #if PROD
        guard let url = URL(string: Environment.prod.address) else { fatalError() }
        return url
        #else
        return BundleSettingsURL(defaultURLString: Environment.dev.address).url
        #endif
    }
}
