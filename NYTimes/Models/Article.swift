//
//  Article.swift
//  NYTimes
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import Foundation

class Article: Codable {

    var id: Int?
    var url: URL?
    var adxKeywords: String?
    var section: String?
    var byline: String?
    var type: String?
    var title: String?
    var abstract: String?
    var publishedDate: String?
    var source: String?
    var media: [Media]?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case url
        case adxKeywords = "adx_keywords"
        case section
        case byline
        case type
        case title
        case abstract
        case publishedDate = "published_date"
        case source
        case media
    }
    
    var thumbnail: URL? {
        guard let media = media?.first else { return nil }
        if let standardThumbnail = media.mediaMetaData?.filter({$0.format == .standardThumbnail}), let thumbnail = standardThumbnail.first {
            return thumbnail.url
        }
        return nil
    }
    
    var detailedThumbnail: URL? {
        guard let media = media?.first else { return nil }
        if let jumboMediaMetaData = media.mediaMetaData?.filter({$0.format == .mediumThreeByTwo440}), let jumbo = jumboMediaMetaData.first {
            return jumbo.url
        }
        return nil
    }
}

extension Article {
    
    class SectionsResponse: Codable {
        var status: String?
        var copyright: String?
        var numberOfResults: Int?
        var articles: [Article]?
        
        private enum CodingKeys: String, CodingKey {
            case status
            case copyright
            case numberOfResults = "num_results"
            case articles = "results"
        }
    }
}

extension Article {
    
    class Media: Codable {
        var type: String?
        var subType: String?
        var mediaMetaData: [MediaMetaData]?
        
        private enum CodingKeys: String, CodingKey {
            case type
            case subType = "subtype"
            case mediaMetaData = "media-metadata"
        }
    }
    
    class MediaMetaData: Codable {
        var url: URL?
        var format = MultimediaFormat.unknown
    }
}

extension Article {
    enum MultimediaFormat: String, Codable {
        case square = "square320"
        case large = "Large"
        case jumbo = "Jumbo"
        case superJumbo = "superJumbo"
        case squareLarge = "square640"
        case standardThumbnail = "Standard Thumbnail"
        case largeThumbnail = "Large Thumbnail"
        case normal = "Normal"
        case mediumThreeByTwo210 = "mediumThreeByTwo210"
        case mediumThreeByTwo440 = "mediumThreeByTwo440"
        case unknown = "unknown"
    }
}

extension Article: Searchable {
    func passesSearch(for key: String) -> Bool {
        return title?.localizedCaseInsensitiveContains(key) ?? false
    }
}
