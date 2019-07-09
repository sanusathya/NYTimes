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
    var publishedDate: String?
    var source: String?
    var media: [Media]?
    
    var thumbnail: URL? {
        guard let media = media?.first else { return nil }
        if let mediaData = media.mediaMetaData?.first {
            return mediaData.url
        }
        return nil
    }
    
    var detailedThumbnail: URL? {
        guard let media = media?.first else { return nil }
        if let jumboMediaMetaData = media.mediaMetaData?.filter({$0.format == "superJumbo"}), let jumbo = jumboMediaMetaData.first {
            return jumbo.url
        }
        return nil
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        
        id              <- map["id"]
        url             <- (map["url"], URLTransform())
        adx_keywords    <- map["adx_keywords"]
        section         <- map["section"]
        byline          <- map["byline"]
        type            <- map["type"]
        title           <- map["title"]
        abstract        <- map["abstract"]
        publishedDate   <- map["published_date"]
        source          <- map["source"]
        media           <- map["media"]
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

extension Article {
    
    class Media: MappableObject {
        var type: String?
        var subType: String?
        var mediaMetaData: [MediaMetaData]?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            type          <- map["status"]
            subType       <- map["copyright"]
            mediaMetaData <- map["media-metadata"]
        }
    }
    
    class MediaMetaData: MappableObject {
        var url: URL?
        var format: String?
        
        override func mapping(map: Map) {
            super.mapping(map: map)
            
            url          <- (map["url"], URLTransform())
            format       <-  map["format"]
        }
    }
}

extension Article: Searchable {
    func passesSearch(for key: String) -> Bool {
        return title?.localizedCaseInsensitiveContains(key) ?? false
    }
}
