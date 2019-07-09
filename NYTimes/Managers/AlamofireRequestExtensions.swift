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
        
        return validate { (request, response, data) -> Alamofire.Request.ValidationResult in
            
            let code = response.statusCode
            var result: Alamofire.Request.ValidationResult = .success
            
            if code == 401 || code == 500 {
                let error = NYError(description: "System is temporarily unavailable", code: code)
                result = .failure(error)
            }
            
            guard let data = data, let _ = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any]  else {
                let error = NYError(description: "Something went wrong!!!", code: code)
                return .failure(error)
            }
            
            return result
        }
        
        .validate()
        .debug()
    }
}
