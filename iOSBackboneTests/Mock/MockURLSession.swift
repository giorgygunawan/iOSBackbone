//
//  MockURLSession.swift
//  iOSBackbone
//
//  Created by Giorgy Gunawan on 8/10/20.
//  Copyright © 2020 joji. All rights reserved.
//

import Foundation

class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void
    
    init(closure: @escaping () -> Void) {
        self.closure = closure
    }
    
    override func resume() {
        closure()
    }
}

class MockURLSession: URLSession {
    var data: Data?
    var error: Error?
    var urlResponse: URLResponse?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = self.data
        let urlResponse = self.urlResponse
        let error = self.error
        return URLSessionDataTaskMock {
            completionHandler(data, urlResponse, error)
        }
    }
    
    override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let data = self.data
        let urlResponse = self.urlResponse
        let error = self.error
        return URLSessionDataTaskMock {
            completionHandler(data, urlResponse, error)
        }
    }
}
