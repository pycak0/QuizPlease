//
//  GameOrderEndpoint.swift
//  QuizPlease
//
//  Created by Владислав on 09.10.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import UIKit

/// Endpoint class for the GameOrder screen
public final class GameOrderEndpoint: ApplinkEndpoint {

    static let identifier = "game"

    func show(parameters: [String: String]) -> Bool {
        print("📲 GameOrder Endpoint entry")
        guard let gameIdString = parameters["gameId"], let gameId = Int(gameIdString) else {
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

        let assembly = GameOrderAssembly(
            gameId: gameId,
            cityId: AppSettings.defaultCity.id,
            shouldScrollToSignUp: false,
            shouldLoadGameInfo: true
        )

        let gameOrderVC = assembly.makeViewController()
        topNavigationController.pushViewController(gameOrderVC, animated: true)
        print("✅ Successful transition to Schedule Screen")
        return true
    }

    private func logFail(_ message: String) {
        print("❌ Unsuccessful transition: \(message)")
    }
}
