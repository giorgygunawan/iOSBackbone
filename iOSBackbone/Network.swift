//
//  Network.swift
//  iOSBackbone
//
//  Created by Giorgy Gunawan on 8/10/20.
//  Copyright © 2020 joji. All rights reserved.
//

import Foundation

protocol NetworkTransactionDispatcherable {
     func dispatch(format: RequestFormat, onSuccessHandler: @escaping (Data) -> Void, onErrorHandler: @escaping (Error) -> Void)
}

enum NetworkTransactionError: Swift.Error {
    case incorrectUrlPath
    case voidDataFound
    case other
}

struct URLSessionNetworkDispatcher: NetworkTransactionDispatcherable {
    public static let shared = URLSessionNetworkDispatcher()
    weak var urlSession: URLSession?
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    public func dispatch(format: RequestFormat, onSuccessHandler: @escaping (Data) -> Void, onErrorHandler: @escaping (Error) -> Void) {
        if let url = URL(string: format.baseURL + format.path) {
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            if let queryParams = format.queryParameters {
                components?.queryItems = queryParams.map { (key, value) in
                    URLQueryItem(name: key, value: value)
                }
            }
            guard let requestUrl = components?.url else {
                onErrorHandler(NetworkTransactionError.incorrectUrlPath)
                return
            }
            var urlRequest = URLRequest(url: requestUrl)
            urlRequest.httpMethod = format.method.rawValue
            urlRequest.allHTTPHeaderFields = format.headerParameters
            do {
                if let params = format.parameters {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [.prettyPrinted])
                }
            } catch let error {
                onErrorHandler(error)
                return
            }
            urlSession?.dataTask(with: urlRequest) { (data, response, error) in
                if let error = error {
                    onErrorHandler(error)
                    return
                }
                if let data = data {
                    onSuccessHandler(data)
                } else {
                    onErrorHandler(NetworkTransactionError.voidDataFound)
                    return
                }
            }.resume()
        } else {
            onErrorHandler(NetworkTransactionError.incorrectUrlPath)
            return
        }
    }
}
