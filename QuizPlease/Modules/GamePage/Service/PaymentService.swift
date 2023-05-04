//
//  PaymentService.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 18.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit
import YooKassaPayments
import YooKassaPaymentsApi

/// Payment service protocol
protocol PaymentServiceProtocol {

    /// This method launches payment process, shows payment UI for user to input payment data.
    /// Watch the `didCreatePaymentToken(_:)` method as a further step.
    func launchPayment(options: PaymentOptions)

    /// Start payment confirmation process (e.g. with one-time SMS-code) using the provided confirmation link.
    /// - Important: Do not call this method before the `launchPayment(options:)`. This will result in a `fatalError`
    func startConfirmation(_ link: String)

    /// Close the payments module.
    func closePayment(completion: (() -> Void)?)
}

/// Payment service output events handler protocol
protocol PaymentServiceOutput: AnyObject {

    /// A payment token was created.
    ///
    /// Token should be sent to the backend to proceed the payment.
    /// However, at this moment, payment is not completed yet, and payment UI is still open,
    /// because it may be required to confirm the payment, e.g. with 3D-secure.
    /// So, the further step is to either
    func didCreatePaymentToken(_ paymentToken: String)

    /// User closed payment screen which cancelled the payment.
    ///
    /// This method is not called when the payment was cancelled programmatically
    /// using the `cancelPayment()` method.
    func didCancelPayment()

    /// Payment was proceeded successfully, payment UI did close.
    func didConfirmPaymentSuccessfully()
}

/// Yoomoney payment service
final class PaymentServiceImpl: PaymentServiceProtocol {

    /// Payment service output events handler
    weak var output: PaymentServiceOutput?

    // MARK: - Private Properties

    private var paymentsModule: TokenizationModuleInput?
    private var paymentMethodType: YooKassaPayments.PaymentMethodType?
    private weak var presentingViewController: UIViewController?

    // MARK: - PaymentServiceProtocol

    func launchPayment(options: PaymentOptions) {
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
        let paymentVC = TokenizationAssembly.makeModule(inputData: tokenizationFlow, moduleOutput: self)
        paymentsModule = paymentVC
        presentingViewController = UIApplication.shared.getKeyWindow()?.topViewController
        presentingViewController?.present(paymentVC, animated: true)
    }

    func startConfirmation(_ link: String) {
        guard
            let paymentMethodType,
            let paymentsModule
        else {
            fatalError("❌ Payment not started yet")
        }

        paymentsModule.startConfirmationProcess(
            confirmationUrl: link,
            paymentMethodType: paymentMethodType
        )
    }

    func closePayment(completion: (() -> Void)?) {
        paymentMethodType = nil
        paymentsModule = nil
        if let vc = presentingViewController, vc.presentedViewController != nil {
            vc.dismiss(animated: true, completion: completion)
        } else {
            completion?()
        }
    }
}

// MARK: - TokenizationModuleOutput

extension PaymentServiceImpl: TokenizationModuleOutput {

    func didFinish(
        on module: TokenizationModuleInput,
        with error: YooKassaPaymentsError?
    ) {
        presentingViewController?.dismiss(animated: true) { [self] in
            output?.didCancelPayment()
            paymentMethodType = nil
            paymentsModule = nil
        }
    }

    func didSuccessfullyConfirmation(
        paymentMethodType: YooKassaPayments.PaymentMethodType
    ) {
        presentingViewController?.dismiss(animated: true) { [self] in
            output?.didConfirmPaymentSuccessfully()
            paymentsModule = nil
        }
    }

    func tokenizationModule(
        _ module: TokenizationModuleInput,
        didTokenize tokenInfo: YooKassaPayments.Tokens,
        paymentMethodType: YooKassaPayments.PaymentMethodType
    ) {
        self.paymentMethodType = paymentMethodType
        output?.didCreatePaymentToken(tokenInfo.paymentToken)
    }
}
