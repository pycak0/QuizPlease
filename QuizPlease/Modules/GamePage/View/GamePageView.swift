//
//  GamePageView.swift
//  QuizPlease
//
//  Created by Владислав on 10.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

/// GamePage view
final class GamePageView: UIView {

    // MARK: - Private Properties

    private var items: [GamePageItemProtocol] = [] {
        didSet {
            registerCells()
            tableView.reloadData()
        }
    }

    private lazy var context = GamePageViewContext(tableView: tableView, view: self)

    // MARK: - UI Elements

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    /// Set items to display in `GamePageView`
    /// - Parameter items: an array of items implementing `GamePageItemProtocol`
    func setItems(_ items: [GamePageItemProtocol]) {
        self.items = items
    }

    // MARK: - Private Methods

    private func configure() {
        addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: self.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }

    private func registerCells() {
        items.forEach {
            let cellClass: AnyClass = $0.cellClass(with: context)
            tableView.register(cellClass, forCellReuseIdentifier: makeReuseIdentifier(cellClass))
        }
    }

    private func makeReuseIdentifier(_ cellClass: AnyClass) -> String {
        "\(Self.self)Cell_\(cellClass)"
    }
}

// MARK: - UITableViewDataSource

extension GamePageView: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = items[indexPath.row]
        let cellClass: AnyClass = model.cellClass(with: context)

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: makeReuseIdentifier(cellClass),
            for: indexPath
        ) as? GamePageCellProtocol else {
            fatalError("Unknown cell kind: \(cellClass)")
        }

        cell.configure(with: model)
        return cell
    }
}

// MARK: - UITableViewDelegate

extension GamePageView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
