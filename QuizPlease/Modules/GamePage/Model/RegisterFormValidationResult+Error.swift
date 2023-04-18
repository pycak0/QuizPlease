//
//  RegisterFormValidationResult+Error.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 18.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

extension RegisterFormValidationResult {

    enum Error {
        case someFieldsEmpty, email, phone, invalidTeamName,
             unknown,
             network(NetworkServiceError)
    }
}

extension RegisterFormValidationResult.Error {

    var title: String {
        switch self {
        case .someFieldsEmpty:
            return "Заполнены не все обязательные поля"
        case .email:
            return "Некорректный e-mail"
        case .phone:
            return "Некорректный номер телефона"
        case .invalidTeamName:
            return "Команда с таким названием уже зарегистирована"
        case .unknown:
            return "Произошла неизвестная ошибка"
        case .network:
            return "Не удалось связаться с сервером"
        }
    }

    var message: String {
        switch self {
        case .someFieldsEmpty:
            return "Пожалуйста, заполните все поля, отмеченные звездочкой, и проверьте их корректность"
        case .email:
            return "Пожалуйста, введите корректный адрес и попробуйте еще раз"
        case .phone:
            return "Пожалуйста, введите корректный номер и попробуйте еще раз"
        case .invalidTeamName:
            return "Пожалуйста, придумайте другое название для команды"
        case .unknown:
            return "Error status code 40"
        case let .network(error):
            return error.localizedDescription
        }
    }
}
