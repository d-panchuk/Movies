//
//  NetworkLogger.swift
//  Movies
//
//  Copyright © 2019 dpanchuk. All rights reserved.
//

import Foundation

struct NetworkLogger {
    
    static func logRequest(_ request: URLRequest) {
        print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        
        var logOutput = """
                        \(urlAsString)
                        \(method) \(path)?\(query) HTTP/1.1
                        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        print(logOutput)
    }
    
    static func logResponse(from endpoint: Endpoint, response: Any) {
        print("Received response from \(endpoint.path)")
        print(getPrintableJSON(response))
    }
    
}

private extension NetworkLogger {
    
    static func getPrintableJSON(_ json: Any) -> String {
        let _json = json as AnyObject
        return getPrintableJSON(_json, prettyPrinted: true)
    }
    
    static func getPrintableJSON(_ value: AnyObject, prettyPrinted: Bool = true) -> String {
        let options = prettyPrinted ?
            JSONSerialization.WritingOptions.prettyPrinted :
            JSONSerialization.WritingOptions(rawValue: 0)
        
        if JSONSerialization.isValidJSONObject(value) {
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            } catch {
                print("Error during getting printable JSON")
            }
        }
        
        return ""
    }
    
}
