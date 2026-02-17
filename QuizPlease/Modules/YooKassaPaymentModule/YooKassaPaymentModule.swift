//
//  YooKassaPaymentModule.swift
//  QuizPlease
//
//  Created by Codex on 17.02.2026.
//

import UIKit

protocol YooKassaPaymentModule: AnyObject {
    func open(paymentUrl: URL, completion: @escaping (YooKassaPaymentResult) -> Void)
}

final class YooKassaPaymentModuleImpl: YooKassaPaymentModule {

    private let assembly: YooKassaPaymentAssembly

    private var completion: ((YooKassaPaymentResult) -> Void)?
    private weak var navigationController: UINavigationController?

    init(assembly: YooKassaPaymentAssembly) {
        self.assembly = assembly
    }

    func open(paymentUrl: URL, completion: @escaping (YooKassaPaymentResult) -> Void) {
        guard let topViewController = UIApplication.shared.getKeyWindow()?.topViewController else {
            completion(.fail(message: "Не удалось открыть страницу оплаты"))
            return
        }

        let viewController = assembly.makeViewController(
            paymentUrl: paymentUrl,
            output: self
        )

        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen

        self.completion = completion
        self.navigationController = navigationController

        topViewController.present(navigationController, animated: true)
    }

    private func complete(with result: YooKassaPaymentResult) {
        let completion = self.completion
        self.completion = nil

        if let navigationController {
            navigationController.dismiss(animated: true) {
                completion?(result)
            }
            self.navigationController = nil
            return
        }

        self.navigationController = nil
        completion?(result)
    }
}

extension YooKassaPaymentModuleImpl: YooKassaPaymentPresenterOutput {
    func yooKassaPaymentPresenter(
        _ presenter: YooKassaPaymentPresenter,
        didFinishWith result: YooKassaPaymentResult
    ) {
        complete(with: result)
    }
}
