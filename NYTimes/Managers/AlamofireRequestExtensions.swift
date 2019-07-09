//
//  AlamofireRequestExtensions.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import Alamofire
import ObjectMapper
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
