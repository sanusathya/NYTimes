//
//  AlamofireRequestExtensions.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import Alamofire
import SwiftyBeaver

typealias Log = SwiftyBeaver

public extension Alamofire.Request {
    
    func debug() -> Self {
        Log.info(debugDescription)
        return self
    }
}

public extension Alamofire.DataRequest {
    
    @discardableResult
    func validateErrors() -> Self {
        
        return validate { [weak self] (request, response, data) -> Alamofire.Request.ValidationResult in
            
            let code = response.statusCode
            let requestUrl = String(describing: request?.url?.absoluteString ?? "NO URL")
            var result: Alamofire.Request.ValidationResult = .success
            
            if code == 401 || code == 500 {
                let error = NYError(description: "System is temporarily unavailable", code: code)
                self?.log(code: code, url: requestUrl, message: error.localizedDescription, request: request)
                result = .failure(error)
            }
            
            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]  else {
                let error = NYError(description: "Something went wrong!!!", code: code)
                self?.log(code: code, url: requestUrl, message: error.localizedDescription, request: request)
                return .failure(error)
            }
            
            if let errors = json["fault"] as? [String: Any], let faultString = errors["faultstring"] as? String {
                let error = NYError(description: faultString, code: code)
                self?.log(code: code, url: requestUrl, message: error.localizedDescription, request: request)
                result = .failure(error)
            } else {
                self?.log(code: code, url: requestUrl, message: json as AnyObject, request: request)
                result = .success
            }
            return result
        }
        .validate()
        .debug()
    }
    
    private func log(code: Int, url: String, message: Any, request: URLRequest?) {
        
        Log.info("Status Code >>> \(code)")
        Log.info("URL >>> \(url)")
        Log.info("Request >>>> \(request?.allHTTPHeaderFields ?? [:])")
        Log.info("Response >>> \(message)")
    }
}


public extension Alamofire.DataRequest {
    
    private static func DecodableObjectSerializer<T: Decodable>(_ keyPath: String?, _ decoder: JSONDecoder) -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            if let error = error {
                return .failure(error)
            }
            if let keyPath = keyPath {
                if keyPath.isEmpty {
                    return .failure(AlamofireDecodableError.emptyKeyPath)
                }
                return DataRequest.decodeToObject(byKeyPath: keyPath, decoder: decoder, response: response, data: data)
            }
            return DataRequest.decodeToObject(decoder: decoder, response: response, data: data)
        }
    }
    
    private static func decodeToObject<T: Decodable>(decoder: JSONDecoder, response: HTTPURLResponse?, data: Data?) -> Result<T> {
        let result = Request.serializeResponseData(response: response, data: data, error: nil)
        
        switch result {
        case .success(let data):
            do {
                let object = try decoder.decode(T.self, from: data)
                return .success(object)
            }
            catch {
                return .failure(error)
            }
        case .failure(let error): return .failure(error)
        }
    }
    
    private static func decodeToObject<T: Decodable>(byKeyPath keyPath: String, decoder: JSONDecoder, response: HTTPURLResponse?, data: Data?) -> Result<T> {
        let result = Request.serializeResponseJSON(options: [], response: response, data: data, error: nil)
        
        switch result {
        case .success(let json):
            if let nestedJson = (json as AnyObject).value(forKeyPath: keyPath) {
                do {
                    guard JSONSerialization.isValidJSONObject(nestedJson) else {
                        return .failure(AlamofireDecodableError.invalidJSON)
                    }
                    let data = try JSONSerialization.data(withJSONObject: nestedJson)
                    let object = try decoder.decode(T.self, from: data)
                    return .success(object)
                }
                catch {
                    return .failure(error)
                }
            }
            else {
                return .failure(AlamofireDecodableError.invalidKeyPath)
            }
        case .failure(let error): return .failure(error)
        }
    }
    
    
    /// Adds a handler to be called once the request has finished.
    
    /// - parameter queue:             The queue on which the completion handler is dispatched.
    /// - parameter keyPath:           The keyPath where object decoding should be performed. Default: `nil`.
    /// - parameter decoder:           The decoder that performs the decoding of JSON into semantic `Decodable` type. Default: `JSONDecoder()`.
    /// - parameter completionHandler: The code to be executed once the request has finished and the data has been mapped by `JSONDecoder`.
    
    /// - returns: The request.
    
    @discardableResult
    func responseDecodableObject<T: Decodable>(queue: DispatchQueue? = nil, keyPath: String? = nil, decoder: JSONDecoder = JSONDecoder(), completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: DataRequest.DecodableObjectSerializer(keyPath, decoder), completionHandler: completionHandler)
    }
}


public enum AlamofireDecodableError: Error {
    case invalidKeyPath
    case emptyKeyPath
    case invalidJSON
}

extension AlamofireDecodableError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .invalidKeyPath:   return "Nested object doesn't exist by this keyPath."
        case .emptyKeyPath:     return "KeyPath can not be empty."
        case .invalidJSON:      return "Invalid nested json."
        }
    }
}
