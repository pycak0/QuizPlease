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

    private lazy var headerViewHeightConstraint: NSLayoutConstraint = {
        headerView.heightAnchor.constraint(equalToConstant: 270)
    }()

    // MARK: - UI Elements

    private let headerView: GamePageHeaderView = {
        let headerView = GamePageHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6Adapted
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        makeLayout()
    }

    // MARK: - Internal Methods

    /// Set items to display in `GamePageView`
    /// - Parameter items: an array of items implementing `GamePageItemProtocol`
    func setItems(_ items: [GamePageItemProtocol]) {
        self.items = items
    }

    /// Set the image with given path to the header view
    /// - Parameter path: image location on a server
    func setHeaderImage(path: String) {
        headerView.setImage(path: path)
    }

    // MARK: - Private Methods

    private func makeLayout() {
        addSubview(headerView)
        addSubview(tableView)
        NSLayoutConstraint.activate([
            headerView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            headerView.topAnchor.constraint(equalTo: self.layoutMarginsGuide.topAnchor),
            headerView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            headerViewHeightConstraint,

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
