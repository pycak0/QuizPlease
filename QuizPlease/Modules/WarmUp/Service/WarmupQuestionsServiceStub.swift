//
//  WarmupQuestionsServiceStub.swift
//  QuizPlease
//
//  Created by Владислав on 01.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

final class WarmupQuestionsServiceStub: WarmupQuestionsService {

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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            completion(.success(response))
        }
    }
}
