//
//  GamePageViewController.swift
//  QuizPlease
//
//  Created by Владислав on 04.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// Game page screen view output protocol
protocol GamePageViewOutput {


}

/// Game page screen view protocol
protocol GamePageView: AnyObject {


}

/// Game page screen view controller
final class GamePageViewController: UIViewController {

    // MARK: - Private Properties

    private let output: GamePageViewOutput

    // MARK: - Lifecycle

    /// Initializer
    /// - Parameter output: Game page screen view output
    init(output: GamePageViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
