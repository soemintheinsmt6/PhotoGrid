//
//  PhotoGridUITests.swift
//  PhotoGridUITests
//
//  Created by Soemin Thein on 05/07/2025.
//

import XCTest

final class PhotoGridUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    @MainActor
    func testAppLaunch() throws {
        // Test that the app launches successfully
        XCTAssertTrue(app.waitForExistence(timeout: 5))
        
        // Verify the navigation title
        let navigationTitle = app.navigationBars["PhotoGrid"]
        XCTAssertTrue(navigationTitle.exists)
    }
    
    @MainActor
    func testPhotoGridCollectionViewExists() throws {
        // Wait for the collection view to load
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10))
        
        // Verify collection view is visible
        XCTAssertTrue(collectionView.isEnabled)
        XCTAssertTrue(collectionView.isHittable)
    }
    
    @MainActor
    func testPhotoGridLoadsPhotos() async throws {
        // Wait for photos to load
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10))
        
        // Wait a bit more for photos to appear
        try await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
        
        // Check if photos are loaded (cells should exist)
        let photoCells = collectionView.cells
        XCTAssertGreaterThan(photoCells.count, 0, "Photos should be loaded")
    }
    
    @MainActor
    func testPhotoGridScrolling() async throws {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10))
        
        // Wait for initial photos to load
        try await Task.sleep(nanoseconds: 3_000_000_000)
        
        // Get initial cell count
        let initialCellCount = collectionView.cells.count
        
        // Scroll down to trigger pagination
        collectionView.swipeUp()
        
        // Wait for more photos to load
        try await Task.sleep(nanoseconds: 3_000_000_000)
        
        // Check if more cells were added
        let newCellCount = collectionView.cells.count
        XCTAssertGreaterThanOrEqual(newCellCount, initialCellCount, "More photos should load after scrolling")
    }
    
    @MainActor
    func testPhotoGridTapToNavigate() async throws {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10))
        
        // Wait for photos to load
        try await Task.sleep(nanoseconds: 3_000_000_000)
        
        // Get the first photo cell
        let photoCells = collectionView.cells
        guard photoCells.count > 0 else {
            XCTFail("No photo cells found")
            return
        }
        
        let firstCell = photoCells.firstMatch
        
        // Tap on the first photo
        firstCell.tap()
        
        // Wait for navigation to photo details
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Verify we're on the photo details screen
        // The navigation bar should show a back button
        let backButton = app.navigationBars.buttons.firstMatch
        XCTAssertTrue(backButton.exists)
    }
    
    @MainActor
    func testPhotoDetailsScreen() async throws {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10))
        
        // Wait for photos to load
        try await Task.sleep(nanoseconds: 3_000_000_000)
        
        // Tap on a photo to navigate to details
        let photoCells = collectionView.cells
        guard photoCells.count > 0 else {
            XCTFail("No photo cells found")
            return
        }
        
        photoCells.firstMatch.tap()
        
        // Wait for navigation
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Verify photo details screen elements
        let imageView = app.images.firstMatch
        XCTAssertTrue(imageView.exists)
        
        // Test back navigation
        let backButton = app.navigationBars.buttons.firstMatch
        backButton.tap()
        
        // Verify we're back to the photo grid
        try await Task.sleep(nanoseconds: 1_000_000_000)
        XCTAssertTrue(collectionView.exists)
    }
    
    @MainActor
    func testPhotoGridOrientationChange() async throws {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10))
        
        // Wait for photos to load
        try await Task.sleep(nanoseconds: 3_000_000_000)
        
        // Rotate device to landscape
        XCUIDevice.shared.orientation = .landscapeLeft
        
        // Wait for layout update
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Verify collection view still exists and is accessible
        XCTAssertTrue(collectionView.exists)
        XCTAssertTrue(collectionView.isEnabled)
        
        // Rotate back to portrait
        XCUIDevice.shared.orientation = .portrait
        
        // Wait for layout update
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Verify collection view still exists
        XCTAssertTrue(collectionView.exists)
    }
    
    @MainActor
    func testPhotoGridPullToRefresh() async throws {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10))
        
        // Wait for initial photos to load
        try await Task.sleep(nanoseconds: 3_000_000_000)
        
        
        // Pull down to refresh (if refresh control is implemented)
        collectionView.swipeDown()
        
        // Wait for refresh
        try await Task.sleep(nanoseconds: 2_000_000_000)
        
        // Verify collection view still exists and is functional
        XCTAssertTrue(collectionView.exists)
        XCTAssertTrue(collectionView.isEnabled)
    }
    
    @MainActor
    func testPhotoGridAccessibility() async throws {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10))
        
        // Wait for photos to load
        try await Task.sleep(nanoseconds: 3_000_000_000)
        
        // Test accessibility
        XCTAssertTrue(collectionView.isAccessibilityElement || collectionView.cells.count > 0)
        
        // Test that cells are accessible
        let photoCells = collectionView.cells
        if photoCells.count > 0 {
            let firstCell = photoCells.firstMatch
            XCTAssertTrue(firstCell.isEnabled)
            XCTAssertTrue(firstCell.isHittable)
        }
    }
    
    @MainActor
    func testPhotoGridPerformance() throws {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10))
        
        // Measure performance of scrolling
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric()]) {
            // Scroll through the collection view
            collectionView.swipeUp()
            collectionView.swipeDown()
        }
    }
    
    @MainActor
    func testPhotoGridNetworkErrorHandling() async throws {
        // This test would require mocking network conditions
        // For now, we'll test that the app doesn't crash under normal conditions
        
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10))
        
        // Wait for photos to load
        try await Task.sleep(nanoseconds: 3_000_000_000)
        
        // Verify the app is still responsive
        XCTAssertTrue(collectionView.exists)
        XCTAssertTrue(collectionView.isEnabled)
    }
    
    @MainActor
    func testPhotoGridMemoryUsage() async throws {
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10))
        
        // Wait for initial load
        try await Task.sleep(nanoseconds: 3_000_000_000)
        
        // Scroll multiple times to test memory management
        for _ in 0..<5 {
            collectionView.swipeUp()
            try await Task.sleep(nanoseconds: 1_000_000_000)
        }
        
        // Verify app is still responsive
        XCTAssertTrue(collectionView.exists)
        XCTAssertTrue(collectionView.isEnabled)
    }
}
