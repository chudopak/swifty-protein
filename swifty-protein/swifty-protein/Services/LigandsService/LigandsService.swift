//
//  LigandsService.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/9/22.
//

import UIKit
import Alamofire

protocol LigandsServiceProtocol {
    func getLigands(completion: @escaping ([String]?) -> Void)
}

final class LigandsService: LigandsServiceProtocol {
    
    private enum LigandsFile {
        static let directory = "Resources"
        static let name = "ligands"
        static let fileExtension = "txt"
    }
    
    private let networkLayer: NetworkLayerProtocol
    
    init(networkLayer: NetworkLayerProtocol) {
        self.networkLayer = networkLayer
    }
    
    func getLigands(completion: @escaping ([String]?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let fileName = Bundle.main.path(forResource: LigandsFile.name,
                                                  ofType: LigandsFile.fileExtension),
                  let data = try? NSString(contentsOfFile: fileName,
                                           encoding: String.Encoding.utf8.rawValue) as String
            
            else {
                self?.fetchLigands(urlString: NetworkConfiguration.pathToLigandsFile,
                                   completion: completion)
                return
            }
            completion(splitString(str: data, separator: "\n"))
        }
    }
    
    private func fetchLigands(urlString: String,
                              completion: @escaping ([String]?) -> Void) {
        guard let url = URL(string: urlString)
        else {
            completion(nil)
            return
        }
        networkLayer.request(url: url) { data, response, error in
            guard error == nil,
                  let responsHTTP = response as? HTTPURLResponse,
                  responsHTTP.statusCode == 200,
                  let data = data,
                  let string = String(data: data, encoding: .utf8)
            else {
                completion(nil)
                return
            }
            completion(splitString(str: string, separator: "\n"))
        }
    }
}
