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
    private let devKey: String
    private let productionKey: String
    private unowned let delegate: TokenizationModuleOutput
    
    private var apiKey: String { devKey }
    
    init(delegate: TokenizationModuleOutput) {
        self.delegate = delegate
        devKey = SecurityHelper.shared.value(for: .paymentKey(.dev)) ?? "dev-key"
        productionKey = SecurityHelper.shared.value(for: .paymentKey(.prod)) ?? "prod-key"
    }
    
    func showPaymentView(presentationController: UIViewController, options: PaymentOptions) {
        let paymentAmount = Amount(value: Decimal(options.amount), currency: .rub)
        
        //MARK:- ❗️replace `"client_id"` with real client id value
        let tokenizationModuleInputData = TokenizationModuleInputData(
            clientApplicationKey: apiKey,
            shopName: options.shopName,
            purchaseDescription: options.description,
            amount: paymentAmount,
            userPhoneNumber: options.userPhoneNumber,
            savePaymentMethod: .userSelects,
            moneyAuthClientId: "client_id",
            applicationScheme: "quizplease://"
        )
        
        let tokenizationFlow: TokenizationFlow = .tokenization(tokenizationModuleInputData)
        let paymentVC = TokenizationAssembly.makeModule(inputData: tokenizationFlow, moduleOutput: delegate)
        
        presentationController.present(paymentVC, animated: true)
    }
}
