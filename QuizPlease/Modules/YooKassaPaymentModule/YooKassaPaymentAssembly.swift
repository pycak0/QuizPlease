//
//  YooKassaPaymentAssembly.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 17.02.2026.
//  Copyright © 2026 Владислав. All rights reserved.
//

import Foundation

final class YooKassaPaymentAssembly {

    func makeViewController(paymentUrl: URL, output: YooKassaPaymentPresenterOutput?) -> YooKassaPaymentViewInput {
        let presenter = YooKassaPaymentPresenter(paymentUrl: paymentUrl)
        let viewController = YooKassaPaymentViewController(output: presenter)
        presenter.output = output
        presenter.view = viewController
        return viewController
    }
}
