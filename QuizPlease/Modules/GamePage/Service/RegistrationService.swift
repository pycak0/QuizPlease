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

    func validateRegisterForm(completion: @escaping (RegisterFormValidationResult) -> Void)
}

/// Service that manages register form
protocol RegistrationServiceProtocol: AnyObject,
                                      GamePageRegisterFormProvider,
                                      SpecialConditionsProvider {

    /// Provides a reference to the managed register form
    func getRegisterForm() -> RegisterForm

    /// Provides a custom fields array with editable user input properties
    func getCustomFields() -> [CustomFieldModel]

    /// Sets a new list of custom fields replacing the old ones
    func setCustomFields(_ newFields: [CustomFieldModel])

    func checkSpecialCondition(
        _ value: String,
        completion: @escaping (_ success: Bool, _ message: String) -> Void
    )
}

/// Service that manages register form
final class RegistrationService {

    // MARK: - Private Properties

    private let specialConditionsLimit = 9

    private let networkService: NetworkServiceProtocol
    private let registerForm: RegisterForm
    private var customFields: [CustomFieldModel] = []
    private var specialConditions: [SpecialCondition] = [SpecialCondition()]

    // MARK: - Lifecycle

    /// Initialize `RegistrationService`
    /// - Parameters:
    ///   - gameId: Game identifier
    ///   - gameInfoLoader: Service that loads Game info
    ///
    /// Creates a new register form
    init(
        gameId: Int,
        networkService: NetworkServiceProtocol
    ) {
        self.registerForm = RegisterForm(
            cityId: AppSettings.defaultCity.id,
            gameId: gameId
        )
        self.networkService = networkService
    }

    // MARK: - Private Methods

    private func validateForm() -> [RegisterFormValidationResult.Error] {
        var errors = [RegisterFormValidationResult.Error]()

        if registerForm.email.isEmpty || registerForm.captainName.isEmpty || registerForm.teamName.isEmpty {
            errors.append(.someFieldsEmpty)
        }

        if !registerForm.email.isValidEmail {
            errors.append(.email)
        }

        if !PhoneNumberKitInstance.shared.isValidPhoneNumber(registerForm.phone) {
            errors.append(.phone)
        }

        if errors.isEmpty && !registerForm.isValid {
            errors.append(.unknown)
        }

        return errors
    }

    private func validateFormOnServer(completion: @escaping ([RegisterFormValidationResult.Error]) -> Void) {
        networkService.afPost(
            with: [
                "QpRecord[game_id]": "\(registerForm.gameId)",
                "QpRecord[teamName]": registerForm.teamName
            ],
            to: "/ajax/is-record-name-exist",
            responseType: Bool.self
        ) { result in
            var errors = [RegisterFormValidationResult.Error]()

            switch result {
            case let .failure(error):
                errors.append(.network(error))
            case let .success(isTeamRegistered):
                if isTeamRegistered {
                    errors.append(.invalidTeamName)
                }
            }

            completion(errors)
        }
    }
}

// MARK: - RegistrationServiceProtocol

extension RegistrationService: RegistrationServiceProtocol {

    var canAddSpecialCondition: Bool {
        specialConditions.count < specialConditionsLimit
    }

    func getRegisterForm() -> RegisterForm {
        registerForm
    }

    func getCustomFields() -> [CustomFieldModel] {
        customFields
    }

    func setCustomFields(_ newFields: [CustomFieldModel]) {
        customFields = newFields
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

    func validateRegisterForm(completion: @escaping (RegisterFormValidationResult) -> Void) {
        // 1. Local validations
        let localErrors = validateForm()
        guard localErrors.isEmpty else {
            completion(RegisterFormValidationResult(isValid: false, errors: localErrors))
            return
        }

        // 2. Server Validations
        validateFormOnServer { errors in
            completion(RegisterFormValidationResult(isValid: errors.isEmpty, errors: errors))
        }
    }
}
