//
//  PaymentVC.swift
//  QuizPlease
//
//  Created by Владислав on 27.11.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import WebKit

protocol PaymentViewDelegate: class {
    func paymenVC(_ vc: PaymentVC, didOpenUrl url: URL)
    
    func paymentVCDidPressCancelButton(_ vc: PaymentVC)
    
}

class PaymentVC: UIViewController {
    
    @IBOutlet private weak var webView: WKWebView!
    
    weak var delegate: PaymentViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @IBAction private func cancelButtonPressed(_ sender: Any) {
        delegate?.paymentVCDidPressCancelButton(self)
    }
    
    public func open(_ url: URL) {
        //webView.se
    }
    
    private func configure() {
        if #available(iOS 13.0, *) {
            isModalInPresentation = true
            modalPresentationStyle = .automatic
        } else {
            modalPresentationStyle = .overFullScreen
        }
    }

}
