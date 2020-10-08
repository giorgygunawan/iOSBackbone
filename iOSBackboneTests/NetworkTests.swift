//
//  NetworkTests.swift
//  iOSBackbone
//
//  Created by Giorgy Gunawan on 8/10/20.
//  Copyright © 2020 joji. All rights reserved.
//

import XCTest

@testable import iOSBackbone

class NetworkTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_request_correctURL_dataNotEmpty() {
        let requestSuccess = expectation(description: "requestSuccess")
        let requestFail = expectation(description: "requestFail")
        requestFail.isInverted = true
        MockRequestable(format: RequestFormat(baseURL: MockURLConstants.baseURL, path: MockURLConstants.successURL, method: .GET, stubFileName: "test")).request(dispatcher: MockURLDispatcher(), onSuccess: { data in
            requestSuccess.fulfill()
            XCTAssertNotNil(data.test)
        }) { error in
            requestFail.fulfill()
        }
        wait(for: [requestSuccess, requestFail], timeout: 0.1)
    }
    
    func test_request_correctURL_dataEmpty() {
        let requestSuccess = expectation(description: "requestSuccess")
        let requestFail = expectation(description: "requestFail")
        requestSuccess.isInverted = true
        MockRequestable(format: RequestFormat(baseURL: MockURLConstants.baseURL, path: MockURLConstants.voidURL, method: .GET)).request(dispatcher: MockURLDispatcher(), onSuccess: { data in
            requestSuccess.fulfill()
        }) { error in
            XCTAssertTrue(error.localizedDescription == NetworkTransactionError.voidDataFound.localizedDescription)
            requestFail.fulfill()
        }
        wait(for: [requestSuccess, requestFail], timeout: 0.1)
    }
    
    func test_request_incorrectURL() {
        let requestSuccess = expectation(description: "requestSuccess")
        let requestFail = expectation(description: "requestFail")
        requestSuccess.isInverted = true
        MockRequestable(format: RequestFormat(baseURL: MockURLConstants.baseURL, path: MockURLConstants.illegalURL, method: .GET)).request(dispatcher: MockURLDispatcher(), onSuccess: { data in
            requestSuccess.fulfill()
        }) { error in
            XCTAssertTrue(error.localizedDescription == NetworkTransactionError.incorrectUrlPath.localizedDescription)
            requestFail.fulfill()
        }
        wait(for: [requestSuccess, requestFail], timeout: 0.1)
    }
    
    func test_request_ErrorJSONDecode() {
        let requestSuccess = expectation(description: "requestSuccess")
        let requestFail = expectation(description: "requestFail")
        requestSuccess.isInverted = true
        MockRequestable(format: RequestFormat(baseURL: MockURLConstants.baseURL, path: MockURLConstants.successURL, method: .GET, stubFileName: "other")).request(dispatcher: MockURLDispatcher(), onSuccess: { data in
            requestSuccess.fulfill()
        }) { error in
            requestFail.fulfill()
        }
        wait(for: [requestSuccess, requestFail], timeout: 0.1)
    }
    
    func test_networkDispatcher_success_dataNotEmpty() {
        let requestSuccess = expectation(description: "requestSuccess")
        let requestFail = expectation(description: "requestFail")
        requestFail.isInverted = true
        let urlSession = MockURLSession()
        urlSession.data = JSONHelper.dataFromFile(file: "test")
        let networkDispatcher = URLSessionNetworkDispatcher(urlSession: urlSession)
        networkDispatcher.dispatch(format: RequestFormat(baseURL: MockURLConstants.baseURL, path: MockURLConstants.successURL, method: .GET), onSuccessHandler: { data in
            XCTAssertNotNil(data)
            requestSuccess.fulfill()
        }, onErrorHandler: { error in
            requestFail.fulfill()
        })
        wait(for: [requestSuccess, requestFail], timeout: 0.1)
    }
    
    func test_networkDispatcher_success_paramNotEmpty() {
        let requestSuccess = expectation(description: "requestSuccess")
        let requestFail = expectation(description: "requestFail")
        requestFail.isInverted = true
        let urlSession = MockURLSession()
        var parameters = [String: Any]()
        parameters["test"] = "test"
        urlSession.data = JSONHelper.dataFromFile(file: "test")
        let networkDispatcher = URLSessionNetworkDispatcher(urlSession: urlSession)
        networkDispatcher.dispatch(format: RequestFormat(baseURL: MockURLConstants.baseURL, path: MockURLConstants.successURL, method: .GET, parameters: parameters), onSuccessHandler: { data in
            XCTAssertNotNil(data)
            requestSuccess.fulfill()
        }, onErrorHandler: { error in
            requestFail.fulfill()
        })
        wait(for: [requestSuccess, requestFail], timeout: 0.1)
    }
    
    func test_networkDispatcher_success_queryParamNotEmpty() {
        let requestSuccess = expectation(description: "requestSuccess")
        let requestFail = expectation(description: "requestFail")
        requestFail.isInverted = true
        let urlSession = MockURLSession()
        var parameters = [String: String]()
        parameters["test"] = "test"
        urlSession.data = JSONHelper.dataFromFile(file: "test")
        let networkDispatcher = URLSessionNetworkDispatcher(urlSession: urlSession)
        networkDispatcher.dispatch(format: RequestFormat(baseURL: MockURLConstants.baseURL, path: MockURLConstants.successURL, method: .GET, queryParameters: parameters), onSuccessHandler: { data in
            XCTAssertNotNil(data)
            requestSuccess.fulfill()
        }, onErrorHandler: { error in
            requestFail.fulfill()
        })
        wait(for: [requestSuccess, requestFail], timeout: 0.1)
    }
    
    func test_networkDispatcher_illegalUrl() {
        let requestSuccess = expectation(description: "requestSuccess")
        let requestFail = expectation(description: "requestFail")
        requestSuccess.isInverted = true
        let urlSession = MockURLSession()
        let networkDispatcher = URLSessionNetworkDispatcher(urlSession: urlSession)
        networkDispatcher.dispatch(format: RequestFormat(baseURL: MockURLConstants.baseURL, path: MockURLConstants.illegalURLReal, method: .GET), onSuccessHandler: { data in
            requestSuccess.fulfill()
        }, onErrorHandler: { error in
            requestFail.fulfill()
        })
        wait(for: [requestSuccess, requestFail], timeout: 0.1)
    }
    
    func test_networkDispatcher_fail_dataEmpty() {
        let requestSuccess = expectation(description: "requestSuccess")
        let requestFail = expectation(description: "requestFail")
        requestSuccess.isInverted = true
        let urlSession = MockURLSession()
        let networkDispatcher = URLSessionNetworkDispatcher(urlSession: urlSession)
        networkDispatcher.dispatch(format: RequestFormat(baseURL: MockURLConstants.baseURL, path: MockURLConstants.successURL, method: .GET), onSuccessHandler: { data in
            requestSuccess.fulfill()
        }, onErrorHandler: { error in
            XCTAssertTrue(error.localizedDescription == NetworkTransactionError.voidDataFound.localizedDescription)
            requestFail.fulfill()
        })
        wait(for: [requestSuccess, requestFail], timeout: 0.1)
    }
    
    func test_networkDispatcher_fail_otherErrors() {
        let requestSuccess = expectation(description: "requestSuccess")
        let requestFail = expectation(description: "requestFail")
        requestSuccess.isInverted = true
        let urlSession = MockURLSession()
        urlSession.error = NetworkTransactionError.other
        let networkDispatcher = URLSessionNetworkDispatcher(urlSession: urlSession)
        networkDispatcher.dispatch(format: RequestFormat(baseURL: MockURLConstants.baseURL, path: MockURLConstants.successURL, method: .GET), onSuccessHandler: { data in
            requestSuccess.fulfill()
        }, onErrorHandler: { error in
            XCTAssertTrue(error.localizedDescription == NetworkTransactionError.other.localizedDescription)
            requestFail.fulfill()
        })
        wait(for: [requestSuccess, requestFail], timeout: 0.1)
    }
}
