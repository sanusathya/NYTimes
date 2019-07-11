//
//  ServiceManager.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import Alamofire

class ServiceManager {
    
    static let shared = ServiceManager()
    
    var manager: Alamofire.SessionManager
    
    private init() {
        manager = Alamofire.SessionManager(configuration: URLSessionConfiguration.default)
    }

    func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        return manager.request(urlRequest)
    }
}

extension ServiceManager {
    
    class ServiceAdapter: RequestAdapter {
        
        func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
            var urlRequest = urlRequest
            
            // customize headers for the request here
            urlRequest.setValue("application/json", forHTTPHeaderField: "content-type")
            return urlRequest
        }
    }
}

extension ServiceManager {
    struct API {
        static var baseURl: URL {
            return URL(string: "https://api.nytimes.com") ?? URL(fileURLWithPath: "https://api.nytimes.com")
        }
    }
}
