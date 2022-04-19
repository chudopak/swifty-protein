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
                return Text.Api.host
                
            case .dev:
                return Text.Api.host
            }
        }
    }

    static var url: URL {
        #if PROD
        guard let url = URL(string: Environment.prod.address) else { fatalError("Base URL was not created for prod configuration in NetworkConfiguration.swift") }
        return url
        #else
        guard let url = URL(string: Environment.dev.address) else { fatalError("Base URL was not created for dev configuration in NetworkConfiguration.swift") }
        return BundleSettingsURL(defaultURL: url).url
        #endif
    }
}
