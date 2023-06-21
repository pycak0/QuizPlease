//
//  RatingVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// MARK: - View Protocol

protocol RatingViewProtocol: UIViewController, LoadingIndicator {

    var presenter: RatingPresenterProtocol! { get set }

    func setItems(_ items: [RatingItem])
    func addItems(_ newItems: [RatingItem])

    func configure()
    func setHeaderLabelContent(city: String, leagueComment: String, ratingScopeComment: String)
}

final class RatingVC: UIViewController {

    var presenter: RatingPresenterProtocol!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    private var items: [RatingItem] = []

    // MARK: - UI Elements

    @IBOutlet private weak var expandingHeader: ExpandingHeader!

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.allowsSelection = false
            tableView.separatorColor = .white.withAlphaComponent(0.3)
            tableView.register(RatingEmptyCell.self, forCellReuseIdentifier: "\(RatingEmptyCell.self)")
            tableView.refreshControl = UIRefreshControl(
                tintColor: .lemon,
                target: self,
                action: #selector(refreshControlTriggered)
            )
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .ripePlum
        RatingConfigurator().configure(self)
        presenter.viewDidLoad(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.tintColor = .labelAdapted
    }

    @objc
    private func refreshControlTriggered() {
        presenter.handleRefreshControl()
    }
}

// MARK: - RatingViewProtocol

extension RatingVC: RatingViewProtocol {

    func setItems(_ items: [RatingItem]) {
        self.items = items
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }

    func addItems(_ newItems: [RatingItem]) {
        let startIndex = items.count
        self.items += newItems
        let indexPaths = (startIndex..<items.count).map { IndexPath(row: $0, section: 0) }
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.insertRows(at: indexPaths, with: .none)
            tableView.endUpdates()
        }
    }

    func stopLoading() {
        if tableView.refreshControl?.isRefreshing ?? false {
            tableView.refreshControl?.endRefreshing()
        }
        tableView.tableFooterView?.isHidden = true
    }

    func startLoading() {
        tableView.tableFooterView?.isHidden = false
    }

    func configure() {
        expandingHeader.delegate = self
        expandingHeader.dataSource = self
    }

    func setHeaderLabelContent(city: String, leagueComment: String, ratingScopeComment: String) {
        expandingHeader.setFooterContent(
            city: city,
            gameType: leagueComment,
            season: ratingScopeComment
        )
    }
}

// MARK: - ExpandingHeaderDelegate

extension RatingVC: ExpandingHeaderDelegate {

    func didPressGameTypeView(in expandingHeader: ExpandingHeader, completion: @escaping (String?) -> Void) {
        showChooseItemActionSheet(itemNames: presenter.availableGameTypeNames) { [unowned self] (selectedName, index) in
            self.presenter.didChangeLeague(index)
            completion(selectedName)
        }
    }

    func expandingHeader(_ expandingHeader: ExpandingHeader, didChangeStateTo isExpanded: Bool) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func expandingHeader(_ expandingHeader: ExpandingHeader, didChange selectedSegment: Int) {
        presenter.didChangeRatingScope(selectedSegment)
    }

    func expandingHeaderDidBeginEditingQuery(_ expandingHeader: ExpandingHeader) {
    }

    func expandingHeader(_ expandingHeader: ExpandingHeader, didEndSearchingWith query: String) {
        presenter.didHideKeyboard(with: query)
    }

    func expandingHeader(_ expandingHeader: ExpandingHeader, didChange query: String) {
        presenter.didChangeTeamName(query)
    }

    func expandingHeader(_ expandingHeader: ExpandingHeader, didPressReturnButtonWith query: String) {
        presenter.didPressSearchButton(with: query)
    }
}

// MARK: - ExpandingHeaderDataSource

extension RatingVC: ExpandingHeaderDataSource {

    func numberOfSegmentControlItems(in expandingHeader: ExpandingHeader) -> Int {
        return presenter.availableFilters.count
    }

    func expandingHeaderSelectedSegmentIndex(_ expandingHeader: ExpandingHeader) -> Int {
        presenter.filter.scope.rawValue
    }

    func expandingHeader(_ expandingHeader: ExpandingHeader, titleForSegmentAtIndex segmentIndex: Int) -> String {
        presenter.availableFilters[segmentIndex].title
    }

    func expandingHeaderInitialSelectedGameType(_ expandingHeader: ExpandingHeader) -> String {
        presenter.availableGameTypeNames.first ?? ""
    }
}

// MARK: - Data Source & Delegate

extension RatingVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = items[indexPath.row]
        let cellClass = item.cellClass()

        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "\(cellClass)",
            for: indexPath
        ) as? RatingCell else {
            fatalError("Unknown cell kind: \(cellClass)")
        }

        cell.configure(with: item)

        let itemsCount = items.count
        if itemsCount > 1, indexPath.row == itemsCount - 1 {
            presenter.needsLoadingMoreItems()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
