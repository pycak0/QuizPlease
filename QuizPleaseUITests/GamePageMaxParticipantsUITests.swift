//
//  GamePageMaxParticipantsUITests.swift
//  QuizPleaseUITests
//
//  Created by Codex on 07.07.2026.
//

import XCTest

final class GamePageMaxParticipantsUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = false
    }

    func testTeamCountPickerUsesMaxParticipantsFromGameInfo() {
        let app = XCUIApplication()
        app.launchArguments = ["-UITestGamePageMaxParticipants"]
        app.launch()

        let maxTeamCountButton = app.buttons["gamePage.teamCountButton.11"]
        for _ in 0..<6 where !maxTeamCountButton.exists {
            app.swipeUp()
        }

        XCTAssertTrue(maxTeamCountButton.waitForExistence(timeout: 8))
        XCTAssertFalse(app.buttons["gamePage.teamCountButton.12"].exists)

        maxTeamCountButton.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        XCTAssertTrue(maxTeamCountButton.isSelected)
    }

    func testCurrencySymbolIsShownInScheduleAndGamePage() {
        let app = XCUIApplication()
        app.launchArguments = ["-UITestScheduleCurrency"]
        app.launch()

        let schedulePrice = app.staticTexts["schedule.gamePrice"]
        XCTAssertTrue(schedulePrice.waitForExistence(timeout: 8))
        XCTAssertEqual(schedulePrice.label, "1000 € стоимость, с человека")

        let infoButton = app.buttons["schedule.infoButton"]
        XCTAssertTrue(infoButton.waitForExistence(timeout: 4))
        infoButton.tap()

        let gamePagePrice = app.staticTexts["gamePage.infoLineTitle.banknoteIcon"]
        XCTAssertTrue(gamePagePrice.waitForExistence(timeout: 8))
        XCTAssertEqual(gamePagePrice.label, "1000 € стоимость, с человека")
    }
}
