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
} 