//
//  BusinessLogicTests.swift
//  NYTimesTests
//
//  Created by Sanu Leema on 7/11/19.
//  Copyright © 2019 Sanu. All rights reserved.
//

import XCTest
@testable import NYTimes

class BusinessLogicTests: XCTestCase {
    
    func testTimePeriodParam() {
        
        XCTAssertTrue(MasterViewController.TimePeriod.day.param == "1")
        XCTAssertTrue(MasterViewController.TimePeriod.week.param == "7")
        XCTAssertTrue(MasterViewController.TimePeriod.month.param == "30")
    }
    
    func testArticleParamForService() {
        
        XCTAssertTrue(ArticleTypeViewController.Section.all.param == "all-sections")
        XCTAssertTrue(ArticleTypeViewController.Section.business.param == "Business")
        XCTAssertTrue(ArticleTypeViewController.Section.technology.param == "Technology")
    }
    
    func testValidAPIURL() {
        XCTAssertTrue(ServiceManager.API.baseURl.absoluteString == "https://api.nytimes.com")
    }
}
