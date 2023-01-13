//
//  WarmupQuestionTypeResolverTest.swift
//  QuizPleaseTests
//
//  Created by Владислав on 31.12.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

@testable import QuizPlease
import XCTest

final class WarmupQuestionTypeResolverTest: XCTestCase {

    private var questionTypeResolver: WarmupQuestionTypeResolverImpl!

    override func setUp() {
        super.setUp()
        questionTypeResolver = WarmupQuestionTypeResolverImpl()
    }

    override func tearDown() {
        questionTypeResolver = nil
        super.tearDown()
    }

    func testResolveImageWithText() {
        // Arrange
        let expectedType = WarmupQuestionType.imageWithText
        let testCases = [
            "jpg", "jpeg", "png",
            "heic", "heif", "bmp",
            "gif", "tiff"
        ].map { "files/image.\($0)" } + [
            "files/2022%2F09%2F6321fc5fe4363.png",
            "files/2022%2F12%2F638a162a7745a.jpg"
        ]

        // Act & Assert
        testResolver(testCases: testCases, expectedType: expectedType)
    }

    func testResolveVideoWithText() {
        // Arrange
        let expectedType = WarmupQuestionType.videoWithText
        let testCases = [
            "mp4", "mov",
            "m4v", "3gp"
        ].map { "files/video.\($0)" }

        // Act & Assert
        testResolver(testCases: testCases, expectedType: expectedType)
    }

    func testResolveSoundWithText() {
        // Arrange
        let expectedType = WarmupQuestionType.soundWithText
        let testCases = [
            "mp3", "m4a", "aac", "adts",
            "ac3", "aif", "aiff", "aifc",
            "caf", "snd", "au", "sd2", "wav"
        ].map { "files/sound.\($0)" } + [
            "files/2022%2F12%2F638a24bcaf374.mp3"
        ]

        // Act & Assert
        testResolver(testCases: testCases, expectedType: expectedType)
    }

    func testResolveText() {
        // Arrange
        let expectedType = WarmupQuestionType.text
        let testCases: [String?] = [nil]

        // Act & Assert
        testResolver(testCases: testCases, expectedType: expectedType)
    }

    func testFailToResolveMediaType() {
        // Arrange
        let expectedType = WarmupQuestionType.text
        let testCases: [String?] = [
            "file",
            "file.jpgg",
            ".jpg",
            "png"
        ]

        // Act & Assert
        testResolver(testCases: testCases, expectedType: expectedType)
    }

    private func testResolver(testCases: [String?], expectedType: WarmupQuestionType, testName: String = #function) {
        // Act
        for testCase in testCases {
            XCTContext.runActivity(named: "Test \(testName) with case: '\(testCase ?? "nil")'") { _ in

                let question = makeWarmupQuestionMock(file: testCase)
                let type = questionTypeResolver.resolve(question: question)

                // Assert
                XCTAssertEqual(type, expectedType, "Type is not equal to '\(expectedType)'")
            }
        }
    }

    private func makeWarmupQuestionMock(file: String?) -> WarmupQuestion {
        WarmupQuestion(id: "1", question: "Text", answers: [], file: file)
    }
}
