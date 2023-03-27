//
// MARK: ScheduleVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

/// View protocol for Schedule
protocol ScheduleViewProtocol: UIViewController, LoadingIndicator {
    var presenter: SchedulePresenterProtocol! { get set }

    func reloadScheduleList()
    func reloadGame(at index: Int)

    func showNoGamesInSchedule(text: String, links: [TextLink])

    func configure()

    func changeSubscribeStatus(forGameAt index: Int)

    /// Set screen title
    func setTitle(_ title: String)
}

/// Schedule view controller
final class ScheduleVC: UIViewController {

    var presenter: SchedulePresenterProtocol!
    var detectLinks: ((NSRange) -> Void)?

    // MARK: - UI Elements

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var noGamesView: UIView! {
        didSet { noGamesView.isHidden = true }
    }
    @IBOutlet private weak var noGamesTextView: UITextView!

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar(barStyle: .transcluent(tintColor: view.backgroundColor))
        ScheduleConfigurator().configure(self)
        presenter.viewDidLoad(self)

        if #available(iOS 14.0, *) {
            navigationItem.backBarButtonItem?.menu = nil
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }

    // MARK: - Actions

    @IBAction func filtersButtonPressed(_ sender: Any) {
        presenter.didPressFilterButton()
    }

    @IBAction func remindButtonPressed(_ sender: Any) {
        presenter.didPressScheduleRemindButton()
    }

    @objc private func refreshControlTriggered() {
        presenter.handleRefreshControl()
    }

    // MARK: - Private Methods

    private func addTapRecognizerToTextView() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTextTap(_:)))
        noGamesTextView.addGestureRecognizer(tapRecognizer)
    }

    private func configureNoGamesText(text: String, links: [TextLink]) {
        let nsString = text as NSString
        let wholeRange = nsString.range(of: text)
        let attrString = NSMutableAttributedString(string: text)
        let font: UIFont = .gilroy(.semibold, size: 22)
        attrString.addAttributes([
                .font: font,
                .foregroundColor: UIColor.lightGray
            ],
            range: wholeRange
        )

        for link in links {
            let rangeOfLink = nsString.range(of: link.text)
            attrString.addAttributes([.foregroundColor: UIColor.themePurple], range: rangeOfLink)
        }

        noGamesTextView.attributedText = attrString
        noGamesTextView.textAlignment = .center

        detectLinks = { rangeOfTap in
            for link in links {
                let rangeOfLink = nsString.range(of: link.text)
                if rangeOfTap.intersection(rangeOfLink) != nil {
                    link.action()
                    break
                }
            }
        }
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

        let rangeOfTap = NSRange(location: characterIndex, length: 1)
        detectLinks?(rangeOfTap)
    }
}

// MARK: - ScheduleViewProtocol

extension ScheduleVC: ScheduleViewProtocol {
    func reloadScheduleList() {
        noGamesView.isHidden = true
        tableView.reloadData()
    }

    func reloadGame(at index: Int) {
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? ScheduleGameCell {
            cell.fill(viewModel: presenter.viewModel(forGameAt: index))
        }
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
        tableView.dataSource = self
        tableView.refreshControl = UIRefreshControl(
            tintColor: .systemBlue,
            target: self,
            action: #selector(refreshControlTriggered)
        )
        addTapRecognizerToTextView()
    }

    func showNoGamesInSchedule(text: String, links: [TextLink]) {
        configureNoGamesText(text: text, links: links)
        noGamesView.isHidden = false
    }

    func changeSubscribeStatus(forGameAt index: Int) {
        tableView.reloadRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }

    func setTitle(_ title: String) {
        UIView.animate(withDuration: 0.1) {
            self.navigationItem.titleView?.alpha = 0
        } completion: { _ in
            self.navigationItem.titleView = TitleLabel(title: title)
            UIView.animate(withDuration: 0.1) {
                self.navigationItem.titleView?.alpha = 1
            }
        }
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

// MARK: - UITableViewDataSource

extension ScheduleVC: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        presenter.gamesCount
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ScheduleGameCell.self, for: indexPath)

        let viewModel = presenter.viewModel(forGameAt: indexPath.row)
        cell.delegate = self
        cell.fill(viewModel: viewModel)
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
