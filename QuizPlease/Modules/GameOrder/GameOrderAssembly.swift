//
//  GameOrderAssembly.swift
//  QuizPlease
//
//  Created by Владислав on 09.10.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

final class GameOrderAssembly: ViewAssembly {

    private let configurator = GameOrderConfigurator()
    private let gameId: Int
    private let cityId: Int
    private let shouldScrollToSignUp: Bool
    private let shouldLoadGameInfo: Bool

    init(
        gameId: Int,
        cityId: Int,
        shouldScrollToSignUp: Bool,
        shouldLoadGameInfo: Bool
    ) {
        self.gameId = gameId
        self.cityId = cityId
        self.shouldScrollToSignUp = shouldScrollToSignUp
        self.shouldLoadGameInfo = shouldLoadGameInfo
    }

    func makeViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)

        guard let gameOrderVC = storyboard.instantiateViewController(
            withIdentifier: "\(GameOrderVC.self)"
        ) as? GameOrderVC else {
            logFail("Could not instantiate view controller from storyboard")
            return UIViewController()
        }

        var info = GameInfo()
        info.id = gameId

        configurator.configure(gameOrderVC, with: GameOrderPresentationOptions(
            gameInfo: info,
            cityId: cityId,
            shouldScrollToSignUp: shouldScrollToSignUp,
            shouldLoadGameInfo: shouldLoadGameInfo
        ))

        return gameOrderVC
    }

    private func logFail(_ message: String) {
        print("❌ Error assembling GameOrder Screen: \(message)")
    }
}
