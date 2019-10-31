//
//  NetworkDispatcher.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

protocol NetworkDispatcher {
    func dispatch(requestData: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) -> URLSessionTask?
}

struct URLSessionNetworkDispatcher: NetworkDispatcher {
    
    func dispatch(requestData: RequestData, onSuccess: @escaping (Data) -> Void, onError: @escaping (Error) -> Void) -> URLSessionTask? {
        let result = buildRequest(from: requestData)
        var request: URLRequest
        
        switch result {
        case .success(let _request):
            request = _request
        case .failure(let _error):
            onError(_error)
            return nil
        }
        
        #if DEBUG
//        NetworkLogger.logRequest(request)
        #endif
        
        let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                onError(error)
                return
            }
            
            guard let data = data else {
                onError(NetworkError.noData)
                return
            }
            
            #if DEBUG
//            if let json = try? JSONSerialization.jsonObject(with: data, options: []) {
//                NetworkLogger.logResponse(from: requestData.endpoint, response: json)
//            }
            #endif
            
            onSuccess(data)
        }
        
        dataTask.resume()
        
        return dataTask
    }

}

private extension URLSessionNetworkDispatcher {
    
    func buildRequest(from requestData: RequestData) -> Result<URLRequest, Error> {
        let path = (requestData.method == .get) ? buildPathWithParams(from: requestData) : requestData.endpoint.path
        
        guard let url = URL(string: path) else {
            return .failure(NetworkError.invalidURL)
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestData.method.rawValue
        
        do {
            if !requestData.parameters.isEmpty, requestData.method != .get {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: requestData.parameters)
            }
        } catch {
            return .failure(error)
        }
        
        if !requestData.headers.isEmpty {
            urlRequest.allHTTPHeaderFields = requestData.headers
        }
        
        return .success(urlRequest)
    }
    
    func buildPathWithParams(from requestData: RequestData) -> String {
        var components = URLComponents(string: requestData.endpoint.path)

        components?.queryItems =
            requestData.parameters
            .compactMapValues { $0 as? String }
            .map { URLQueryItem(name: $0, value: $1) }
        
        return components?.url?.absoluteString ?? requestData.endpoint.path
    }
    
}
