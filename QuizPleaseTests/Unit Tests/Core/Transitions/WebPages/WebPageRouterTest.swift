//
//  WebPageRouterTest.swift
//  QuizPleaseTests
//
//  Created by Codex on 27.05.2026.
//  Copyright © 2026 Владислав. All rights reserved.
//

@testable import QuizPlease
import UIKit
import XCTest

final class WebPageRouterTest: XCTestCase {

    private var applicationMock: WebPageRoutingApplicationMock!
    private var router: WebPageRouterImpl!

    override func setUp() {
        super.setUp()
        applicationMock = WebPageRoutingApplicationMock()
        router = WebPageRouterImpl(application: applicationMock)
    }

    override func tearDown() {
        router = nil
        applicationMock = nil
        super.tearDown()
    }

    func testOpenExternalBrowserWhenApplicationCanOpenURL() {
        // Arrange
        let url = URL(string: "https://quizplease.ru/home-games")!
        applicationMock.canOpenURLMock = true

        // Act
        let isOpened = router.open(url: url, options: .externalBrowser)

        // Assert
        XCTAssertTrue(isOpened)
        XCTAssertEqual(applicationMock.canOpenURL, url)
        XCTAssertEqual(applicationMock.openExternalURL, url)
    }

    func testDoesNotOpenExternalBrowserWhenApplicationCanNotOpenURL() {
        // Arrange
        let url = URL(string: "https://quizplease.ru/home-games")!
        applicationMock.canOpenURLMock = false

        // Act
        let isOpened = router.open(url: url, options: .externalBrowser)

        // Assert
        XCTAssertFalse(isOpened)
        XCTAssertEqual(applicationMock.canOpenURL, url)
        XCTAssertNil(applicationMock.openExternalURL)
    }
}

private final class WebPageRoutingApplicationMock: WebPageRoutingApplication {
    var topViewController: UIViewController?
    var canOpenURLMock = false
    private(set) var canOpenURL: URL?
    private(set) var openExternalURL: URL?

    func canOpenURL(_ url: URL) -> Bool {
        canOpenURL = url
        return canOpenURLMock
    }

    func openExternalURL(_ url: URL) {
        openExternalURL = url
    }
}
