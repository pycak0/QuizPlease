//
//  AnalyticsEvent.swift
//  QuizPlease
//
//  Created by Владислав on 22.12.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

struct AnalyticsEvent {

    /// Event name (key)
    let name: String
    /// Additional parameters
    let parameters: [String: Any]?

    init(name: String, parameters: [String : Any]? = nil) {
        self.name = name
        self.parameters = parameters
    }
}

// MARK: - Common Events

extension AnalyticsEvent {

    /// Просмотр экрана расписания
    static let scheduleOpen = AnalyticsEvent(name: "page_view_schedule")

    /// Просмотр экрана игры
    static let gameOrderOpen = AnalyticsEvent(name: "page_view_game")

    /// Заполнение формы регистрации.
    /// Ввод данных в любое поле (название команды, имя капитана, e-mail, телефон)
    static let beginRegistration = AnalyticsEvent(name: "begin_registration")

    /// Регистрация. Открытие экрана успешной регистрации
    static let registrationSuccess = AnalyticsEvent(name: "registration")

    /// Нажатие кнопки "Начать разминку"
    static let warmupStart = AnalyticsEvent(name: "warmup_start")

    /// Показ последнего экрана разминки с результатами
    static let warmupEnd = AnalyticsEvent(name: "warmup_end")

    /// Нажатие кнопки "Поделиться" в конце разминки
    static let warmupShare = AnalyticsEvent(name: "share")

    /// Просмотр экрана рейтинга
    static let ratingOpen = AnalyticsEvent(name: "page_view_rating")

    /// Просмотр экарна Хоум-игр
    static let homeGameListOpen = AnalyticsEvent(name: "page_view_home")

    /// Запуск видео хоум игры
    static let homeGameVideoPlay = AnalyticsEvent(name: "home_play")
}
