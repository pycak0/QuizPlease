//
//  GamePageSubmitDataProvider.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 17.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

/// GamePage submit button title provider
protocol GamePageSubmitDataProvider: AnyObject {

    /// Provide submit button title
    func getSubmitButtonTitle() -> String

    /// Provide agreement text
    func getAgreementText() -> String

    /// Provide links in agreement text
    func getAgreementLinks() -> [TextWebLink]

    /// Get personal data consent state
    func getIsPersonalDataConsent() -> Bool

    /// Set personal data consent state
    func setIsPersonalDataConsent(_ value: Bool)

    /// Get mailing consent state
    func getIsMailingConsent() -> Bool

    /// Set mailing consent state
    func setIsMailingConsent(_ value: Bool)
}
