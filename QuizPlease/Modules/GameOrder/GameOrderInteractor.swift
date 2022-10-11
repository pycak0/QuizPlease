//
//  GameOrderInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 13.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation
import YooKassaPayments

// MARK: - Interactor Protocol

protocol GameOrderInteractorProtocol {

    /// must be weak
    var output: GameOrderInteractorOutput? { get }

    func loadGameInfo(id: Int)

    func register(
        with form: RegisterForm,
        specialConditions: [SpecialCondition],
        paymentMethod: PaymentMethodType?
    )

    /// Check if special condition (promocode or certificate is valid
    /// - Parameters:
    ///   - value: promocode / certificate value
    ///   - id: game identifier
    ///   - name: team name
    func checkSpecialCondition(
        _ value: String,
        forGameWithId id: Int,
        selectedTeamName name: String
    )

    /// Check if team name is alrready used.
    /// - Parameters:
    ///   - name: provided team name
    ///   - gameId: game identifier
    ///   - completion: Callback that contains a boolean argument,
    ///   whether team is registered (`true`) or not (`false`).
    func checkForTeamName(
        _ name: String,
        gameId: Int,
        completion: @escaping (_ isTeamRegistered: Bool) -> Void
    )
}

// MARK: - Output Protocol

protocol GameOrderInteractorOutput: AnyObject {

    func interactor(
        _ interactor: GameOrderInteractorProtocol,
        didFailLoadingGameInfo error: NetworkServiceError
    )

    func interactor(
        _ interactor: GameOrderInteractorProtocol,
        didLoad gameInfo: GameInfo
    )

    func interactor(_ interactor: GameOrderInteractorProtocol?, errorOccured error: NetworkServiceError)

    func interactor(
        _ interactor: GameOrderInteractorProtocol?,
        didCheckSpecialCondition value: String,
        with response: SpecialCondition.Response
    )

    func interactor(
        _ interactor: GameOrderInteractorProtocol?,
        didRegisterWithResponse: GameOrderResponse,
        paymentMethod: PaymentMethodType?
    )
}

// MARK: - Implementation

final class GameOrderInteractor: GameOrderInteractorProtocol {

    private let networkService: NetworkService
    private let asyncExecutor: AsyncExecutor

    weak var output: GameOrderInteractorOutput?

    /// Initializer
    init(
        networkService: NetworkService,
        asyncExecutor: AsyncExecutor
    ) {
        self.networkService = networkService
        self.asyncExecutor = asyncExecutor
    }

    func loadGameInfo(id: Int) {
        var shortGame: GameShortInfo?
        var detailGame: GameInfo?

        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()

        let whenGamesLoaded = DispatchWorkItem { [weak self] in
            guard let self = self else { return }
            guard
                let shortGame = shortGame,
                var detailGame = detailGame
            else {
                self.output?.interactor(self, didFailLoadingGameInfo: .serverError(500))
                return
            }
            detailGame.setShortInfo(shortGame)
            self.output?.interactor(self, didLoad: detailGame)
        }
        dispatchGroup.notify(queue: .main, work: whenGamesLoaded)

        var detailInfoTask: DispatchWorkItem?
        let shortInfoTask = DispatchWorkItem {
            NetworkService.shared.getSchedule(with: ScheduleFilter()) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(games):
                    shortGame = games.first { $0.id == id }
                case let .failure(error):
                    detailInfoTask?.cancel()
                    whenGamesLoaded.cancel()
                    self.output?.interactor(self, didFailLoadingGameInfo: error)
                }
                dispatchGroup.leave()
            }
        }

        detailInfoTask = DispatchWorkItem {
            NetworkService.shared.getGameInfo(by: id) { [weak self] result in
                guard let self = self else { return }
                switch result {
                case let .success(gameInfo):
                    detailGame = gameInfo
                case let .failure(error):
                    shortInfoTask.cancel()
                    whenGamesLoaded.cancel()
                    self.output?.interactor(self, didFailLoadingGameInfo: error)
                }
                dispatchGroup.leave()
            }
        }

        for task in [shortInfoTask, detailInfoTask] {
            asyncExecutor.async {
                task?.perform()
            }
        }
    }

    func register(
        with registerForm: RegisterForm,
        specialConditions: [SpecialCondition],
        paymentMethod: PaymentMethodType?
    ) {
        let certificates: [MultipartFormDataObject] = specialConditions
            .lazy
            .filter { $0.discountInfo?.kind == .certificate }
            .compactMap { MultipartFormDataObject(name: "certificates[]", optionalStringData: $0.value) }

        let promocode = specialConditions.first(where: { $0.discountInfo?.kind == .promocode })?.value

        // swiftlint:disable colon
        let params: [String: String?] = [
            /// 2 - регистрация через мобильное приложение
            "QpRecord[registration_type]":  "2",
            "QpRecord[captainName]":        registerForm.captainName,
            "QpRecord[email]":              registerForm.email,
            "QpRecord[phone]":              registerForm.phone,
            "QpRecord[comment]":            registerForm.comment ?? "",
            "QpRecord[game_id]":            "\(registerForm.gameId)",
            "QpRecord[first_time]":         registerForm.isFirstTime ? "1" : "0",
            "QpRecord[payment_type]":       "\(registerForm.paymentType.rawValue)",
            "QpRecord[count]":              "\(registerForm.count)",
            "QpRecord[teamName]":           registerForm.teamName,
            "QpRecord[payment_token]":      registerForm.paymentToken,
            "QpRecord[surcharge]":          registerForm.countPaidOnline.map { "\($0)" },
            "promo_code":                   promocode
        ]
        // swiftlint:enable colon

        let formData: [MultipartFormDataObject] = certificates + MultipartFormDataObjects(params)

        networkService.afPost(
            with: formData,
            to: "/ajax/save-record",
            responseType: GameOrderResponse.self
        ) { [weak self] serverResult in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                self.output?.interactor(self, errorOccured: error)
            case let .success(response):
                self.output?.interactor(self, didRegisterWithResponse: response, paymentMethod: paymentMethod)
            }
        }
    }

    func checkSpecialCondition(
        _ value: String,
        forGameWithId id: Int,
        selectedTeamName name: String
    ) {
        networkService.get(
            SpecialCondition.Response.self,
            apiPath: "/ajax/check-code",
            parameters: [
                "game_id": "\(id)",
                "code": value,
                "name": name
            ]
        ) { [weak self] serverResult in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                self.output?.interactor(self, errorOccured: error)
            case let .success(response):
                self.output?.interactor(self, didCheckSpecialCondition: value, with: response)
            }
        }
    }

    func checkForTeamName(_ name: String, gameId: Int, completion: @escaping (Bool) -> Void) {
        let params: [String: String] = [
            "QpRecord[game_id]": "\(gameId)",
            "QpRecord[teamName]": name
        ]

        networkService.afPost(
            with: params,
            to: "/ajax/is-record-name-exist",
            responseType: Bool.self
        ) { result in
            switch result {
            case let .failure(error):
                self.output?.interactor(self, errorOccured: error)
            case let .success(isTeamRegistered):
                completion(isTeamRegistered)
            }
        }
    }
}
