//
//  YooKassaPaymentResult.swift
//  QuizPlease
//
//  Created by Codex on 17.02.2026.
//

import Foundation

enum YooKassaPaymentResult {
    case success(orderId: String?)
    case fail(message: String)
    case canceled
}
