//
//  GamePageEndpoint.swift
//  QuizPlease
//
//  Created by Владислав on 09.10.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

/// Endpoint class for the GameOrder / GamePage screen
public final class GamePageEndpoint: ApplinkEndpoint {

    static let identifier = "game"

    func show(parameters: [String: String]) -> Bool {
        print("📲 GameOrder Endpoint entry")
        let gameIdString = parameters["gameId"] ?? parameters["id"]
        guard let gameIdString, let gameId = Int(gameIdString) else {
            logFail("Did not find game id among the launch parameters")
            return false
        }

        guard let topNavigationController = UIApplication.shared
            .getKeyWindow()?
            .topNavigationController
        else {
            logFail("Could not find topNavigationController of the App")
            return false
        }

        let viewController: UIViewController

        if AppSettings.isGamePageEnabled {
            viewController = GamePageAssembly(
                launchOptions: .init(
                    gameId: gameId,
                    shouldScrollToRegistration: false
                )
            ).makeViewController()
        } else {
            viewController = GameOrderAssembly(
                gameId: gameId,
                cityId: AppSettings.defaultCity.id,
                shouldScrollToSignUp: false,
                shouldLoadGameInfo: true
            ).makeViewController()
        }

        topNavigationController.pushViewController(viewController, animated: true)
        print("✅ Successful transition to GamePage Screen")
        return true
    }

    private func logFail(_ message: String) {
        print("❌ Unsuccessful transition: \(message)")
    }
}
