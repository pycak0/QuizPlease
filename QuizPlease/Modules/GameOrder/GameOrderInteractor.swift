//
//  GameOrderInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import SafariServices

//MARK:- Interactor Protocol
protocol GameOrderInteractorProtocol: NSObject {
    ///must be `weak`
    var delegate: GameOrderInteractorDelegate? { get set }
    
    func register(with form: RegisterForm, completion: @escaping (_ orderResponse: GameOrderResponse?) -> Void)
    
    func confirmPayment(redirectLink: URL, presentationView: GameOrderViewProtocol, completion: @escaping (SessionError?) -> Void)
}

//MARK:- Delegate Protocol
protocol GameOrderInteractorDelegate: class {
    func paymentConfirmationController(_ paymentVC: UIViewController, didRedirectToUrl url: URL)
    
    func paymentConfirmationControllerDidFinish(_ paymentVC: UIViewController)
    
    func paymentConfirmationControllerWillOpenInBrowser(_ paymentVC: UIViewController)
    
}

class GameOrderInteractor: NSObject, GameOrderInteractorProtocol {
    weak var delegate: GameOrderInteractorDelegate?
    
    func register(with form: RegisterForm, completion: @escaping (_ orderResponse: GameOrderResponse?) -> Void) {
        NetworkService.shared.registerOnGame(registerForm: form) { serverResponse in
            switch serverResponse {
            case let .failure(error):
                print(error)
                completion(nil)
            case let .success(response):
                completion(response)
            }
        }
    }
    
    func confirmPayment(redirectLink: URL, presentationView: GameOrderViewProtocol, completion: @escaping (SessionError?) -> Void) {
        presentationView.openSafariVC(self, with: redirectLink)
    }
}

//MARK:- SFSafariViewControllerDelegate
extension GameOrderInteractor: SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        delegate?.paymentConfirmationControllerDidFinish(controller)
    }
    
    func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {
        delegate?.paymentConfirmationControllerWillOpenInBrowser(controller)
    }
    
    func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
        delegate?.paymentConfirmationController(controller, didRedirectToUrl: URL)
    }
}
