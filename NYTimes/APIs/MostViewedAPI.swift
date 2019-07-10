//
//  MostViewedAPI.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import Alamofire
import PromiseKit

class MostViewedAPI { }

extension MostViewedAPI {
    
    enum Router: Requestable {
        
        case mostViewed(section: String, timePeriod: String, offset: Int)
        
        var module: Module? {
            return .mostPopular
        }
        
        var path: Path? {
            return .mostViewed
        }
        
        var subPath: SubPath? {
            switch self {
            case .mostViewed(let section, let timePeriod, _): return .sectionPeriod(section: section, period: timePeriod)
            }
        }
        
        var defaultParameters: Parameters? {
            return ["api-key": "iViGaASPmx0cyUUEZ0KCrKGJARFVedAu"]
        }
    }
}

extension MostViewedAPI {
    
    @discardableResult
    static func fetchMostViewedArticles(section: String, timePeriod: String, offset: Int) -> Promise<Article.SectionsResponse?> {
        
        return Promise<Article.SectionsResponse?> { resolver in
            
            Router.mostViewed(section: section, timePeriod: timePeriod, offset: offset).request {(response: DataResponse<Article.SectionsResponse>) in
                
                guard response.error == nil else {
                    resolver.reject(response.error!)
                    return
                }
                
                resolver.fulfill(response.value)
            }
        }
    }
}
