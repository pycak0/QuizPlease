//
//  WarmupQuestionsService.swift
//  QuizPlease
//
//  Created by Владислав on 10.08.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

protocol WarmupQuestionsService {

    func getWarmupQuestions(completion: @escaping (Result<[WarmupQuestion], NetworkServiceError>) -> Void)

    func sendWarmupAnswer(
        questionId: String,
        answerId: Int,
        completion: @escaping (Result<WarmupAnswerResponse, NetworkServiceError>) -> Void
    )
}

final class WarmupQuestionsServiceImpl: WarmupQuestionsService {

    private let networkService: NetworkService
    private let deviceIdProvider: DeviceIdProvider

    init(
        networkService: NetworkService,
        deviceIdProvider: DeviceIdProvider
    ) {
        self.networkService = networkService
        self.deviceIdProvider = deviceIdProvider
    }

    // MARK: - Get Warmup Questions
    func getWarmupQuestions(
        completion: @escaping (Result<[WarmupQuestion], NetworkServiceError>) -> Void
    ) {
        guard let deviceId = deviceIdProvider.get() else {
            completion(.failure(.invalidToken))
            return
        }

        networkService.getStandard(
            [WarmupQuestion].self,
            apiPath: "/api/warmup-question",
            parameters: [
                "device_id": deviceId
            ],
            authorizationKind: .none,
            completion: completion
        )
    }

    func sendWarmupAnswer(
        questionId: String,
        answerId: Int,
        completion: @escaping (Result<WarmupAnswerResponse, NetworkServiceError>) -> Void
    ) {
        networkService.afPostStandard(
            bodyParameters: [
                "answer": "\(answerId)"
            ],
            to: "/api/warmup-question/send-answer",
            queryParameters: [
                "question_id": questionId,
                "device_id": deviceIdProvider.get()
            ],
            responseType: WarmupAnswerResponse.self,
            authorizationKind: .none,
            completion: completion
        )
    }
}
