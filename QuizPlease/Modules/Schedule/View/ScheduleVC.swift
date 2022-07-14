//
// MARK: ScheduleVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol ScheduleViewProtocol: UIViewController, LoadingIndicator {
    var presenter: SchedulePresenterProtocol! { get set }

    func reloadScheduleList()
    func reloadGame(at index: Int)
    func showNoGamesScheduled()

    func configure()

    func changeSubscribeStatus(forGameAt index: Int)
}

class ScheduleVC: UIViewController {
    var presenter: SchedulePresenterProtocol!

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noGamesView: UIView!
    @IBOutlet private weak var noGamesTextView: UITextView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        ScheduleConfigurator().configure(self)
        presenter.viewDidLoad(self)

        if #available(iOS 14.0, *) {
            navigationItem.backBarButtonItem?.menu = nil
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }

    @IBAction func filtersButtonPressed(_ sender: Any) {
        presenter.didPressFilterButton()
    }

    @IBAction func remindButtonPressed(_ sender: Any) {
        presenter.didPressScheduleRemindButton()
    }

    @objc private func refreshControlTriggered() {
        presenter.handleRefreshControl()
    }

    // MARK: - Configure Text
    private func configureNoGamesText() {
        let text = noGamesTextView.text ?? ""
        let nsString = text as NSString

        let wholeRange = nsString.range(of: text)
        let homeGameRange = nsString.range(of: "игры Хоум")
        let warmupRange = nsString.range(of: "размяться")

        let attrString = NSMutableAttributedString(string: text)
        let font: UIFont = .gilroy(.semibold, size: 22)
        attrString.addAttributes([
                .font: font,
                .foregroundColor: UIColor.lightGray
            ],
            range: wholeRange
        )
        attrString.addAttributes([.foregroundColor: UIColor.themePurple], range: homeGameRange)
        attrString.addAttributes([.foregroundColor: UIColor.themePurple], range: warmupRange)

        noGamesTextView.attributedText = attrString
        noGamesTextView.textAlignment = .center
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTextTap(_:)))
        noGamesTextView.addGestureRecognizer(tapRecognizer)
    }

    // MARK: - Handle Tap on Text
    @objc private func handleTextTap(_ sender: UITapGestureRecognizer) {
        guard let textView = sender.view as? UITextView else { return }
        let layoutManager = textView.layoutManager

        // location of tap in textView coordinates and taking the inset into account
        var location = sender.location(in: textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top

        // character index at tap location
        let characterIndex = layoutManager.characterIndex(
            for: location,
            in: textView.textContainer,
            fractionOfDistanceBetweenInsertionPoints: nil
        )

        guard characterIndex > 0, characterIndex < textView.textStorage.length else { return }

        let detectedRange = NSRange(location: characterIndex, length: 1)

        let nsString = textView.attributedText.string as NSString
        let homeGameRange = nsString.range(of: "игры Хоум")
        let warmupRange = nsString.range(of: "размяться")

        if homeGameRange.intersection(detectedRange) != nil {
            presenter.homeGameAction()
        } else if warmupRange.intersection(detectedRange) != nil {
            presenter.warmupAction()
        }
    }
}

// MARK: - View Protocol
extension ScheduleVC: ScheduleViewProtocol {
    func reloadScheduleList() {
        noGamesView.isHidden = true
        tableView.reloadData()
    }

    func reloadGame(at index: Int) {
//        tableView.isHidden = false
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ScheduleGameCell {
            let game = presenter.games[index]
            cell.fill(model: game, isSubscribed: presenter.isSubscribedOnGame(with: game.id))
        }
//        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .none)
    }

    func stopLoading() {
        if tableView.refreshControl?.isRefreshing ?? false {
            tableView.refreshControl?.endRefreshing()
        }
    }

    func startLoading() {
        tableView.refreshControl?.beginRefreshing()
    }

    func configure() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl(
            tintColor: .systemBlue,
            target: self,
            action: #selector(refreshControlTriggered)
        )
        configureNoGamesText()
    }

    func showNoGamesScheduled() {
        noGamesView.isHidden = false
    }

    func changeSubscribeStatus(forGameAt index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
}

// MARK: - FiltersVCDelegate
extension ScheduleVC: FiltersVCDelegate {
    func didChangeFilter(_ newFilter: ScheduleFilter) {
        presenter.didChangeScheduleFilter(newFilter: newFilter)
    }

    func didEndEditingFilters() {
        //
    }
}

// MARK: - Data Source & Delegate
extension ScheduleVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.games.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ScheduleGameCell.identifier,
            for: indexPath
        ) as? ScheduleGameCell else {
            fatalError("❌ Invalid cell kind!")
        }

        let game = presenter.games[indexPath.row]
        cell.delegate = self
        cell.fill(model: game, isSubscribed: presenter.isSubscribedOnGame(with: game.id))
        presenter.updateDetailInfoIfNeeded(at: indexPath.row)

        return cell
    }

}

// MARK: - ScheduleGameCellDelegate
extension ScheduleVC: ScheduleGameCellDelegate {

    func signUpButtonPressed(in cell: ScheduleGameCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.didSignUp(forGameAt: indexPath.row)
    }

    func infoButtonPressed(in cell: ScheduleGameCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.didPressInfoButton(forGameAt: indexPath.row)
    }

    func locationButtonPressed(in cell: ScheduleGameCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.didAskLocation(forGameAt: indexPath.row)
    }

    func remindButtonPressed(in cell: ScheduleGameCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.didAskNotification(forGameAt: indexPath.row)
    }

    func gameNumberPressed(in cell: ScheduleGameCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.didPressInfoButton(forGameAt: indexPath.row)
    }

    func gameNamePressed(in cell: ScheduleGameCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        presenter.didPressInfoButton(forGameAt: indexPath.row)
    }
}
