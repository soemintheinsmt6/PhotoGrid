//
//  PhotoListViewModelTests.swift
//  PhotoListViewModelTests
//
//  Created by Soemin Thein on 06/09/2024.
//

import XCTest
@testable import PhotoGrid


final class PhotoListViewModelTests: XCTestCase {
    
    var viewModel: PhotoListViewModel!
    var mockPhotoService: MockPhotoService!
    
    override func setUp() {
        super.setUp()
        mockPhotoService = MockPhotoService()
        viewModel = PhotoListViewModel(photoService: mockPhotoService)
    }
    
    override func tearDown() {
        viewModel = nil
        mockPhotoService = nil
        super.tearDown()
    }

    func testFetchPhotosSuccess() throws {
        let mockPhotos = [
            PhotoModel(id: "1", author: "author1", url: "url1", downloadURL: "downloadUrl1"),
            PhotoModel(id: "2", author: "author2", url: "url2", downloadURL: "downloadUrl2")
        ]
        mockPhotoService.photos = mockPhotos
        
        let expectation = self.expectation(description: "onUpdate called")
        var onUpdateCalled = false
        
        viewModel.onUpdate = {
            onUpdateCalled = true
            expectation.fulfill()
        }
        
        viewModel.fetchPhotos()
        
        waitForExpectations(timeout: 2.0) { _ in
            XCTAssertTrue(onUpdateCalled)
            XCTAssertEqual(self.viewModel.photos.count, mockPhotos.count)
            XCTAssertEqual(self.viewModel.photos[0].id, "1")
            XCTAssertEqual(self.viewModel.photos[1].author, "author2")
        }
    }
    
    func testFetchPhotosFailure() throws {
        mockPhotoService.shouldReturnError = true

        viewModel.fetchPhotos()
        
        // Wait a bit for async operation
        let expectation = self.expectation(description: "Wait for failure")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            XCTAssertTrue(self.viewModel.photos.isEmpty)
        }
    }
    
    func testFetchPhotosIncrementsPage() throws {
        let mockPhotos = [PhotoModel(id: "1", author: "author1", url: "url1", downloadURL: "downloadUrl1")]
        mockPhotoService.photos = mockPhotos
        
        let expectation = self.expectation(description: "onUpdate called")
        
        viewModel.onUpdate = {
            expectation.fulfill()
        }
        
        viewModel.fetchPhotos()
        
        waitForExpectations(timeout: 2.0) { _ in
            XCTAssertEqual(self.viewModel.currentPage, 2)
        }
    }
    
    func testFetchPhotosPreventsMultipleSimultaneousRequests() throws {
        let mockPhotos = [PhotoModel(id: "1", author: "author1", url: "url1", downloadURL: "downloadUrl1")]
        mockPhotoService.photos = mockPhotos
        
        // Call fetchPhotos multiple times rapidly
        viewModel.fetchPhotos()
        viewModel.fetchPhotos()
        viewModel.fetchPhotos()
        
        // Wait a bit for async operations
        let expectation = self.expectation(description: "Wait for operations")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0) { _ in
            // Should only have called the service once due to isFetching guard
            XCTAssertEqual(self.mockPhotoService.fetchCallCount, 1)
        }
    }
    
    func testFetchPhotosAppendsToExistingPhotos() throws {
        let firstBatch = [PhotoModel(id: "1", author: "author1", url: "url1", downloadURL: "downloadUrl1")]
        let secondBatch = [PhotoModel(id: "2", author: "author2", url: "url2", downloadURL: "downloadUrl2")]
        
        mockPhotoService.photos = firstBatch
        
        let firstExpectation = self.expectation(description: "First fetch")
        viewModel.onUpdate = {
            firstExpectation.fulfill()
        }
        
        viewModel.fetchPhotos()
        waitForExpectations(timeout: 2.0) { _ in
            XCTAssertEqual(self.viewModel.photos.count, 1)
        }
        
        // Change mock data for second fetch
        mockPhotoService.photos = secondBatch
        
        let secondExpectation = self.expectation(description: "Second fetch")
        viewModel.onUpdate = {
            secondExpectation.fulfill()
        }
        
        viewModel.fetchPhotos()
        waitForExpectations(timeout: 2.0) { _ in
            XCTAssertEqual(self.viewModel.photos.count, 2)
            XCTAssertEqual(self.viewModel.photos[0].id, "1")
            XCTAssertEqual(self.viewModel.photos[1].id, "2")
        }
    }
    
    func testFetchPhotosRequestsCorrectPage() throws {
        let mockPhotos = [PhotoModel(id: "1", author: "author1", url: "url1", downloadURL: "downloadUrl1")]
        mockPhotoService.photos = mockPhotos
        
        let expectation = self.expectation(description: "onUpdate called")
        viewModel.onUpdate = {
            expectation.fulfill()
        }
        
        viewModel.fetchPhotos()
        
        waitForExpectations(timeout: 2.0) { _ in
            XCTAssertEqual(self.mockPhotoService.lastRequestedPage, 1)
        }
        
        // Second fetch should request page 2
        let secondExpectation = self.expectation(description: "Second fetch")
        viewModel.onUpdate = {
            secondExpectation.fulfill()
        }
        
        viewModel.fetchPhotos()
        
        waitForExpectations(timeout: 2.0) { _ in
            XCTAssertEqual(self.mockPhotoService.lastRequestedPage, 2)
        }
    }
    
    func testInitialState() throws {
        XCTAssertEqual(viewModel.currentPage, 1)
        XCTAssertTrue(viewModel.photos.isEmpty)
        XCTAssertNil(viewModel.onUpdate)
    }
}
