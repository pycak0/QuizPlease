//
//  PaymentProvider.swift
//  QuizPlease
//
//  Created by Владислав on 31.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol PaymentProvider: AnyObject {
    associatedtype Delegate

    init(delegate: Delegate)

    func showPaymentView(presentationController: UIViewController, options: PaymentOptions)
}
