//
//  UtilityTests.swift
//  PhotoGridTests
//
//  Created by Soemin Thein on 06/09/2024.
//

import XCTest
@testable import PhotoGrid

final class UtilityTests: XCTestCase {
    
    func testPushPhotoDetailsViewController() throws {
        // Create a navigation controller with a root view controller
        let rootViewController = UIViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        // Create a test image URL
        let testImageURL = "https://example.com/test-image.jpg"
        
        // Call the utility function
        rootViewController.pushPhotoDetailsViewController(image: testImageURL)
        
        // Wait for navigation to complete
        let expectation = self.expectation(description: "Navigation completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0) { _ in }
        
        // Verify that a new view controller was pushed
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        
        // Verify that the pushed view controller is PhotoDetailsViewController
        let pushedViewController = navigationController.viewControllers.last
        XCTAssertTrue(pushedViewController is PhotoDetailsViewController)
        
        // Verify that the downloadURL was set correctly
        let photoDetailsVC = pushedViewController as! PhotoDetailsViewController
        XCTAssertEqual(photoDetailsVC.downloadURL, testImageURL)
    }
    
    func testPushPhotoDetailsViewControllerWithEmptyURL() throws {
        // Create a navigation controller with a root view controller
        let rootViewController = UIViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        // Call the utility function with empty URL
        rootViewController.pushPhotoDetailsViewController(image: "")
        
        // Wait for navigation to complete
        let expectation = self.expectation(description: "Navigation completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0) { _ in }
        
        // Verify that a new view controller was pushed
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        
        // Verify that the downloadURL was set correctly (even if empty)
        let photoDetailsVC = navigationController.viewControllers.last as! PhotoDetailsViewController
        XCTAssertEqual(photoDetailsVC.downloadURL, "")
    }
    
    func testPushPhotoDetailsViewControllerWithSpecialCharacters() throws {
        // Create a navigation controller with a root view controller
        let rootViewController = UIViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        
        // Call the utility function with URL containing special characters
        let testImageURL = "https://example.com/test-image with spaces & symbols.jpg"
        rootViewController.pushPhotoDetailsViewController(image: testImageURL)
        
        // Wait for navigation to complete
        let expectation = self.expectation(description: "Navigation completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }
        waitForExpectations(timeout: 1.0) { _ in }
        
        // Verify that a new view controller was pushed
        XCTAssertEqual(navigationController.viewControllers.count, 2)
        
        // Verify that the downloadURL was set correctly
        let photoDetailsVC = navigationController.viewControllers.last as! PhotoDetailsViewController
        XCTAssertEqual(photoDetailsVC.downloadURL, testImageURL)
    }
    
    func testPushPhotoDetailsViewControllerWithoutNavigationController() throws {
        // Create a view controller without navigation controller
        let viewController = UIViewController()
        
        // Call the utility function
        viewController.pushPhotoDetailsViewController(image: "https://example.com/test.jpg")
        
        // Should not crash and should not add any view controllers
        XCTAssertEqual(viewController.navigationController?.viewControllers.count ?? 0, 0)
    }
    
    func testPhotoDetailsViewControllerInitialization() throws {
        // Test that PhotoDetailsViewController can be initialized from nib
        let photoDetailsVC = PhotoDetailsViewController(nibName: "PhotoDetailsViewController", bundle: nil)
        
        XCTAssertNotNil(photoDetailsVC)
        XCTAssertEqual(photoDetailsVC.downloadURL, "")
    }
    
    func testPhotoDetailsViewControllerWithDownloadURL() throws {
        let photoDetailsVC = PhotoDetailsViewController(nibName: "PhotoDetailsViewController", bundle: nil)
        let testURL = "https://example.com/test-image.jpg"
        
        photoDetailsVC.downloadURL = testURL
        
        XCTAssertEqual(photoDetailsVC.downloadURL, testURL)
    }
    
    func testScreenWidthAndHeightFallbackValuesWithoutWindow() throws {
        let viewController = UIViewController()
        _ = viewController.view
        
        XCTAssertEqual(viewController.screenWidth, 1)
        XCTAssertEqual(viewController.screenHeight, 1)
    }
    
    func testPlaceholderImageIsLoaded() throws {
        let placeholder = UIImage.placeholderImage
        XCTAssertNotNil(placeholder)
    }
    
    func testEnableZoomAddsPinchGestureRecognizer() throws {
        let imageView = UIImageView()
        
        XCTAssertEqual(imageView.gestureRecognizers?.count ?? 0, 0)
        XCTAssertFalse(imageView.isUserInteractionEnabled)
        
        imageView.enableZoom()
        
        XCTAssertTrue(imageView.isUserInteractionEnabled)
        
        let pinchGestures = imageView.gestureRecognizers?.compactMap { $0 as? UIPinchGestureRecognizer } ?? []
        XCTAssertEqual(pinchGestures.count, 1)
    }
}

final class PhotoListViewControllerIntegrationTests: XCTestCase {
    
    private func makeSUT(withPhotos photos: [PhotoModel]) -> (viewController: PhotoListViewController, navigationController: UINavigationController, mockService: MockPhotoService) {
        let mockService = MockPhotoService()
        mockService.photos = photos
        mockService.delay = 0
        
        let viewModel = PhotoListViewModel(photoService: mockService)
        let bundle = Bundle(for: PhotoListViewController.self)
        let viewController = PhotoListViewController(nibName: "PhotoListViewController", bundle: bundle)
        viewController.viewModel = viewModel
        
        let navigationController = UINavigationController(rootViewController: viewController)
        
        _ = viewController.view
        
        return (viewController, navigationController, mockService)
    }
    
    func testCollectionViewShowsPhotosAfterFetch() throws {
        let photos = TestDataFactory.createMockPhotos(count: 5)
        let (viewController, _, _) = makeSUT(withPhotos: photos)
        
        waitForAsyncOperation(timeout: 1.0)
        
        XCTAssertEqual(viewController.viewModel.photos.count, photos.count)
        XCTAssertEqual(viewController.photoCollectionView.numberOfItems(inSection: 0), photos.count + 3)
    }
    
    func testSelectingPhotoPushesDetailsViewController() throws {
        let photos = TestDataFactory.createMockPhotos(count: 1)
        let (viewController, navigationController, _) = makeSUT(withPhotos: photos)
        
        waitForAsyncOperation(timeout: 1.0)
        
        XCTAssertGreaterThan(viewController.photoCollectionView.numberOfItems(inSection: 0), 0)
        
        let indexPath = IndexPath(item: 0, section: 0)
        viewController.collectionView(viewController.photoCollectionView, didSelectItemAt: indexPath)
        
        let pushedViewController = navigationController.viewControllers.last as? PhotoDetailsViewController
        XCTAssertNotNil(pushedViewController)
        XCTAssertEqual(pushedViewController?.downloadURL, photos[0].downloadURL)
    }
}
