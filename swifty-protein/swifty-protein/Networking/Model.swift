//
//  Model.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/9/22.
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
