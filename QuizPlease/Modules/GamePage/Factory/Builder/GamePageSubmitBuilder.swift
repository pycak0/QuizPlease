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

    /// User did press url link
    func didPressLink(url: URL)

    /// User did press agreement button
    func agreementButtonPressed()
}

/// GamePage submit and agreement button builder
final class GamePageSubmitBuilder {

    weak var output: GamePageSubmitOutput?

    // MARK: - Private Properties

    private let dataProvider: GamePageSubmitDataProvider

    // MARK: - Lifecycle

    init(dataProvider: GamePageSubmitDataProvider) {
        self.dataProvider = dataProvider
    }

    // MARK: - Private Methods

    private func makeSubmitItem() -> GamePageItemProtocol {
        GamePageSubmitButtonItem(
            getTitle: { [weak dataProvider] in
                dataProvider?.getSubmitButtonTitle() ?? "Записаться на игру"
            },
            tapAction: { [weak output] in
                output?.submitButtonPressed()
            }
        )
    }

    private func makeAgreementItem() -> GamePageItemProtocol {
        GamePageAgreementItem(
            text: dataProvider.getAgreementText(),
            links: dataProvider.getAgreementLinks().map { [weak output] webLink in
                TextLink(text: webLink.text) {
                    output?.didPressLink(url: webLink.url)
                }
            }
        )
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
