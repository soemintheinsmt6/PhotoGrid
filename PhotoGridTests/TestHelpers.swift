//
//  TestHelpers.swift
//  PhotoGridTests
//
//  Created by Soemin Thein on 06/09/2024.
//

import XCTest
@testable import PhotoGrid

// MARK: - Mock Photo Service
class MockPhotoService: PhotoServiceProtocol {
    var shouldReturnError = false
    var photos: [PhotoModel] = []
    var fetchCallCount = 0
    var lastRequestedPage: Int?
    var delay: TimeInterval = 0.1
    
    func fetchPhotos(page: Int, completion: @escaping (Result<[PhotoModel], Error>) -> Void) {
        fetchCallCount += 1
        lastRequestedPage = page
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            if self.shouldReturnError {
                completion(.failure(NSError(domain: "TestError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])))
            } else {
                completion(.success(self.photos))
            }
        }
    }
}

// MARK: - Test Data Factory
struct TestDataFactory {
    
    static func createMockPhotos(count: Int) -> [PhotoModel] {
        return (1...count).map { index in
            PhotoModel(
                id: "\(index)",
                author: "Author \(index)",
                url: "https://example.com/photo\(index).jpg",
                downloadURL: "https://example.com/download\(index).jpg"
            )
        }
    }
    
    static func createMockPhoto(id: String = "1") -> PhotoModel {
        return PhotoModel(
            id: id,
            author: "Test Author",
            url: "https://example.com/photo.jpg",
            downloadURL: "https://example.com/download.jpg"
        )
    }
    
    static func createMockPhotoWithSpecialCharacters() -> PhotoModel {
        return PhotoModel(
            id: "123-456_789",
            author: "José María O'Connor-Smith",
            url: "https://example.com/photo with spaces.jpg",
            downloadURL: "https://example.com/download/photo%20with%20encoding.jpg"
        )
    }
}

// MARK: - Test Utilities
extension XCTestCase {
    
    func waitForAsyncOperation(timeout: TimeInterval = 1.0) {
        let expectation = self.expectation(description: "Async operation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: timeout) { _ in }
    }
    
    func createMockPhotoListViewModel(withPhotos photos: [PhotoModel] = []) -> PhotoListViewModel {
        let mockService = MockPhotoService()
        mockService.photos = photos
        return PhotoListViewModel(photoService: mockService)
    }
    
    func createMockPhotoListViewModelWithError() -> PhotoListViewModel {
        let mockService = MockPhotoService()
        mockService.shouldReturnError = true
        return PhotoListViewModel(photoService: mockService)
    }
}

// MARK: - UI Test Helpers
extension XCUIApplication {
    
    func waitForCollectionViewToLoad(timeout: TimeInterval = 10.0) -> XCUIElement {
        let collectionView = collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: timeout))
        return collectionView
    }
    
    func waitForPhotosToLoad(timeout: TimeInterval = 10.0) {
        let collectionView = waitForCollectionViewToLoad(timeout: timeout)
        
        // Wait for photos to appear
        let predicate = NSPredicate(format: "cells.count > 0")
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: collectionView)
        
        let result = XCTWaiter().wait(for: [expectation], timeout: timeout)
        XCTAssertEqual(result, .completed, "Photos should load within \(timeout) seconds")
    }
    
    func tapFirstPhoto() {
        let collectionView = waitForCollectionViewToLoad()
        let photoCells = collectionView.cells
        
        guard photoCells.count > 0 else {
            XCTFail("No photo cells found")
            return
        }
        
        photoCells.firstMatch.tap()
    }
    
    func scrollToLoadMorePhotos() {
        let collectionView = waitForCollectionViewToLoad()
        collectionView.swipeUp()
    }
}

// MARK: - Network Test Helpers
extension XCTestCase {
    
    func createMockURLSession() -> URLSession {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: config)
    }
}

// MARK: - Mock URL Protocol
class MockURLProtocol: URLProtocol {
    
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Request handler not set")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
        // No implementation needed
    }
} 