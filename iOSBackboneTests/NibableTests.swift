//
//  NibableTests.swift
//  iOSBackbone
//
//  Created by Giorgy Gunawan on 8/10/20.
//  Copyright © 2020 joji. All rights reserved.
//

import XCTest
@testable import iOSBackbone

class NibableTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_nibable() {
        class test: Nibable {
            
        }
        XCTAssertTrue(test.identifier() == "test")
        XCTAssertTrue(test.nibName() == "test")
        XCTAssertNotNil(test.nib())
        XCTAssertTrue(test.bundle() == Bundle.main)
    }

}
