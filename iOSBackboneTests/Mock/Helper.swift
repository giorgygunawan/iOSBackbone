//
//  Helper.swift
//  iOSBackbone
//
//  Created by Giorgy Gunawan on 8/10/20.
//  Copyright © 2020 joji. All rights reserved.
//

import Foundation

class ImageHelper {
    static func dataFromFile(file: String) -> Data {
        if let data = Bundle(for: self).path(forResource: file, ofType: "png")
            .map({ URL(fileURLWithPath: $0) })
            .flatMap({ try? Data(contentsOf: $0) }) {
            return data
        } else {
            return "data not available".data(using: .utf8)!
        }
    }
}

class JSONHelper {
    static func dataFromFile(file: String) -> Data {
        if let data = Bundle(for: self).path(forResource: file, ofType: "json")
            .map({ URL(fileURLWithPath: $0) })
            .flatMap({ try? Data(contentsOf: $0) }) {
            return data
        } else {
            return "data not available".data(using: .utf8)!
        }
    }
}
