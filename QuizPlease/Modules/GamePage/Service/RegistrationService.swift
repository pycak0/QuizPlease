//
//  RegistrationService.swift
//  QuizPlease
//
//  Created by Владислав on 14.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import Foundation

protocol SpecialConditionsProvider: AnyObject {

    var canAddSpecialCondition: Bool { get }

    func getSpecialConditions() -> [SpecialCondition]

    /// If can make a new one, returns it. Otherwise, returns nil
    func addSpecialCondition() -> SpecialCondition?

    func removeSpecialCondition(at index: Int)
}

/// Service that manages register form
protocol RegistrationServiceProtocol: AnyObject,
                                      GamePageRegisterFormProvider,
                                      SpecialConditionsProvider {

    /// Loads necessary registration data about the game
    func loadData()

    /// Provides a reference to the managed register form
    func getRegisterForm() -> RegisterForm

    /// Provides a custom fields array with editable user input properties
    func getCustomFields() -> [CustomFieldModel]

    func checkSpecialCondition(
        _ value: String,
        completion: @escaping (_ success: Bool, _ message: String) -> Void
    )
}

/// Service that manages register form
final class RegistrationService {

    private let specialConditionsLimit = 9

    private let gameInfoLoader: GameInfoLoader
    private let networkService: NetworkServiceProtocol
    private let registerForm: RegisterForm
    private var customFields: [CustomFieldModel] = []
    private var specialConditions: [SpecialCondition] = [SpecialCondition()]

    /// Initialize `RegistrationService`
    /// - Parameters:
    ///   - gameId: Game identifier
    ///   - gameInfoLoader: Service that loads Game info
    ///
    /// Creates a new register form
    init(
        gameId: Int,
        gameInfoLoader: GameInfoLoader,
        networkService: NetworkServiceProtocol
    ) {
        self.registerForm = RegisterForm(
            cityId: AppSettings.defaultCity.id,
            gameId: gameId
        )
        self.gameInfoLoader = gameInfoLoader
        self.networkService = networkService
    }
}

// MARK: - RegistrationServiceProtocol

extension RegistrationService: RegistrationServiceProtocol {

    var canAddSpecialCondition: Bool {
        specialConditions.count < specialConditionsLimit
    }

    func loadData() {
        gameInfoLoader.load(gameId: registerForm.gameId) { [weak self] result in
            guard let self, let gameInfo = try? result.get() else { return }
            self.customFields = gameInfo.customFields?.map { CustomFieldModel(data: $0) } ?? []
        }
    }

    func getRegisterForm() -> RegisterForm {
        registerForm
    }

    func getCustomFields() -> [CustomFieldModel] {
        customFields
    }

    func getSpecialConditions() -> [SpecialCondition] {
        specialConditions
    }

    func addSpecialCondition() -> SpecialCondition? {
        guard specialConditions.count < specialConditionsLimit else { return nil }
        let newCondition = SpecialCondition()
        specialConditions.append(newCondition)
        return newCondition
    }

    func removeSpecialCondition(at index: Int) {
        specialConditions.remove(at: index)
    }

    func checkSpecialCondition(_ value: String, completion: @escaping (_ success: Bool, _ message: String) -> Void) {
        networkService.get(
            SpecialCondition.Response.self,
            apiPath: "/ajax/check-code",
            parameters: [
                "game_id": "\(registerForm.gameId)",
                "code": value,
                "name": registerForm.teamName
            ]
        ) { [weak self] serverResult in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                completion(false, error.localizedDescription)
            case let .success(response):
                switch response.discountInfo.kind {
                case .promocode:
                    if self.specialConditions.filter({ $0.discountInfo?.kind == .promocode }).count > 0 {
                        completion(false, "На одну игру возможно использовать только один промокод")
                        return
                    }
                default:
                    break
                }
                if let index = self.specialConditions.firstIndex(where: { $0.value == value }) {
                    self.specialConditions[index].discountInfo = response.discountInfo
                }

                completion(response.success, response.message)
            }
        }
    }
}
