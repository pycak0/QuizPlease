//
//  PickCityAssembly.swift
//  QuizPlease
//
//  Created by Владислав on 23.03.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// PickCity ViewController Assembly
final class PickCityAssembly {

    /// Create instance of PickCity ViewController
    func makePickCityViewController(
        selectedCity: City?,
        delegate: PickCityVCDelegate?
    ) -> UIViewController {
        UINavigationController(
            rootViewController: PickCityVC(
                selectedCity: selectedCity,
                delegate: delegate
            )
        )
    }
}
