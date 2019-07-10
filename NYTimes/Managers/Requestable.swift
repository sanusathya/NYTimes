//
//  Requestable.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import Alamofire

protocol Requestable: URLRequestConvertible {
    
    var method: HTTPMethod { get }
    var module: Module? { get }
    var path: Path? { get }
    var subPath: SubPath? { get }
    var defaultParameters: Parameters? { get }
    var parameters: Parameters? { get }
    
    @discardableResult
    func request(with responseObject: @escaping (DefaultDataResponse) -> Void) -> DataRequest
    
    // TODO -- need to creare the below functions to work with Codable
//    @discardableResult
//    func request<T: BaseMappable>(mapToObject object: T?, with responseObject: @escaping (DataResponse<T>) -> Void) -> DataRequest

//    @discardableResult
//    func request<T: BaseMappable>(with responseArray: @escaping (DataResponse<[T]>) -> Void) -> DataRequest
    
    @discardableResult
    func request<T:Decodable>(with responseObject:  @escaping (DataResponse<T>) -> Void) -> DataRequest
}

extension Requestable {
    
    var method: HTTPMethod {
        return .get
    }
    
    var path: Path? {
        return nil
    }
    
    var subPath: SubPath? {
        return nil
    }
    
    var defaultParameters: Parameters? {
        return nil
    }
    
    var parameters: Parameters? {
        return nil
    }
    
    var url: URL {
        var url = ServiceManager.API.baseURl
        
        if let module = module, !module.name.isEmpty {
            url = url.appendingPathComponent(module.name)
        }
        
        if let path = path, !path.name.isEmpty {
            url = url.appendingPathComponent(path.name)
        }
        
        if let subPath = subPath, !subPath.name.isEmpty {
            url = url.appendingPathComponent(subPath.name)
        }
        
        return url
    }
    
    func asURLRequest() throws -> URLRequest {
        
        // update timeoutIntervalForRequest from router
        ServiceManager.shared.manager.session.configuration.timeoutIntervalForRequest = 60
        
        var requestParams = parameters
        if let defaultParameters = defaultParameters {
            requestParams = defaultParameters.merging(parameters ?? [:]) { _, custom in custom }
        }
        
        let urlRequest = try URLRequest(url: url, method: method)
        
        return try Alamofire.URLEncoding.queryString.encode(urlRequest, with: requestParams)
    }
    
    @discardableResult
    func request(with responseObject: @escaping (DefaultDataResponse) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self).response(completionHandler: responseObject).validateErrors()
    }

    @discardableResult
    func request<T: Decodable>(with responseObject: @escaping (DataResponse<T>) -> Void) -> DataRequest {
        return ServiceManager.shared.request(self).responseDecodableObject(completionHandler: responseObject).validateErrors()
    }
}

enum Module: String {
    
    case mostPopular
    
    var name: String {
        return "svc/\(rawValue.lowercased())/v2"
    }
}

enum Path: String {
    
    case mostViewed
    
    var name: String {
        return rawValue.lowercased()
    }
}

enum SubPath {
    
    case sectionPeriod(section: String, period: String)
    
    var name: String {
        switch self {
        case .sectionPeriod(let section, let period): return "/\(section)/\(period).json"
        }
    }
}
