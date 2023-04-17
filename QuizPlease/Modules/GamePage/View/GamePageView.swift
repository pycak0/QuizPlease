//
//  GamePageView.swift
//  QuizPlease
//
//  Created by Владислав on 10.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit

private enum Constants {

    static let initialImageHeight: CGFloat = 270
}

/// GamePage view
final class GamePageView: UIView {

    // MARK: - Private Properties

    private var items: [GamePageItemProtocol] = []

    private lazy var context = GamePageViewContext(tableView: tableView, view: self)

    private var imageBaseHeight: CGFloat = Constants.initialImageHeight {
        didSet {
            headerViewHeightConstraint.constant = imageBaseHeight
        }
    }

    private lazy var headerViewHeightConstraint: NSLayoutConstraint = {
        headerView.heightAnchor.constraint(equalToConstant: imageBaseHeight)
    }()

    // MARK: - UI Elements

    private let headerView: GamePageHeaderView = {
        let headerView = GamePageHeaderView()
        headerView.translatesAutoresizingMaskIntoConstraints = false
        return headerView
    }()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.rowHeight = UITableView.automaticDimension
        tableView.canCancelContentTouches = false
        tableView.keyboardDismissMode = .interactiveWithAccessory
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray6Adapted
        makeLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateImageHeight()
    }

    override func endEditing(_ force: Bool) -> Bool {
        print("ended")
        return super.endEditing(force)
    }

    // MARK: - Internal Methods

    /// Set items to display in `GamePageView`
    /// - Parameter items: an array of items implementing `GamePageItemProtocol`
    func setItems(_ items: [GamePageItemProtocol]) {
        self.items = items
        imageBaseHeight = Constants.initialImageHeight
        registerCells()
        tableView.reloadData()
    }

    func addSpecialCondition(_ item: GamePageItemProtocol) {
        guard let index = items.lastIndex(where: { $0.kind == .specialCondition }) else { return }
        let newIndex = index + 1
        items.insert(item, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
    }

    func removeSpecialCondition(at conditionIndex: Int) {
        guard let firstItemIndex = items.firstIndex(where: { $0.kind == .specialCondition }) else { return }
        let actualItemIndex = firstItemIndex + conditionIndex
        let indexPath = IndexPath(row: actualItemIndex, section: 0)
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    func showAddButton(item: GamePageItemProtocol) {
        guard
            items.first(where: { $0.kind == .addSpecialCondition }) == nil,
            let index = items.lastIndex(where: { $0.kind == .specialCondition })
        else {
            return
        }
        register(item: item)

        let newIndex = index + 1
        items.insert(item, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
    }

    func hideAddButton() {
        guard let index = items.firstIndex(where: { $0.kind == .addSpecialCondition }) else { return }
        items.remove(at: index)
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
    }

    func scrollToRegistration() {
        guard let index = items.firstIndex(where: { $0.kind == .registrationHeader }) else { return }
        tableView.scrollToRow(at: IndexPath(row: index, section: 0), at: .top, animated: true)
    }

    func updatePaymentCountItems(with newItems: [GamePageItemProtocol]) {
        if let firstIndex = items.firstIndex(where: { $0.kind == .paymentCount }),
           let lastIndex = items.lastIndex(where: { $0.kind == .paymentCount }) {
            // replace or remove existing items, if any
            let range = firstIndex...lastIndex
            let indexPaths = range.map { IndexPath(row: $0, section: 0) }

            if newItems.isEmpty {
                items.removeSubrange(range)
                tableView.deleteRows(at: indexPaths, with: .fade)
            } else {
                items.replaceSubrange(range, with: newItems)
                tableView.reloadRows(at: indexPaths, with: .fade)
            }

            return
        }

        if let index = items.lastIndex(where: { $0.kind == .paymentType }) {
            // add new items
            let newFirstIndex = index + 1
            let newLastIndex = newFirstIndex + newItems.count - 1
            let indexPaths = (newFirstIndex...newLastIndex).map { IndexPath(row: $0, section: 0) }
            items.insert(contentsOf: newItems, at: newFirstIndex)
            tableView.insertRows(at: indexPaths, with: .fade)
        }
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
        items.forEach(register(item:))
    }

    private func register(item: GamePageItemProtocol) {
        let cellClass: AnyClass = item.cellClass(with: context)
        tableView.register(cellClass, forCellReuseIdentifier: makeReuseIdentifier(cellClass))
    }

    private func makeReuseIdentifier(_ cellClass: AnyClass) -> String {
        "\(Self.self)Cell_\(cellClass)"
    }

    private func updateImageHeight() {
        guard
            imageBaseHeight == Constants.initialImageHeight,
            let index = items.firstIndex(where: { $0.kind == .info }),
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
        else {
            return
        }
        imageBaseHeight = cell.frame.origin.y + 60
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

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        items[indexPath.row].isEditable()
    }
}

// MARK: - UITableViewDelegate

extension GamePageView: UITableViewDelegate {

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        cell.layoutIfNeeded()
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let actions = items[indexPath.row].trailingSwipeActions()
        if actions.isEmpty {
            return nil
        }
        return UISwipeActionsConfiguration(actions: actions)
    }
}

// MARK: - UIScrollViewDelegate

extension GamePageView: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isKind(of: UITableView.self) else { return }

        let offset = scrollView.contentOffset.y + scrollView.safeAreaInsets.top
        headerView.isHidden = offset > 700

        if offset <= 0 {
            // scrolls up -> image goes down
            headerViewHeightConstraint.constant = imageBaseHeight - offset
        } else {
            // scrolls down -> image goes up
            headerViewHeightConstraint.constant = max(0, imageBaseHeight - offset * 0.2)
        }
    }
}
