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
        
        let section = "all-sections"
        let timePeriod = "7"
        let offset = 0
        
        MostViewedAPI.fetchMostViewedArticles(section: section, timePeriod: timePeriod, offset: offset).done { (sectionsResponse) in
            XCTAssertEqual(sectionsResponse?.status, "OK")
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10.0)
    }
    
    func testLoadMostViewedAPIForArts() {
        
        let expect = expectation(description: "Status returned OK")
        
        let section = "Arts"
        let timePeriod = "7"
        let offset = 0
        
        MostViewedAPI.fetchMostViewedArticles(section: section, timePeriod: timePeriod, offset: offset).done { (sectionsResponse) in
            XCTAssertEqual(sectionsResponse?.status, "OK")
            expect.fulfill()
        }
        wait(for: [expect], timeout: 10.0)
    }

}
