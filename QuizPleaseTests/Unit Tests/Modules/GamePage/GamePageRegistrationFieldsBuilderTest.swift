//
//  GamePageRegistrationFieldsBuilderTest.swift
//  QuizPleaseTests
//
//  Created by Codex on 31.03.2026.
//

@testable import QuizPlease
import XCTest

final class GamePageRegistrationFieldsBuilderTest: XCTestCase {

    private var registerFormProvider: GamePageRegisterFormProviderMock!
    private var tableInfoProvider: GamePageTableInfoProviderMock!
    private var builder: GamePageRegistrationFieldsBuilder!

    override func setUp() {
        super.setUp()
        registerFormProvider = GamePageRegisterFormProviderMock()
        tableInfoProvider = GamePageTableInfoProviderMock()
        builder = GamePageRegistrationFieldsBuilder(
            registerFormProvider: registerFormProvider,
            tableInfoProvider: tableInfoProvider
        )
    }

    override func tearDown() {
        builder = nil
        tableInfoProvider = nil
        registerFormProvider = nil
        super.tearDown()
    }

    func testTablePickerSortsSeatsAscendingAndRemovesDuplicates() throws {
        tableInfoProvider.tables = [
            GameTable(id: 30, name: "8 seats", price: 8000, seats: 8),
            GameTable(id: 10, name: "4 seats", price: 4000, seats: 4),
            GameTable(id: 20, name: "6 seats", price: 6000, seats: 6),
            GameTable(id: 11, name: "4 seats duplicate", price: 4500, seats: 4)
        ]

        let item = try makeTablePickerItem()

        XCTAssertEqual(item.tables.map(\.seats), [4, 6, 8])
        XCTAssertEqual(registerFormProvider.registerForm.selectedTableSize, 4)
        XCTAssertEqual(registerFormProvider.registerForm.count, 4)
        XCTAssertEqual(registerFormProvider.registerForm.countPaidOnline, 4)
    }

    func testTablePickerSynchronizesPaidOnlineCountWithSelectedTable() throws {
        tableInfoProvider.tables = [
            GameTable(id: 30, name: "8 seats", price: 8000, seats: 8),
            GameTable(id: 10, name: "4 seats", price: 4000, seats: 4),
            GameTable(id: 20, name: "6 seats", price: 6000, seats: 6)
        ]
        registerFormProvider.registerForm.selectedTableSize = 8
        registerFormProvider.registerForm.count = 8
        registerFormProvider.registerForm.countPaidOnline = 4

        _ = try makeTablePickerItem()

        XCTAssertEqual(registerFormProvider.registerForm.selectedTableSize, 8)
        XCTAssertEqual(registerFormProvider.registerForm.count, 8)
        XCTAssertEqual(registerFormProvider.registerForm.countPaidOnline, 8)
    }

    private func makeTablePickerItem() throws -> GamePageTablePickerItem {
        let item = builder
            .makeItems()
            .first(where: { $0.kind == .teamCount })

        return try XCTUnwrap(item as? GamePageTablePickerItem)
    }
}
