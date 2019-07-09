//
//  Article.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import ObjectMapper

class Article: MappableObject {

    var id: Int?
    var url : URL?
    var adx_keywords: String?
    var section: String?
    var byline: String?
    var type: String?
    var title: String?
    var abstract: String?
    var publishedDate: Date?
    var source: String?
    
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        id              <- map["id"]
        url             <- (map["url"], URLTransform())
        adx_keywords    <- map["adx_keywords"]
        section         <- map["section"]
        byline          <- map["adx_keywords"]
        type            <- map["type"]
        title           <- map["title"]
        abstract        <- map["abstract"]
        source          <- map["source"]
    }
}


extension Article {
    
    class SectionsResponse: MappableObject {
        var status: String?
        var copyright: String?
        var numberOfResults: Int?
        var articles: [Article]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            status          <- map["status"]
            copyright       <- map["copyright"]
            numberOfResults <- map["num_results"]
            articles        <- map["results"]
        }
    }
    
}
