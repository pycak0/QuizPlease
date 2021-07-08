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
    
    private var apiKey: String { devKey }
    
    init() {
        devKey = SecurityHelper.shared.value(for: .paymentKey(.dev)) ?? "dev-key"
        productionKey = SecurityHelper.shared.value(for: .paymentKey(.prod)) ?? "prod-key"
    }
    
    func showPaymentView(
        for amount: Double,
        description: String,
        from presentationController: UIViewController,
        delegate: TokenizationModuleOutput
    ) {
        let paymentAmount = Amount(value: Decimal(amount), currency: .rub)
        
        //MARK:- ❗️replace `"client_id"` with real client id value
        let tokenizationModuleInputData = TokenizationModuleInputData(
            clientApplicationKey: apiKey,
            shopName: "Квиз, плиз!",
            purchaseDescription: description,
            amount: paymentAmount,
            savePaymentMethod: .userSelects,
            moneyAuthClientId: "client_id"
        )
        
        let tokenizationFlow: TokenizationFlow = .tokenization(tokenizationModuleInputData)
        
        let paymentVC = TokenizationAssembly.makeModule(inputData: tokenizationFlow, moduleOutput: delegate)
        
        presentationController.present(paymentVC, animated: true)
    }
}
