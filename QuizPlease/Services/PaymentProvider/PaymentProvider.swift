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
    
    func showPaymentView(for amount: Double, description: String, from presentationController: UIViewController, delegate: Delegate)
}
