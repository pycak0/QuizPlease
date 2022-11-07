//
//  AuthVC.swift
//  QuizPlease
//
//  Created by Владислав on 03.10.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import PhoneNumberKit

// MARK: - Delegate Protocol
protocol AuthVCDelegate: AnyObject {
    func didSuccessfullyAuthenticate(in authVC: AuthVC)

    func didCancelAuth(in authVC: AuthVC)
}

final class AuthVC: UIViewController {

    weak var delegate: AuthVCDelegate?

    @IBOutlet private weak var authButton: ScalingButton!
    @IBOutlet private weak var textFieldView: PhoneTextFieldView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private var isCodeSent: Bool = false
    private var phoneNumber: String?
    private var smsCode: String?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar(tintColor: .black, barStyle: .transcluent(tintColor: view.backgroundColor))
        configure()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    // MARK: - Cancel Button Pressed
    @IBAction private func cancelButtonPressed(_ sender: Any) {
        delegate?.didCancelAuth(in: self)
    }

    // MARK: - Auth Button Pressed
    @IBAction private func authButtonPressed(_ sender: Any) {
        handleInput()
    }

    private func handleInput() {
        guard let number = phoneNumber else {
            showIncorrectInputNotification()
            return
        }
        let phoneNumber = number
        activityIndicator.startAnimating()
        if isCodeSent {
            if let code = smsCode {
                view.endEditing(true)
                setViews(hidden: true)
                auth(with: phoneNumber, smsCode: code)
            } else {
                activityIndicator.stopAnimating()
                showIncorrectInputNotification()
                return
            }
        } else {
            setViews(hidden: true)
            register(phone: phoneNumber)
        }
    }

    // MARK: - Register
    private func register(phone: String) {
        let userData = UserRegisterData(phone: phone, cityId: "\(AppSettings.defaultCity.id)")
        NetworkService.shared.register(userData) { [weak self] (serverResult) in
            guard let self = self else { return }

            switch serverResult {
            case let .failure(error):
                print(error)
                self.activityIndicator.stopAnimating()
                self.setViews(hidden: false)
                self.showErrorConnectingToServerAlert()

            case let .success(response):
                print(response)
                // user exists
                // if response.status == 0 {
                    self.sendCode(to: phone)
              //  }
            }
        }
    }

    // MARK: - Send Code
    private func sendCode(to phoneNumber: String) {
        NetworkService.shared.sendCode(to: phoneNumber) { [weak self] (isSuccess) in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()
            self.setViews(hidden: false)
            guard isSuccess else {
                self.showErrorConnectingToServerAlert()
                return
            }
            self.isCodeSent = true
            self.setSmsMode()
        }
    }

    // MARK: - Auth
    private func auth(with phoneNumber: String, smsCode: String) {
        let firebaseId = DefaultsManager.shared.getFcmToken() ?? ""
        NetworkService.shared.authenticate(
            phoneNumber: phoneNumber,
            smsCode: smsCode,
            firebaseId: firebaseId
        ) { [weak self] (serverResponse) in
            guard let self = self else { return }

            self.activityIndicator.stopAnimating()
            self.setViews(hidden: false)

            switch serverResponse {
            case let .failure(error):
                print(error)
                self.showErrorConnectingToServerAlert()
            case let .success(authInfo):
                if let token = authInfo.accessToken {
                    AppSettings.userToken = token
                    DefaultsManager.shared.saveAuthInfo(authInfo)
                    self.delegate?.didSuccessfullyAuthenticate(in: self)
                } else {
                    self.showSimpleAlert(title: "Произошла ошибка", message: "Пожалуйста, попробуйте повторить еще раз")
                }
            }
        }
    }

    // MARK: - Configure Views
    private func configure() {
        view.addGradient(colors: [.lemon, .lightOrange], insertAt: 0)

        authButton.layer.cornerRadius = 20
        textFieldView.textField.keyboardType = .phonePad
        textFieldView.textField.textColor = .black
        textFieldView.delegate = self
    }

    private func setViews(hidden: Bool) {
        let alpha: CGFloat = hidden ? 0 : 1
        UIView.animate(withDuration: 0.2) { [self] in
            imageView.alpha = alpha
            descriptionLabel.alpha = alpha
            textFieldView.alpha = alpha
        }
    }

    private func setSmsMode() {
        imageView.image = UIImage(named: "key")
        descriptionLabel.text = "Введите код из СМС"
        authButton.setTitle("Отправить код", for: .normal)
        textFieldView.isPhoneMaskEnabled = false
        textFieldView.title = "Код"
        textFieldView.textField.text = ""
        textFieldView.textField.placeholder = String(repeating: "X", count: 6)
        textFieldView.textField.textContentType = .oneTimeCode
        textFieldView.textField.keyboardType = .numberPad
    }

    private func showIncorrectInputNotification() {
        textFieldView.shake()
    }
}

// MARK: - Text Field View Delegate
extension AuthVC: TitledTextFieldViewDelegate {
    func textFieldView(
        _ textFieldView: TitledTextFieldView,
        didChangeTextField extractedPhoneNumber: String
    ) {
        if isCodeSent {
            smsCode = textFieldView.textField.text
            if smsCode?.count == 6 {
                handleInput()
            }
        } else {
            phoneNumber = self.textFieldView.isValidNumber ? extractedPhoneNumber : nil
        }
    }
}
