//
//  IMDB-NetworkConfiguration.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 5/5/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import Foundation

enum IMDBNetworkConfiguration {
    // MARK: Constants
    
    enum Environment: String {
        case prod
        case dev
        
        var address: String {
            switch self {
            case .prod:
                return "imdb-api.com"
                
            case .dev:
                return "imdb-api.com"
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
    
    static let APIKey = "k_a336r7ma"
    //k_gcijso2v,k_the8z464
    enum Headers {
        static let acceptJSON = (field: "Accept", value: "application/json")
        static let contentTypeJSON = (field: "Content-Type", value: "application/json; charset=utf-8")
        static let authorisation = "Authorization"
    }
}
