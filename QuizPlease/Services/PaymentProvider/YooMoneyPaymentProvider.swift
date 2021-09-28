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
    private let devInfo: PaymentInfo?
    private let productionInfo: PaymentInfo?
    private unowned let delegate: TokenizationModuleOutput
    
    private var apiKey: String { devInfo?.paymentKey ?? "" }
    
    init(cityId: Int, delegate: TokenizationModuleOutput) {
        self.delegate = delegate
        devInfo = SecurityHelper.shared.value(for: .paymentKey(.dev)) as? PaymentInfo
        productionInfo = SecurityHelper.shared.value(for: .paymentKey(.forCity(id: cityId))) as? PaymentInfo
    }
    
    func showPaymentView(presentationController: UIViewController, options: PaymentOptions) {
        let paymentAmount = Amount(value: Decimal(options.amount), currency: .rub)
        
        //MARK:- ❗️replace `"client_id"` with real client id value
        let tokenizationModuleInputData = TokenizationModuleInputData(
            clientApplicationKey: apiKey,
            shopName: options.shopName,
            purchaseDescription: options.description,
            amount: paymentAmount,
            gatewayId: productionInfo?.shopId,
            isLoggingEnabled: AppSettings.isDebug,
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
