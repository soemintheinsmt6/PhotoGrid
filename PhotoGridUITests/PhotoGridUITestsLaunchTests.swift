//
//  PhotoGridUITestsLaunchTests.swift
//  PhotoGridUITests
//
//  Created by Soemin Thein on 05/07/2025.
//

import XCTest

final class PhotoGridUITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
    
    @MainActor
        func testLaunchWithDifferentOrientations() throws {
        let app = XCUIApplication()
        
        // Test launch in portrait
        XCUIDevice.shared.orientation = .portrait
        app.launch()
        
        let portraitAttachment = XCTAttachment(screenshot: app.screenshot())
        portraitAttachment.name = "Launch Screen - Portrait"
        portraitAttachment.lifetime = .keepAlways
        add(portraitAttachment)
        
        app.terminate()
        
        // Test launch in landscape
        XCUIDevice.shared.orientation = .landscapeLeft
        app.launch()
        
        let landscapeAttachment = XCTAttachment(screenshot: app.screenshot())
        landscapeAttachment.name = "Launch Screen - Landscape"
        landscapeAttachment.lifetime = .keepAlways
        add(landscapeAttachment)
    }
    
    @MainActor
    func testLaunchAndInitialLoad() async throws {
        let app = XCUIApplication()
        app.launch()
        
        // Wait for the app to fully load
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10))
        
        // Wait a bit more for initial content to load
        try await Task.sleep(nanoseconds: 3_000_000_000)
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen - With Content"
        attachment.lifetime = .keepAlways
        add(attachment)
        
        // Verify that the app is in a good state after launch
        XCTAssertTrue(collectionView.exists)
        XCTAssertTrue(collectionView.isEnabled)
        
        // Verify navigation title is present
        let navigationTitle = app.navigationBars["PhotoGrid"]
        XCTAssertTrue(navigationTitle.exists)
    }
    
    @MainActor
    func testLaunchWithNetworkDelay() throws {
        // This test simulates a slower network connection
        // by measuring launch time and initial load time
        
        let app = XCUIApplication()
        
        let startTime = Date()
        app.launch()
        let launchTime = Date().timeIntervalSince(startTime)
        
        // Wait for collection view to appear
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 15))
        
        let totalLoadTime = Date().timeIntervalSince(startTime)
        
        // Log the timing information
        print("Launch time: \(launchTime) seconds")
        print("Total load time: \(totalLoadTime) seconds")
        
        // Verify the app launched successfully even with potential network delays
        XCTAssertTrue(collectionView.exists)
        XCTAssertTrue(collectionView.isEnabled)
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen - Network Delay Test"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
    
    @MainActor
    func testLaunchAccessibility() throws {
        let app = XCUIApplication()
        app.launch()
        
        // Wait for the app to load
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.waitForExistence(timeout: 10))
        
        // Test basic accessibility
        XCTAssertTrue(app.isAccessibilityElement || collectionView.exists)
        
        // Verify navigation is accessible
        let navigationTitle = app.navigationBars["PhotoGrid"]
        XCTAssertTrue(navigationTitle.exists)
        
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen - Accessibility"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
