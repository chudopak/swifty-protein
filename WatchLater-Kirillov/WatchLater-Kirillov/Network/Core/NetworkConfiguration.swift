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
                return "watchlater.cloud.technokratos.com"
                
            case .dev:
                return "watchlater.cloud.technokratos.com"
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
    
    static var urlString: String {
        #if PROD
        return Environment.prod.address
        #else
        return Environment.dev.address
        #endif
    }
    static let sceme = "https"
    
    enum Headers {
        static let acceptJSON = (field: "Accept", value: "application/json")
        static let contentTypeJSON = (field: "Content-Type", value: "application/json; charset=utf-8")
        static let authorisation = "Authorization"
    }
}
