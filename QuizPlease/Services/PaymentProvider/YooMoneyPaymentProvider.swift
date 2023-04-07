//
//  YooMoneyPaymentProvider.swift
//  QuizPlease
//
//  Created by Владислав on 31.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import YooKassaPayments
import YooKassaPaymentsApi

final class YooMoneyPaymentProvider: PaymentProvider {

    private unowned let delegate: TokenizationModuleOutput

    init(delegate: TokenizationModuleOutput) {
        self.delegate = delegate
    }

    func showPaymentView(presentationController: UIViewController, options: PaymentOptions) {

        let paymentAmount = Amount(value: Decimal(options.amount), currency: .rub)

        let tokenizationModuleInputData = TokenizationModuleInputData(
            clientApplicationKey: options.transactionKey,
            shopName: options.shopName,
            purchaseDescription: options.description,
            amount: paymentAmount,
            gatewayId: nil,
            isLoggingEnabled: Configuration.current.isDebug,
            userPhoneNumber: options.userPhoneNumber,
            savePaymentMethod: .off,
            moneyAuthClientId: nil,
            applicationScheme: "quizplease://"
        )

        let tokenizationFlow: TokenizationFlow = .tokenization(tokenizationModuleInputData)
        let paymentVC = TokenizationAssembly.makeModule(inputData: tokenizationFlow, moduleOutput: delegate)

        presentationController.present(paymentVC, animated: true)
    }
}
