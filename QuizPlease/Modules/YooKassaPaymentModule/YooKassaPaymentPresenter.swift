//
//  YooKassaPaymentPresenter.swift
//  QuizPlease
//
//  Created by Codex on 17.02.2026.
//

import Foundation

protocol YooKassaPaymentPresenterOutput: AnyObject {
    func yooKassaPaymentPresenter(
        _ presenter: YooKassaPaymentPresenter,
        didFinishWith result: YooKassaPaymentResult
    )
}

final class YooKassaPaymentPresenter {

    private let successPathPart = "/checkout/payments/v2/success"
    private let contractPathPart = "/checkout/payments/v2/contract"
    private var isFinished = false

    private let paymentUrl: URL

    weak var view: YooKassaPaymentViewInput?
    weak var output: YooKassaPaymentPresenterOutput?

    init(paymentUrl: URL) {
        self.paymentUrl = paymentUrl
    }

    private func finish(with result: YooKassaPaymentResult) {
        guard !isFinished else { return }
        isFinished = true
        output?.yooKassaPaymentPresenter(self, didFinishWith: result)
    }

    private func parseResult(from url: URL) -> YooKassaPaymentResult? {
        let urlString = url.absoluteString
        if urlString.contains("/records/") {
            return .canceled
        }

        let path = url.path
        if path.contains(successPathPart), urlString.contains("/success?") {
            let orderId = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?
                .first(where: { $0.name == "orderId" })?
                .value
            return .success(orderId: orderId)
        }

        if path.contains(contractPathPart),
           let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
           let paymentError = components.queryItems?
            .first(where: { $0.name == "paymentError" })?
            .value?
            .trimmingCharacters(in: .whitespacesAndNewlines),
           !paymentError.isEmpty {
            return .fail(message: paymentError)
        }

        return nil
    }
}

extension YooKassaPaymentPresenter: YooKassaPaymentViewOutput {

    func viewDidLoad() {
        view?.load(url: paymentUrl)
    }

    func didTapClose() {
        finish(with: .canceled)
    }

    func shouldCancelNavigation(for url: URL) -> Bool {
        guard let result = parseResult(from: url) else {
            return false
        }
        finish(with: result)
        return true
    }
}
