//
//  ImageLoaderTests.swift
//  iOSBackbone
//
//  Created by Giorgy Gunawan on 8/10/20.
//  Copyright © 2020 joji. All rights reserved.
//

import XCTest
@testable import iOSBackbone

class ImageLoaderTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        imageCache.removeAllObjects()
        super.tearDown()
    }
    
    func test_loadImage_success() {
        let imageLoadedExpectation = expectation(description: "imageLoadedExpectation")
        let testUrl = URL(string: MockURLConstants.successURL)
        guard let testUrlNotNil = testUrl else {
            XCTFail("fail initiating url")
            return
        }
        let urlSession = MockURLSession()
        let httpUrlResponse = HTTPURLResponse(url: testUrlNotNil, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        urlSession.urlResponse = httpUrlResponse
        urlSession.data = ImageHelper.dataFromFile(file: "testImage")
        let SUT = ImageLoader()
        let mockDelegate = MockImageDownloaderDelegate()
        SUT.delegate = mockDelegate
        SUT.loadImage(from: testUrlNotNil, urlSession: urlSession, failedHandler: nil) {
            XCTAssertTrue(mockDelegate.imageSetCount == 1)
            imageLoadedExpectation.fulfill()
        }
        wait(for: [imageLoadedExpectation], timeout: 0.1)
    }

    func test_loadImage_success_getFromCache() {
        let imageLoadedExpectation = expectation(description: "imageLoadedExpectation")
        let imageLoadedFromCacheExpectation = expectation(description: "imageLoadedFromCacheExpectation")

        let testUrl = URL(string: MockURLConstants.successURL)
        guard let testUrlNotNil = testUrl else {
            XCTFail("fail initiating url")
            return
        }
        let urlSession = MockURLSession()
        let httpUrlResponse = HTTPURLResponse(url: testUrlNotNil, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)
        urlSession.urlResponse = httpUrlResponse
        urlSession.data = ImageHelper.dataFromFile(file: "testImage")
        XCTAssertNil(imageCache.object(forKey: testUrlNotNil.absoluteString as AnyObject))
        
        let SUT = ImageLoader()
        let mockDelegate = MockImageDownloaderDelegate()
        SUT.delegate = mockDelegate
        SUT.loadImage(from: testUrlNotNil, urlSession: urlSession, failedHandler: nil) {
            imageLoadedExpectation.fulfill()
            XCTAssertTrue(mockDelegate.imageSetCount == 1)
            XCTAssertNotNil(imageCache.object(forKey: testUrlNotNil.absoluteString as AnyObject))
            SUT.loadImage(from: testUrlNotNil, urlSession: urlSession, failedHandler: nil) {
                imageLoadedFromCacheExpectation.fulfill()
                XCTAssertTrue(mockDelegate.imageSetCount == 2)
            }
        }
        wait(for: [imageLoadedExpectation, imageLoadedFromCacheExpectation], timeout: 3)
    }

    func test_loadImage_fail_incorrectResponse() {
        let imageLoadedExpectation = expectation(description: "imageLoadedExpectation")
        let testUrl = URL(string: MockURLConstants.successURL)
        guard let testUrlNotNil = testUrl else {
            XCTFail("fail initiating url")
            return
        }
        let urlSession = MockURLSession()
        let httpUrlResponse = HTTPURLResponse(url: testUrlNotNil, statusCode: 300, httpVersion: "HTTP/1.1", headerFields: nil)
        urlSession.urlResponse = httpUrlResponse
        urlSession.data = ImageHelper.dataFromFile(file: "testImage")
        let SUT = ImageLoader()
        let mockDelegate = MockImageDownloaderDelegate()
        SUT.delegate = mockDelegate
        SUT.loadImage(from: testUrlNotNil, urlSession: urlSession, failedHandler: {
            XCTAssertTrue(mockDelegate.imageSetCount == 0)
            imageLoadedExpectation.fulfill()
        }, completitionHandler: nil)
        wait(for: [imageLoadedExpectation], timeout: 0.1)
    }
}

class MockImageDownloaderDelegate: ImageLoaderDelegate {
    var imageSetCount = 0
    func setImage(image: UIImage) {
        imageSetCount += 1
    }
}
