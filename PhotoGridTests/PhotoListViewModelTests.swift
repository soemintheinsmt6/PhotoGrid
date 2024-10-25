//
//  PhotoListViewModelTests.swift
//  PhotoListViewModelTests
//
//  Created by Soemin Thein on 06/09/2024.
//

import XCTest
@testable import PhotoGrid


class MockPhotoService: PhotoServiceProtocol {
    var shouldReturnError = false
    var photos: [PhotoModel] = []
    
    func fetchPhotos(page: Int, completion: @escaping (Result<[PhotoModel], Error>) -> Void) {
        if shouldReturnError {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
        } else {
            completion(.success(photos))
        }
    }
}

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

        let mockPhotos = [PhotoModel(id: "1", author: "author1", url: "url1", downloadURL: "downloadUrl1"), PhotoModel(id: "2", author: "author2", url: "url2", downloadURL: "downloadUrl2")]
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
        }
    }
    
    func testFetchPhotosFailure() throws {

        mockPhotoService.shouldReturnError = true

        viewModel.fetchPhotos()
        
        XCTAssertTrue(viewModel.photos.isEmpty)
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
}
