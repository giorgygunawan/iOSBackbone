//
//  MockURLDispatcher.swift
//  iOSBackbone
//
//  Created by Giorgy Gunawan on 8/10/20.
//  Copyright © 2020 joji. All rights reserved.
//

import Foundation

@testable import iOSBackbone

enum MockURLConstants {
    static let baseURL = "baseurl.com"
    static let successURL = "test/success"
    static let voidURL = "test/void"
    static let failURL = "test/error"
    static let illegalURL = "test/illegal"
    static let illegalURLReal = "! ! !"
    static let legalURL = [MockURLConstants.successURL, MockURLConstants.voidURL, MockURLConstants.failURL]
}

struct MockURLDispatcher: NetworkTransactionDispatcherable {
    public func dispatch(format: RequestFormat, onSuccessHandler: @escaping (Data) -> Void, onErrorHandler: @escaping (Error) -> Void) {
        if MockURLConstants.legalURL.contains(format.path) {
            if format.path == MockURLConstants.successURL {
                onSuccessHandler(JSONHelper.dataFromFile(file: format.stubFileName ?? "test"))
            } else if format.path == MockURLConstants.voidURL {
                onErrorHandler(NetworkTransactionError.voidDataFound)
                return
            }
        } else {
            onErrorHandler(NetworkTransactionError.incorrectUrlPath)
            return
        }
    }
}

