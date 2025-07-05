//
//  EnvironmentTests.swift
//  PhotoGridTests
//
//  Created by Soemin Thein on 06/09/2024.
//

import XCTest
@testable import PhotoGrid

final class EnvironmentTests: XCTestCase {
    
    func testBaseURLFormat() throws {
        let baseURL = Environment.baseURL
        
        // Should start with https://
        XCTAssertTrue(baseURL.hasPrefix("https://"))
        
        // Should not be empty
        XCTAssertFalse(baseURL.isEmpty)
        
        // Should be a valid URL
        XCTAssertNotNil(URL(string: baseURL))
    }
    
    func testBaseURLIsConsistent() throws {
        let firstCall = Environment.baseURL
        let secondCall = Environment.baseURL
        
        // Multiple calls should return the same value
        XCTAssertEqual(firstCall, secondCall)
    }
    
    func testBaseURLContainsExpectedDomain() throws {
        let baseURL = Environment.baseURL
        
        // Should contain picsum.photos (the expected API domain)
        XCTAssertTrue(baseURL.contains("picsum.photos"))
    }
    
    func testBaseURLIsValidHTTPSURL() throws {
        let baseURL = Environment.baseURL
        
        guard let url = URL(string: baseURL) else {
            XCTFail("Base URL is not a valid URL")
            return
        }
        
        XCTAssertEqual(url.scheme, "https")
        XCTAssertNotNil(url.host)
        XCTAssertFalse(url.host!.isEmpty)
    }
    
    func testBaseURLDoesNotEndWithSlash() throws {
        let baseURL = Environment.baseURL
        
        // Should not end with a slash as it's a base URL
        XCTAssertFalse(baseURL.hasSuffix("/"))
    }
    
    func testBaseURLIsAccessible() throws {
        let baseURL = Environment.baseURL
        
        let expectation = self.expectation(description: "Base URL accessibility")
        
        guard let url = URL(string: baseURL) else {
            XCTFail("Invalid base URL")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                XCTFail("Base URL is not accessible: \(error)")
            } else if let httpResponse = response as? HTTPURLResponse {
                // Should return a valid HTTP response (200, 404, etc.)
                XCTAssertTrue(httpResponse.statusCode >= 200 && httpResponse.statusCode < 600)
            }
            expectation.fulfill()
        }
        
        task.resume()
        
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("Test timed out: \(error)")
            }
        }
    }
    
    func testBaseURLWithQueryParameters() throws {
        let baseURL = Environment.baseURL
        
        // Test that we can append query parameters
        let testURL = "\(baseURL)?page=1&limit=21"
        
        guard let url = URL(string: testURL) else {
            XCTFail("Cannot construct URL with query parameters")
            return
        }
        
        XCTAssertNotNil(url.query)
        XCTAssertTrue(url.query!.contains("page=1"))
        XCTAssertTrue(url.query!.contains("limit=21"))
    }
} 