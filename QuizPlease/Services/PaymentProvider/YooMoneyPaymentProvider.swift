//
//  YooMoneyPaymentProvider.swift
//  QuizPlease
//
//  Created by Владислав on 31.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import YandexCheckoutPayments
import YandexCheckoutPaymentsApi

final class YooMoneyPaymentProvider: PaymentProvider {
    typealias Delegate = TokenizationModuleOutput
        
    private let apiKey = "live_NzU1NTU07gLSO5hNG4ORAWfm2xDZmiS3lLBoXLpF3JQ"
    
    func showPaymentView(for amount: Double, description: String, from presentationController: UIViewController, delegate: Delegate) {
        
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
