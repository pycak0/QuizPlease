//
//  GamePageViewController.swift
//  QuizPlease
//
//  Created by Владислав on 04.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

protocol SpecialConditionsView: AnyObject {

    func addSpecialCondition(_ item: GamePageItemProtocol)

    func removeSpecialCondition(at index: Int)

    func showAddButton(item: GamePageItemProtocol)

    func hideAddButton()
}

/// Game page screen view output protocol
protocol GamePageViewOutput {

    /// GamePage view did load
    func viewDidLoad()
}

/// Game page screen view protocol
protocol GamePageViewInput: AnyObject,
                            LoadingIndicator,
                            SpecialConditionsView,
                            PaymentSectionViewUpdater {

    /// Set items to display in `GamePageView`
    /// - Parameter items: an array of items implementing `GamePageItemProtocol`
    func setItems(_ items: [GamePageItemProtocol])

    /// Set GamePage title
    /// - Parameter title: Title text
    func setTitle(_ title: String)

    /// Set the image with given path to the header view
    /// - Parameter path: image location on a server
    func setHeaderImage(path: String)

    /// Show error alert
    func showAlert(_ error: Error, handler: (() -> Void)?)

    func showAlert(title: String, message: String)

    func scrollToRegistration()

    /// Reconfigures the first item of given kind
    func updateFirstItem(kind: GamePageItemKind)

    /// Reconfigures the last item of given kind
    func updateLastItem(kind: GamePageItemKind)
}

/// Game page screen view controller
final class GamePageViewController: UIViewController {

    // MARK: - UI Elements

    private let activityIndicator = UIActivityIndicatorView()

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

    func startLoading() {
        view.isUserInteractionEnabled = false
        activityIndicator.enableCentered(in: view, color: .systemBlue)
    }

    func stopLoading() {
        view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }

    func showAlert(_ error: Error, handler: (() -> Void)?) {
        showErrorConnectingToServerAlert { _ in
            handler?()
        }
    }

    func showAlert(title: String, message: String) {
        showSimpleAlert(title: title, message: message)
    }

    func scrollToRegistration() {
        gamePageView.scrollToRegistration()
    }

    func updateFirstItem(kind: GamePageItemKind) {
        gamePageView.updateFirstItem(kind: kind)
    }

    func updateLastItem(kind: GamePageItemKind) {
        gamePageView.updateLastItem(kind: kind)
    }

    // MARK: - SpecialConditionsView

    func addSpecialCondition(_ item: GamePageItemProtocol) {
        gamePageView.addSpecialCondition(item)
    }

    func removeSpecialCondition(at index: Int) {
        gamePageView.removeSpecialCondition(at: index)
    }

    func showAddButton(item: GamePageItemProtocol) {
        gamePageView.showAddButton(item: item)
    }

    func hideAddButton() {
        gamePageView.hideAddButton()
    }

    // MARK: - PaymentSectionViewUpdater

    func updatePaymentCountAndSumItems(with newItems: [GamePageItemProtocol]) {
        gamePageView.updatePaymentCountAndSumItems(with: newItems)
    }
}
