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
