//
// MARK: ProfileVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// MARK: - View Protocol

protocol ProfileViewProtocol: UIViewController {

    var presenter: ProfilePresenterProtocol! { get set }
    func configure()
    func reloadGames()
    func updateUserInfo(with pointsScored: Double)
    func setCity(_ city: String)

    func showExitOrDeleteActionSheet(
        onExit: @escaping () -> Void,
        onDelete: @escaping () -> Void
    )

    func showDeleteAccountAlert(onConfirm: @escaping () -> Void)
    func showExitAlert(onConfirm: @escaping () -> Void)
}

final class ProfileVC: UIViewController {

    var presenter: ProfilePresenterProtocol!

    // MARK: - Private Properties

    // `addGameButton` fading helpers
    private var lastOffset: CGFloat = 0
    private var startOffset: CGFloat?

    private let pointsFormatter: NumberFormatterProtocol = PointsDecorator(
        baseFormatter: NumberFormatter.decimalGroupingFormatter
    )

    // MARK: - UI Elements

    private let tableFooter = UIView()

    @IBOutlet private weak var infoHeader: UIView!
    @IBOutlet private weak var gamesCountLabel: UILabel!
    @IBOutlet private weak var totalPointsScoredLabel: UILabel!
    @IBOutlet private weak var showShopButton: UIButton!
    @IBOutlet private weak var addGameButton: ScalingButton!
    @IBOutlet private weak var exitButton: UIBarButtonItem!
    @IBOutlet private weak var cityLabel: UILabel!
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self
            tableView.tableFooterView = tableFooter
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar(barStyle: .transcluent(tintColor: view.backgroundColor))
        presenter.viewDidLoad(self)
        configureBarItem()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.handleViewDidAppear()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        resetGradient()
        tableFooter.frame.setHeight(addGameButton.frame.height + view.safeAreaInsets.bottom)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }

    // MARK: - Private Methods

    @IBAction private func shopButtonPressed(_ sender: UIButton) {
        // sender.scaleOut()
        presenter.didPressShowShopButton()
    }

    @IBAction private func addGameButtonPressed(_ sender: UIButton) {
        sender.scaleOut()
        presenter.didPressAddGameButton()
    }

    @IBAction private func exitButtonPressed(_ sender: Any) {
        presenter.didPressOptionsButton()
    }

    private func configureBarItem() {
        let item = UIBarButtonItem(
            image: UIImage(named: "menu"),
            style: .plain,
            target: self,
            action: #selector(exitButtonPressed(_:))
        )
        item.tintColor = .labelAdapted

        navigationItem.rightBarButtonItem = item
    }

    private func resetGradient() {
        infoHeader.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        let infoGradFrame = CGRect(
            x: 0, y: 0,
            width: view.bounds.width,
            height: infoHeader.bounds.height
        )
        infoHeader.addGradient(colors: [.lemon, .lightOrange], frame: infoGradFrame, insertAt: 0)
        infoHeader.clipsToBounds = false

        addGameButton.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        addGameButton.addGradient(colors: [.lemon, .lightOrange], insertAt: 0)
    }
}

// MARK: - ProfileViewProtocol

extension ProfileVC: ProfileViewProtocol {

    func configure() {
        totalPointsScoredLabel.layer.cornerRadius = totalPointsScoredLabel.bounds.height / 2
        showShopButton.layer.cornerRadius = showShopButton.bounds.height / 2
        addGameButton.layer.cornerRadius = 20
    }

    func reloadGames() {
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }

    func updateUserInfo(with pointsScored: Double) {
        let gamesCount = presenter.userInfo?.games?.count ?? 0
        totalPointsScoredLabel.text = pointsFormatter.string(from: pointsScored as NSNumber)
        let gamesFormattedCount = gamesCount.string(withAssociatedFirstCaseWord: "игра", changingCase: .genitive)
        gamesCountLabel.text = "Вы сходили на \(gamesFormattedCount) и накопили"
    }

    func setCity(_ city: String) {
        cityLabel.text = "Игры, на кототрых вы зажигали в городе: \(city)"
    }

    func showExitOrDeleteActionSheet(onExit: @escaping () -> Void, onDelete: @escaping () -> Void) {
        showActionSheetWithOptions(title: nil, buttons: [
            UIAlertAction(
                title: "Выйти из личного кабинета",
                style: .default,
                handler: { _ in onExit() }
            ),
            UIAlertAction(
                title: "Удалить аккаунт",
                style: .default,
                handler: { _ in onDelete() }
            )
        ])
    }

    func showDeleteAccountAlert(onConfirm: @escaping () -> Void) {
        UIAlertController(
            title: "Удалить аккаунт?",
            message: "Ваши баллы и игры, на которых вы были, будут удалены",
            preferredStyle: .alert
        )
        .withAction(.delete(onTap: onConfirm))
        .withAction(.cancel)
        .show()
    }

    func showExitAlert(onConfirm: @escaping () -> Void) {
        UIAlertController(
            title: "Вы уверены, что хотите выйти из личного кабинета?",
            message: nil,
            preferredStyle: .alert
        )
        .withAction(title: "Да", handler: onConfirm)
        .withAction(.cancel)
        .show()
    }
}

// MARK: - QRScannerVCDelegate

extension ProfileVC: QRScannerVCDelegate {
    func qrScanner(_ qrScanner: QRScannerVC, didFinishCodeScanningWith result: String?) {
        guard let code = result else { return }
        presenter.didScanQrCode(with: code)
    }
}

// MARK: - AddGameVCDelegate

extension ProfileVC: AddGameVCDelegate {
    func didAddGameToUserProfile(_ vc: AddGameVC) {
        presenter.didAddNewGame()
    }
}

// MARK: - Data Source & Delegate

extension ProfileVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.userInfo?.games?.count ?? 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let games = presenter.userInfo?.games, !games.isEmpty else {
            let cell = tableView.dequeueReusableCell(ProfileSampleCell.self, for: indexPath)
            let description = "Тут появляются игры, на которых вы зажигали! " +
            "Чтобы добавить игру, жмите на кнопку Добавить игру и сканируйте qr-код"

            cell.configure(with: description)
            return cell
        }

        let cell = tableView.dequeueReusableCell(ProfileCell.self, for: indexPath)
        let game = games[indexPath.row]
        let pointsText = game.points.map { pointsFormatter.string(from: $0 as NSNumber) ?? "" }
        cell.configure(
            gameName: game.title,
            gameNumber: game.gameNumber,
            teamName: "",
            place: game.place,
            pointsScoredText: pointsText
        )
        return cell
    }
}

// MARK: - UIScrollViewDelegate

extension ProfileVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentOffset = scrollView.contentOffset.y + scrollView.safeAreaInsets.top
        let isScrollingDown = currentOffset > lastOffset

        if isScrollingDown && currentOffset > 10 {
            if startOffset == nil {
                startOffset = currentOffset
            }
            let translation = currentOffset - startOffset!
            let alpha: CGFloat = max(0, (100 - currentOffset + startOffset!) / 100)
            if addGameButton.alpha > 0 {
                addGameButton.alpha = alpha
                addGameButton.transform = CGAffineTransform(translationX: 0, y: translation)
            }
        } else {
            UIView.animate(withDuration: 0.15) {
                self.addGameButton.alpha = 1
                self.addGameButton.transform = .identity
            }
            startOffset = nil
        }

        lastOffset = currentOffset
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate, addGameButton.alpha != 0 && addGameButton.alpha != 1 else { return }

        let transform = addGameButton.alpha >= 0.5
            ? CGAffineTransform.identity
            : CGAffineTransform(translationX: 0, y: 100)
        let alpha = addGameButton.alpha.rounded()
        startOffset = alpha == 1 ? nil : startOffset

        UIView.animate(withDuration: 0.2) {
            self.addGameButton.transform = transform
            self.addGameButton.alpha = alpha
        }
    }
}
