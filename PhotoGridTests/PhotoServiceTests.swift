//
//  PhotoServiceTests.swift
//  PhotoGridTests
//
//  Created by Soemin Thein on 06/09/2024.
//

import XCTest
import Alamofire
@testable import PhotoGrid

final class PhotoServiceTests: XCTestCase {
    
    var photoService: PhotoService!
    
    override func setUp() {
        super.setUp()
        photoService = PhotoService()
    }
    
    override func tearDown() {
        photoService = nil
        super.tearDown()
    }
    
    func testFetchPhotosSuccess() throws {
        let expectation = self.expectation(description: "Fetch photos success")
        
        photoService.fetchPhotos(page: 1) { result in
            switch result {
            case .success(let photos):
                XCTAssertFalse(photos.isEmpty)
                XCTAssertTrue(photos.count <= 21) // Limit is 21
                
                // Verify photo structure
                let firstPhoto = photos.first!
                XCTAssertFalse(firstPhoto.id.isEmpty)
                XCTAssertFalse(firstPhoto.author.isEmpty)
                XCTAssertFalse(firstPhoto.url.isEmpty)
                XCTAssertFalse(firstPhoto.downloadURL.isEmpty)
                
                expectation.fulfill()
                
            case .failure(let error):
                XCTFail("Expected success but got error: \(error)")
            }
        }
        
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("Test timed out: \(error)")
            }
        }
    }
    
    func testFetchPhotosWithDifferentPages() throws {
        let expectation1 = self.expectation(description: "Fetch page 1")
        let expectation2 = self.expectation(description: "Fetch page 2")
        
        var page1Photos: [PhotoModel] = []
        var page2Photos: [PhotoModel] = []
        
        photoService.fetchPhotos(page: 1) { result in
            switch result {
            case .success(let photos):
                page1Photos = photos
                expectation1.fulfill()
            case .failure(let error):
                XCTFail("Page 1 failed: \(error)")
            }
        }
        
        photoService.fetchPhotos(page: 2) { result in
            switch result {
            case .success(let photos):
                page2Photos = photos
                expectation2.fulfill()
            case .failure(let error):
                XCTFail("Page 2 failed: \(error)")
            }
        }
        
        waitForExpectations(timeout: 15.0) { error in
            if let error = error {
                XCTFail("Test timed out: \(error)")
            }
        }
        
        // Pages should have different photos
        XCTAssertFalse(page1Photos.isEmpty)
        XCTAssertFalse(page2Photos.isEmpty)
        
        // Check that we get different photos on different pages
        let page1Ids = Set(page1Photos.map { $0.id })
        let page2Ids = Set(page2Photos.map { $0.id })
        
        // There might be some overlap, but they shouldn't be identical
        XCTAssertNotEqual(page1Ids, page2Ids)
    }
    
    func testFetchPhotosWithInvalidPage() throws {
        let expectation = self.expectation(description: "Fetch invalid page")
        
        photoService.fetchPhotos(page: -1) { result in
            switch result {
            case .success(_):
                // Even with invalid page, the API might return some results
                // or it might return empty array
                expectation.fulfill()
                
            case .failure(let error):
                // It's also acceptable for the API to fail with invalid page
                print("Expected failure with invalid page: \(error)")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("Test timed out: \(error)")
            }
        }
    }
    
    func testFetchPhotosWithLargePage() throws {
        let expectation = self.expectation(description: "Fetch large page")
        
        photoService.fetchPhotos(page: 999) { result in
            switch result {
            case .success( _):
                // Large page might return empty array or some results
                expectation.fulfill()
                
            case .failure(let error):
                // It's also acceptable for the API to fail with very large page
                print("Expected failure with large page: \(error)")
                expectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("Test timed out: \(error)")
            }
        }
    }
    
    func testPhotoServiceProtocolConformance() throws {
        // Test that PhotoService conforms to PhotoServiceProtocol
        let service: PhotoServiceProtocol = PhotoService()
        XCTAssertNotNil(service)
        
        let expectation = self.expectation(description: "Protocol test")
        
        service.fetchPhotos(page: 1) { result in
            switch result {
            case .success(let photos):
                XCTAssertNotNil(photos)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Protocol test failed: \(error)")
            }
        }
        
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("Protocol test timed out: \(error)")
            }
        }
    }
    
    func testPhotoModelResizedImageURL() throws {
        let expectation = self.expectation(description: "Test resized URL")
        
        photoService.fetchPhotos(page: 1) { result in
            switch result {
            case .success(let photos):
                guard let firstPhoto = photos.first else {
                    XCTFail("No photos returned")
                    return
                }
                
                // Test that resizedImageURL is correctly formatted
                let resizedURL = firstPhoto.resizedImageURL
                XCTAssertTrue(resizedURL.hasPrefix("https://picsum.photos/id/"))
                XCTAssertTrue(resizedURL.hasSuffix("/300/200"))
                XCTAssertTrue(resizedURL.contains(firstPhoto.id))
                
                expectation.fulfill()
                
            case .failure(let error):
                XCTFail("Failed to fetch photos: \(error)")
            }
        }
        
        waitForExpectations(timeout: 10.0) { error in
            if let error = error {
                XCTFail("Test timed out: \(error)")
            }
        }
    }
} 
