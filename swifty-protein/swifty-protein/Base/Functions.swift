//
//  Functions.swift
//  swifty-protein
//
//  Created by Stepan Kirillov on 6/8/22.
//

import UIKit

func decodeMessage<T: Codable>(data: Data?, type: T.Type) -> T? {
    guard let data = data,
          let decoded = try? JSONDecoder().decode(type.self, from: data)
    else {
        return nil
    }
    return decoded
}

func decodeMessage<T: Codable>(data: Data?, type: [T].Type) -> [T]? {
    guard let data = data,
          let decoded = try? JSONDecoder().decode(type.self, from: data)
    else {
        return nil
    }
    return decoded
}

func splitString(str: String, separator: String.Element) -> [String] {
    let dataSplited = str.split(separator: separator)
    var arrayStrings = [String]()
    arrayStrings.reserveCapacity(dataSplited.count)
    for lingand in dataSplited {
        arrayStrings.append(String(lingand))
    }
    return arrayStrings
}
