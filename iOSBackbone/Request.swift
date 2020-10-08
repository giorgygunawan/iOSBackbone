//
//  Request.swift
//  iOSBackbone
//
//  Created by Giorgy Gunawan on 8/10/20.
//  Copyright © 2020 joji. All rights reserved.
//

import Foundation

enum HTTPMethod: String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case DELETE = "DELETE"
}

struct RequestFormat {
    let baseURL: String
    let path: String
    let method: HTTPMethod
    let parameters: [String: Any?]?
    let queryParameters: [String: String]?
    let headerParameters: [String: String]?
    let stubFileName: String?
    
    init(baseURL: String, path: String, method: HTTPMethod, parameters: [String: Any?]? = nil, queryParameters: [String:String]? = nil, headerParameters: [String: String]? = nil, stubFileName: String? = nil) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.parameters = parameters
        self.queryParameters = queryParameters
        self.headerParameters = headerParameters
        self.stubFileName = stubFileName
    }
}

protocol Requestable {
    associatedtype ResponseType: Codable
    var format: RequestFormat { get }
}

extension Requestable {
    func request(dispatcher: NetworkTransactionDispatcherable = URLSessionNetworkDispatcher.shared, onSuccess: @escaping (ResponseType) -> Void, onError: @escaping (Error) -> Void) {
        dispatcher.dispatch(format: self.format, onSuccessHandler: { (data: Data) in
            do {
                let jsonDecoder = JSONDecoder()
                let result = try jsonDecoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    onSuccess(result)
                }
            } catch let error {
                DispatchQueue.main.async {
                    onError(error)
                }
            }
        }, onErrorHandler: { (error: Error) in
            DispatchQueue.main.async {
                onError(error)
            }
        })
    }
}
