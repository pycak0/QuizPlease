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
    func showErrorConnectingToServerAlert(handler: (() -> Void)?)

    /// Show custom alert 
    func showAlert(title: String, message: String, handler: (() -> Void)?)

    /// Scrolls to the given item kind
    func scrollToItem(kind: GamePageItemKind)

    /// Scrolls to the given item kind and provides a handler to execute after the scroll
    func scrollToItem(kind: GamePageItemKind, completion: (() -> Void)?)

    /// Reconfigures the first item of given kind
    func updateFirstItem(kind: GamePageItemKind)

    /// Reconfigures the last item of given kind
    func updateLastItem(kind: GamePageItemKind)

    /// Hides keyboard and ends editing
    func endEditing()

    /// Scroll to item with given kind and ask to edit it 
    func editItem(kind: GamePageItemKind)
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

    func showErrorConnectingToServerAlert(handler: (() -> Void)?) {
        showErrorConnectingToServerAlert { _ in
            handler?()
        }
    }

    func showAlert(title: String, message: String, handler: (() -> Void)?) {
        showSimpleAlert(title: title, message: message) { _ in
            handler?()
        }
    }

    func updateFirstItem(kind: GamePageItemKind) {
        gamePageView.updateFirstItem(kind: kind)
    }

    func updateLastItem(kind: GamePageItemKind) {
        gamePageView.updateLastItem(kind: kind)
    }

    func endEditing() {
        view.endEditing(true)
    }

    func editItem(kind: GamePageItemKind) {
        scrollToItem(kind: kind) { [weak self] in
            self?.gamePageView.editItem(kind: kind)
        }
    }

    func scrollToItem(kind: GamePageItemKind) {
        scrollToItem(kind: kind, completion: nil)
    }

    func scrollToItem(kind: GamePageItemKind, completion: (() -> Void)?) {
        gamePageView.scrollToItem(kind: kind)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            completion?()
        }
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
