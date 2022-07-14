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

extension NetworkService: WarmupQuestionsService {}

final class WarmupQuestionsServiceMock: WarmupQuestionsService {

    let numberOfQuestions: Int

    init(maxNumberOfQuestions: Int) {
        numberOfQuestions = maxNumberOfQuestions
    }

    func getWarmupQuestions(completion: @escaping (Result<[WarmupQuestion], NetworkServiceError>) -> Void) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            let path = Bundle.main.path(forResource: "MockWarmupQuestionsData", ofType: "json")!
            let data = FileManager.default.contents(atPath: path)!

            let response: ServerResponse<[WarmupQuestion]>
            do {
                response = try JSONDecoder().decode(type(of: response), from: data)
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.decoding(error)))
                }
                return
            }

            let array = Array(response.data.prefix(self.numberOfQuestions))
            DispatchQueue.main.async {
                completion(.success(array))
            }
        }
    }

    func sendWarmupAnswer(
        questionId: String,
        answerId: Int,
        completion: @escaping (Result<WarmupAnswerResponse, NetworkServiceError>) -> Void
    ) {
        let response = WarmupAnswerResponse(message: Bool.random())
        completion(.success(response))
    }
}
