//
//  NYTimesTests.swift
//  NYTimesTests
//
//  Created by Sanu Leema on 7/9/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import XCTest
@testable import NYTimes

class NYTimesTests: XCTestCase {

    func testLoadMostViewedAPIForAllSections() {
        
        let expect = expectation(description: "Status returned OK")
        
        let section = ArticleTypeViewController.Section.all
        let timePeriod = MasterViewController.TimePeriod.week
        let offset = 0
        
        MostViewedAPI.fetchMostViewedArticles(section: section.param, timePeriod: timePeriod.param, offset: offset).done { (sectionsResponse) in
            XCTAssertEqual(sectionsResponse?.status, "OK")
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10.0)
    }
    
    func testLoadMostViewedAPIForArts() {
        
        let expect = expectation(description: "Status returned OK")
        
        let section = ArticleTypeViewController.Section.arts
        let timePeriod = MasterViewController.TimePeriod.week
        let offset = 0
        
        MostViewedAPI.fetchMostViewedArticles(section: section.param, timePeriod: timePeriod.param, offset: offset).done { (sectionsResponse) in
            XCTAssertEqual(sectionsResponse?.status, "OK")
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10.0)
    }

}
