//
// MARK: RatingVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// MARK: - View Protocol
protocol RatingViewProtocol: UIViewController, LoadingIndicator {
    var presenter: RatingPresenterProtocol! { get set }

    func reloadRatingList()
    func appendRatingItems(at indices: Range<Int>)

    func configure()
    func setHeaderLabelContent(city: String, leagueComment: String, ratingScopeComment: String)
}

final class RatingVC: UIViewController {
    var presenter: RatingPresenterProtocol!

    @IBOutlet private weak var expandingHeader: ExpandingHeader!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.allowsSelection = false
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

// MARK: - Protocol Implementation
extension RatingVC: RatingViewProtocol {
    func reloadRatingList() {
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }

    func appendRatingItems(at indices: Range<Int>) {
        let indexPaths = indices.map { IndexPath(row: $0, section: 0) }
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .none)
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
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
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
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
        return presenter.filteredTeams.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(RatingCell.self, for: indexPath)
        let team = presenter.filteredTeams[indexPath.row]

        cell.configure(
            with: team.name,
            games: team.games,
            points: Int(team.pointsTotal),
            imagePath: team.imagePath
        )

        let teamsCount = presenter.filteredTeams.count
        if indexPath.row == teamsCount - 1 {
            presenter.needsLoadingMoreItems()
        }

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
