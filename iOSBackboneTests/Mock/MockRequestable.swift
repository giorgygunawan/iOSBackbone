//
//  MockRequestable.swift
//  iOSBackbone
//
//  Created by Giorgy Gunawan on 8/10/20.
//  Copyright © 2020 joji. All rights reserved.
//

import Foundation
@testable import iOSBackbone

struct MockRequestable: Requestable {
    typealias ResponseType = MockCodable
    var format: RequestFormat
    init(format: RequestFormat) {
        self.format = RequestFormat(baseURL: "", path: format.path, method: format.method, parameters: format.parameters, headerParameters: format.headerParameters, stubFileName: format.stubFileName)
    }
}
