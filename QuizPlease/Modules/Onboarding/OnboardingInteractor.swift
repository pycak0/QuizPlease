//
//  OnboardingInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 14.09.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

/// Onboarding Interactor
protocol OnboardingInteractorProtocol {

    func getOnboardingItems(completion: @escaping ([OnboardingPageData]) -> Void)
}

final class OnboardingInteractor: OnboardingInteractorProtocol {

    private let jsonDecoder: JsonDecoder
    private let concurrentExecutor: AsyncExecutor

    init(
        jsonDecoder: JsonDecoder,
        concurrentExecutor: AsyncExecutor
    ) {
        self.jsonDecoder = jsonDecoder
        self.concurrentExecutor = concurrentExecutor
    }

    func getOnboardingItems(completion: @escaping ([OnboardingPageData]) -> Void) {
        concurrentExecutor.async { [jsonDecoder] in
            guard let path = Bundle.main.path(forResource: "onboarding", ofType: "json") else {
                completion([])
                return
            }

            let url = URL(fileURLWithPath: path)

            do {
                let data = try Data(contentsOf: url)
                let items = try jsonDecoder.decode([OnboardingPageData].self, from: data)
                completion(items)

            } catch {
                print("\(Self.self) | Error getting onboarding data: \(error)")
                completion([])
            }
        }
    }
}
