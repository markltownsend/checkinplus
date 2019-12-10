//
//  FoursquareAPITests.swift
//  FoursquareAPITests
//
//  Created by Mark Townsend on 10/19/19.
//  Copyright © 2019 Mark Townsend. All rights reserved.
//

import XCTest
@testable import FoursquareAPI

class FoursquareAPITests: XCTestCase {

    let manager = FoursquareAPIManager()

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCheckInSearch() {
        let doneExpectation = expectation(description: "")
        manager.getCheckInVenues(latitude: 40.7099, longitude: -73.9622) { (venues, error) in
            if let error = error {
                XCTAssert(false, error)
            }

            XCTAssertNotNil(venues)
            doneExpectation.fulfill()
        }

        waitForExpectations(timeout: 600) { (error) in
            if let error = error {
                print(error)
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
