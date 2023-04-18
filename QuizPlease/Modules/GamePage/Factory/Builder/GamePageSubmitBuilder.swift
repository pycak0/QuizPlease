//
//  GamePageSubmitBuilder.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage submit output
protocol GamePageSubmitOutput: AnyObject {

    /// User did press submit button
    func submitButtonPressed()

    /// User did press agreement button
    func agreementButtonPressed()
}

/// GamePage submit and agreement button builder
final class GamePageSubmitBuilder {

    weak var output: GamePageSubmitOutput?

    // MARK: - Private Properties

    private let titleProvider: GamePageSubmitButtonTitleProvider

    // MARK: - Lifecycle

    init(titleProvider: GamePageSubmitButtonTitleProvider) {
        self.titleProvider = titleProvider
    }

    // MARK: - Private Methods

    private func makeSubmitItem() -> GamePageItemProtocol {
        GamePageSubmitButtonItem(
            getTitle: { [weak titleProvider] in
                titleProvider?.getSubmitButtonTitle() ?? "Записаться на игру"
            },
            tapAction: { [weak output] in
                output?.submitButtonPressed()
            }
        )
    }

    private func makeAgreementItem() -> GamePageItemProtocol {
        GamePageAgreementItem { [weak output] in
            output?.agreementButtonPressed()
        }
    }
}

// MARK: - GamePageItemBuilderProtocol

extension GamePageSubmitBuilder: GamePageItemBuilderProtocol {

    func makeItems() -> [GamePageItemProtocol] {
        return [
            makeSubmitItem(),
            makeAgreementItem()
        ]
    }
}