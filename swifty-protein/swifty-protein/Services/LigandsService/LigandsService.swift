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
    func fetchProteinData(name: String,
                          completion: @escaping (Result<ProteinData, Error>) -> Void)
}

final class LigandsService: LigandsServiceProtocol {
    
    private enum LigandsFile {
        static let name = "ligands"
        static let fileExtension = "txt"
    }
    
    private enum LigandUrlData {
        static let path = "/ligands"
        static let postfix = "_ideal.pdb"
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
    
    func fetchProteinData(name: String,
                          completion: @escaping (Result<ProteinData, Error>) -> Void) {
        ProteinInfo.fetchProteinInfo(proteinName: name) { [weak self] proteinData in
            if let data = proteinData {
                print("GOt saved from core data")
                completion(.success(data))
            } else {
                self?.fetchProteinDataFromServer(name: name, completion: completion)
            }
        }
    }
    
    private func fetchProteinDataFromServer(
        name: String,
        completion: @escaping (Result<ProteinData, Error>) -> Void
    ) {
        guard let url = buildFetchProteinUrl(name: name)
        else {
            completion(.failure(BaseError.canNotBuildUrl("LigandsService, fetchProteinData")))
            return
        }
        networkLayer.request(url: url) { [weak self] data, response, error in
            guard error == nil,
                  let responsHTTP = response as? HTTPURLResponse,
                  responsHTTP.statusCode == 200,
                  let data = data,
                  let stringData = String(data: data, encoding: .utf8)
            else {
                if let error = error {
                    completion(.failure(error))
                } else if let responsHTTP = response as? HTTPURLResponse {
                    completion(.failure(BaseError.range400Response("LigandsService, fetchProteinData", responsHTTP.statusCode)))
                } else {
                    completion(.failure(BaseError.noData("LigandsService, fetchProteinData")))
                }
                return
            }
            self?.handleProteinData(name: name, data: stringData, completion: completion)
        }
    }
    
    private func handleProteinData(
        name: String,
        data: String,
        completion: @escaping (Result<ProteinData, Error>) -> Void
    ) {
        guard let proteinData = parseProteinData(name: name, data: data)
        else {
            completion(.failure(BaseError.canNotParseProteinData("LigandsService, parseProteinData")))
            return
        }
        completion(.success(proteinData))
        ProteinInfo.saveObject(proteinData: proteinData, predicate: nil)
    }
    
    private func parseProteinData(name: String,
                                  data: String) -> ProteinData? {
        var elements = [ElementData]()
        let splitedData = splitString(str: data, separator: "\n")
        for line in splitedData {
            let splitedLine = splitString(str: line, separator: " ")
            if splitedLine.isEmpty {
                continue
            } else if splitedLine[ElementData.AtomDataPositions.atom] == ElementData.Prefixes.atom {
                if let elem = getConstructElement(data: splitedLine, lastElemNumber: elements.count) {
                    elements.append(elem)
                } else {
                    return nil
                }
            } else if splitedLine[ElementData.ConectDataPositions.conect] == ElementData.Prefixes.conect {
                if !setElementConnection(elements: &elements, data: splitedLine) {
                    return nil
                }
            }
        }
        return ProteinData(name: name, elements: elements)
    }
    
    private func getConstructElement(data: [String], lastElemNumber: Int) -> ElementData? {
        guard data.count == ElementData.AtomDataPositions.wordsInLine,
              let x = Double(data[ElementData.AtomDataPositions.x]),
              let y = Double(data[ElementData.AtomDataPositions.y]),
              let z = Double(data[ElementData.AtomDataPositions.z])
        else {
            return nil
        }
        let index = Int(data[ElementData.AtomDataPositions.index]) ?? lastElemNumber
        let coordinates = Coordinates(
            x: x,
            y: y,
            z: z
        )
        return ElementData(
            index: index,
            name: data[ElementData.AtomDataPositions.name],
            color: CPKColors.getColor(string: data[ElementData.AtomDataPositions.name]),
            coordinates: coordinates,
            conections: [Int]()
        )
    }
    
    private func setElementConnection(elements: inout [ElementData], data: [String]) -> Bool {
        guard let elemIndex = Int(data[ElementData.ConectDataPositions.atomIndex]),
              data.count >= ElementData.ConectDataPositions.minWordsInline
        else {
            return false
        }
        var conections = [Int]()
        for i in 2..<data.count {
            if let index = Int(data[i]) {
                conections.append(index)
            } else {
                return false
            }
        }
        // Elements start count index from 1 thats why "- 1" below
        elements[elemIndex - 1].conections = conections
        return true
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
    
    private func buildFetchProteinUrl(name: String) -> URL? {
        guard !name.isEmpty
        else {
            return nil
        }
        let directory = String(name[name.startIndex])
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkConfiguration.sceme
        urlComponents.host = NetworkConfiguration.rcsbUrlString
        urlComponents.path = "\(LigandUrlData.path)/\(directory)/\(name)/\(name)\(LigandUrlData.postfix)"
        guard let url = urlComponents.url
        else {
            return nil
        }
        return url
    }
}
