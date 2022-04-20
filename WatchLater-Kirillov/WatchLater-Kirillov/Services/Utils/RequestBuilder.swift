//
//  RequestBuilder.swift
//  StartProject-ios
//
//  Created by Stepan Kirillov on 4/20/22.
//  Copyright © 2021 TEKHNOKRATIYA. All rights reserved.
//

import UIKit
import Alamofire

protocol URLRequestBuilder: URLRequestConvertible {
    var urlRequest: URLRequest { get set }
}

struct RequestBuilder: URLRequestBuilder {

    var urlRequest: URLRequest
    
    func asURLRequest() throws -> URLRequest {
        return urlRequest
    }
}
