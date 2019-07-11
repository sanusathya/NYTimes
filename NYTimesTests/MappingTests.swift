//
//  MappingTests.swift
//  NYTimesTests
//
//  Created by Sanu Leema on 7/11/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import XCTest
@testable import NYTimes

class MappingTests: XCTestCase {
    
    func testMappingString() {

        //Given
        let jsonString = "{\"type\": \"Article\"}"
        let jsonData = Data(jsonString.utf8)

        do {
            //When
            let decoded = try JSONDecoder().decode(Article.Media.self, from: jsonData)

            //Then
            XCTAssertEqual(decoded.type, "Article")
        } catch {
            XCTAssertThrowsError(error)
        }
    }

    func testMappingURL() {

        //Given
        let absString = "https://www.nytimes.com/2019/07/06/nyregion/jeffrey-epstein-arrested-sex-trafficking.html"
        let jsonString = "{\"url\": \"https://www.nytimes.com/2019/07/06/nyregion/jeffrey-epstein-arrested-sex-trafficking.html\", \"format\": \"Standard Thumbnail\"}"
        let jsonData = Data(jsonString.utf8)

        do {
            //When
            let decoded = try JSONDecoder().decode(Article.MediaMetaData.self, from: jsonData)

            //Then
            XCTAssertEqual(decoded.url?.absoluteString, absString)
        } catch {
            XCTAssertThrowsError(error)
        }
    }

    func testEnumStringCase() {

        //Given
        let jsonString = "{\"format\": \"Standard Thumbnail\"}"
        let jsonData = Data(jsonString.utf8)

        do {
            //When
            let mediaDataResponse = try JSONDecoder().decode(Article.MediaMetaData.self, from: jsonData)
            
            //Then
            XCTAssertEqual(mediaDataResponse.format, Article.MultimediaFormat.standardThumbnail)
        } catch {
            //            print(error)
            XCTAssertThrowsError(error)
        }
    }
    
    func testArticleMapping() {
        
        let bundle = Bundle(for: type(of: self))
        
        guard let url = bundle.url(forResource: "Article", withExtension: "json") else { return }
        
        //Given
        do {
            // When
            let json = try Data(contentsOf: url)
            let sectionsResponse = try JSONDecoder().decode(Article.SectionsResponse.self, from: json)
            
            // Then
            XCTAssertEqual(sectionsResponse.articles?.first?.url?.absoluteString, "https://www.nytimes.com/2019/07/02/nyregion/judge-james-troiano-rape.html")
            XCTAssertEqual(sectionsResponse.articles?.first?.section, "New York")
            XCTAssertEqual(sectionsResponse.articles?.first?.media?.first?.type, "image")
            XCTAssertEqual(sectionsResponse.articles?.first?.media?.first?.mediaMetaData?.first?.format, Article.MultimediaFormat.square)
        } catch {
            XCTAssertThrowsError(error)
        }
    }
}
