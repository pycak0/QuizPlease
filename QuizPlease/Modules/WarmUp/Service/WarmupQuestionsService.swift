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

    private let networkService: NetworkServiceProtocol
    private let deviceIdProvider: DeviceIdProvider

    init(
        networkService: NetworkServiceProtocol,
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

        networkService.get(
            ServerResponse<[WarmupQuestion]>.self,
            apiPath: ApiConstants.Path.warmupQuestion,
            parameters: [
                "device_id": deviceId
            ]
        ) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    func sendWarmupAnswer(
        questionId: String,
        answerId: Int,
        completion: @escaping (Result<WarmupAnswerResponse, NetworkServiceError>) -> Void
    ) {
        guard let questionIdInt = Int(questionId), let deviceId = deviceIdProvider.get() else {
            completion(.failure(.encodingError))
            return
        }

        let answerData = WarmupAnswerData(
            answer: answerId,
            questionId: questionIdInt,
            deviceId: deviceId
        )

        networkService.post(
            answerData,
            apiPath: ApiConstants.Path.warmupSendAnswer,
            parameters: nil,
            reponseType: ServerResponse<WarmupAnswerResponse>.self,
            completion: { result in
                switch result {
                case .success(let response):
                    completion(.success(response.data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        )
    }
}

