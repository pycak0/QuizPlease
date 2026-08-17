//
//  RatingSeasonUITests.swift
//  QuizPleaseUITests
//
//  Created by Codex on 09.07.2026.
//

import XCTest

final class RatingSeasonUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testSeasonRatingIsShownAfterScopeSwitch() {
        let app = XCUIApplication()
        app.launchArguments = ["-UITestRatingSeason"]
        app.launch()

        XCTAssertTrue(app.tables["rating.table"].waitForExistence(timeout: 8))
        XCTAssertTrue(app.staticTexts["1. All Time Team"].waitForExistence(timeout: 8))

        let expandFilters = app.descendants(matching: .any)["rating.expandFilters"]
        XCTAssertTrue(expandFilters.waitForExistence(timeout: 4))
        expandFilters.tap()

        let scopeSegmentControl = app.descendants(matching: .any)["rating.scopeSegmentControl"]
        XCTAssertTrue(scopeSegmentControl.waitForExistence(timeout: 4))
        scopeSegmentControl.coordinate(withNormalizedOffset: CGVector(dx: 0.25, dy: 0.5)).tap()

        XCTAssertTrue(app.staticTexts["7. Season Team"].waitForExistence(timeout: 4))
        XCTAssertFalse(app.staticTexts["1. All Time Team"].exists)
    }
}
