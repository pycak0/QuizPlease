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

    /// GamePage view did load
    func viewDidLoad()
}

/// Game page screen view protocol
protocol GamePageViewInput: AnyObject {

    /// Set items to display in `GamePageView`
    /// - Parameter items: an array of items implementing `GamePageItemProtocol`
    func setItems(_ items: [GamePageItemProtocol])

    /// Set GamePage title
    /// - Parameter title: Title text
    func setTitle(_ title: String)

    /// Set the image with given path to the header view
    /// - Parameter path: image location on a server
    func setHeaderImage(path: String)
}

/// Game page screen view controller
final class GamePageViewController: UIViewController {

    // MARK: - UI Elements

    private let gamePageView: GamePageView = {
        let gamePageView = GamePageView()
        return gamePageView
    }()

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

    override func loadView() {
        view = gamePageView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        output.viewDidLoad()
    }
}

// MARK: - GamePageViewInput

extension GamePageViewController: GamePageViewInput {

    func setItems(_ items: [GamePageItemProtocol]) {
        gamePageView.setItems(items)
    }

    func setTitle(_ title: String) {
        prepareNavigationBar(
            title: title,
            barStyle: .transcluent(tintColor: .systemBackgroundAdapted)
        )
    }

    func setHeaderImage(path: String) {
        gamePageView.setHeaderImage(path: path)
    }
}
