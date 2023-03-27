//
//  GameOrderVC.swift
//  QuizPlease
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import CoreHaptics

// MARK: - View Protocol
protocol GameOrderViewProtocol: UIViewController, LoadingIndicator {
    var presenter: GameOrderPresenterProtocol! { get set }

    func setTitle(_ title: String)
    func reloadInfo()
    func scrollToSignUp()

    /// Works only if view already contains at least one certificate cell
    func addCertificateCell()
    func removeCertificateCell(at index: Int)

    func editEmail()
    func editPhone()
    func editTeamName()

    func setPrice(_ price: Double)
    func setBackgroundImage(with path: String)
    func endEditing()

    func reloadPaymentInfo()
}

final class GameOrderVC: UIViewController {

    var presenter: GameOrderPresenterProtocol!

    private var imageBaseHeight: CGFloat = 270 {
        didSet {
            gameImageViewHeightConstraint.constant = imageBaseHeight
        }
    }

    private lazy var items: [GameInfoItemKind] = makeItems()

    private(set) lazy var indexOfFirstCertificate: Int? = {
        items.firstIndex(of: .certificate)
    }()

    let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)

    private let activityIndicator = UIActivityIndicatorView()

    @IBOutlet private weak var gameImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var gameImageView: UIImageView!
    @IBOutlet private weak var imageDarkeningView: UIView! {
        didSet {
            imageDarkeningView.alpha = 0.5
        }
    }
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self

            for cellKind in GameInfoItemKind.allCases where cellKind != .addExtraCertificate {
                tableView.register(
                    UINib(nibName: cellKind.identifier, bundle: nil),
                    forCellReuseIdentifier: cellKind.identifier
                )
            }
            tableView.register(
                GameAddExtraCertificateCell.self,
                forCellReuseIdentifier: GameAddExtraCertificateCell.identifier
            )
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar(
            title: "-",
            barStyle: .transcluent(tintColor: view.backgroundColor)
        )
        presenter.viewDidLoad(self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let navC = navigationController as? QPNavigationController {
            navC.fullWidthSwipeBackGestureRecognizer.isEnabled = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let navC = navigationController as? QPNavigationController {
            navC.fullWidthSwipeBackGestureRecognizer.isEnabled = true
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateImageHeight()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    /// Scroll to the top of Register section, after that calls `completion` closure,
    /// where returns a `GameRegisterCell` object (if no errors occured).
    private func scrollToRegistrationCell(animated: Bool = true, completion: ((GameRegisterCell?) -> Void)?) {
        let indexPath = IndexPath(row: GameInfoItemKind.registration.rawValue, section: 0)

        if let cell = tableView.cellForRow(at: indexPath) as? GameRegisterCell {
            tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion?(cell)
            }
        } else {
            completion?(nil)
            print("Invalid cell kind at Register indexPath")
        }
    }

    func indexForPresenter(of cell: GameCertificateCell) -> Int? {
        guard let indexPath = tableView.indexPath(for: cell) else { return nil }
        return indexOfCertificateForPresenter(from: indexPath)
    }

    func indexOfCertificateForPresenter(from indexPath: IndexPath) -> Int? {
        guard let indexOfFirstCertificate = indexOfFirstCertificate else { return nil }
        return indexPath.row - indexOfFirstCertificate
    }

    private func updateImageHeight() {
        if let index = items.firstIndex(of: .info),
           let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? GameInfoCell {
            imageBaseHeight = cell.frame.origin.y + 60
        }
    }

    private func makeItems() -> [GameInfoItemKind] {
        if !(presenter.game.gameStatus?.isRegistrationAvailable ?? false) {
            return [.annotation, .info, .description]
        }

        var _items = GameInfoItemKind.allCases
        let specialConditionsAmount = presenter.specialConditions.count
        if specialConditionsAmount > 1 {
            let specialConditions = Array(repeating: GameInfoItemKind.certificate, count: specialConditionsAmount)
            _items.insert(contentsOf: specialConditions, at: _items.firstIndex(of: .certificate)!)
        } else {
            if specialConditionsAmount != 1 {
                _items.removeAll(where: { $0 == .certificate })
            }
            _items.removeAll { $0 == .addExtraCertificate }
        }
        if presenter.isOnlyCashAvailable || !presenter.isOnlinePaymentDefault {
            _items.removeAll { $0 == .onlinePayment }
        }
        if !presenter.isFirstTimePlaying {
            _items.removeAll { $0 == .promocode }
        }
        return _items
    }
}

// MARK: - GameOrderViewProtocol

extension GameOrderVC: GameOrderViewProtocol {

    func setTitle(_ title: String) {
        prepareNavigationBar(
            title: title,
            barStyle: .transcluent(tintColor: view.backgroundColor)
        )
    }

    func scrollToSignUp() {
        let indexPath = IndexPath(row: GameInfoItemKind.registration.rawValue, section: 0)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }

    func endEditing() {
        view.endEditing(true)
    }

    func reloadInfo() {
        items = makeItems()
        tableView.visibleCells.forEach { ($0 as? GameOrderCellProtocol)?.delegate = nil }
        tableView.reloadData()
        updateImageHeight()
    }

    func startLoading() {
        view.isUserInteractionEnabled = false
        activityIndicator.enableCentered(in: view, color: .systemBlue)
    }

    func stopLoading() {
        view.isUserInteractionEnabled = true
        activityIndicator.stopAnimating()
    }

    func editEmail() {
        scrollToRegistrationCell { $0?.emailFieldView.textField.becomeFirstResponder() }
    }

    func editPhone() {
        scrollToRegistrationCell { cell in
            cell?.phoneFieldView.textField.becomeFirstResponder()
        }
    }

    func editTeamName() {
        scrollToRegistrationCell { cell in
            cell?.teamNameFieldView.textField.becomeFirstResponder()
        }
    }

    func setPrice(_ price: Double) {
        guard let index = items.firstIndex(of: .onlinePayment) else { return }
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? GameOnlinePaymentCell {
            cell.setPrice(price)
        }
    }

    func reloadPaymentInfo() {
        resetPaymentTypes()
        resetSubmitButtonTitle()
        reloadOnlinePaymentSectionIfNeeded()
        updateMaxNumberOfPeopleOnlinePayment()
    }

    private func resetPaymentTypes() {
        guard let index = items.firstIndex(of: .paymentType) else { return }
        let indexPath = IndexPath(row: index, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? GamePaymentTypeCell {
            cell.setPaymentTypes()
        }
    }

    private func resetSubmitButtonTitle() {
        if let index = items.firstIndex(of: .submit),
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? GameSubmitButtonCell {
            cell.resetButtonTitle()
        }
    }

    private func updateMaxNumberOfPeopleOnlinePayment() {
        guard
            let index = items.firstIndex(where: { $0 == .onlinePayment }),
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? GameOnlinePaymentCell
        else {
            return
        }
        cell.updateMaxNumberOfPeople(presenter.numberOfPeople)
    }

    private func reloadOnlinePaymentSectionIfNeeded() {
        let isOnlinePayment = presenter.selectedPaymentType == .online

        if isOnlinePayment && !presenter.isOnlyCashAvailable {
            guard let i = items.firstIndex(of: .paymentType), i+1 < items.count,
                  items[i+1] != .onlinePayment
            else { return }
            let index = i + 1

            items.insert(.onlinePayment, at: index)
            tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .fade)

        } else {
            guard let index = items.firstIndex(of: .onlinePayment) else { return }
            items.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        }
    }

    func setBackgroundImage(with path: String) {
        let placeholder = gameImageView.image
        gameImageView.loadImage(
            path: path,
            placeholderImage: placeholder
        ) { [weak self] image in
            guard let self = self else { return }
            if image == nil {
                self.gameImageView.loadImage(using: .prod, path: path, placeholderImage: placeholder)
            }
        }
    }

    func addCertificateCell() {
        guard let index = items.lastIndex(of: .certificate) else { return }
        let newIndex = index + 1
        items.insert(.certificate, at: newIndex)
        tableView.insertRows(at: [IndexPath(row: newIndex, section: 0)], with: .fade)
        updateUiOnCertificateTextChange(newCode: nil)
    }

    func removeCertificateCell(at indexForPresenter: Int) {
        guard let indexOfFirstCertificate = indexOfFirstCertificate else { return }
        let newIndex = indexOfFirstCertificate + indexForPresenter
        let indexPath = IndexPath(row: newIndex, section: 0)
        removeCertificateCell(at: indexPath)
    }

    private func removeCertificateCell(at indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)

        // Also remove 'add' button if the only one certificate cell is left
        updateUiOnCertificateTextChange(newCode: presenter.specialConditions.first?.value ?? "")
    }

    func updateUiOnCertificateTextChange(newCode: String?) {
        let newCode = newCode ?? ""
        let certificatesCount = items
            .filter { $0 == .certificate }
            .count
        let isCertLimitReached = certificatesCount == presenter.maximumSpecialConditionsAmount

        if (newCode.isEmpty && certificatesCount == 1 || isCertLimitReached),
           let index = items.firstIndex(of: .addExtraCertificate) {

            items.remove(at: index)
            tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
            return
        }

        if !(newCode.isEmpty || isCertLimitReached),
           items.firstIndex(of: .addExtraCertificate) == nil,
           let index = items.lastIndex(of: .certificate) {

            let buttonIndex = index + 1
            items.insert(.addExtraCertificate, at: buttonIndex)
            tableView.insertRows(at: [IndexPath(row: buttonIndex, section: 0)], with: .fade)
        }
    }
}

// MARK: - Data Source & Delegate

extension GameOrderVC: UITableViewDataSource, UITableViewDelegate {

    func tableView(
        _ tableView: UITableView,
        numberOfRowsInSection section: Int
    ) -> Int {
        return items.count
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {
        let kind = items[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: kind.identifier,
            for: indexPath
        ) as? GameOrderCellProtocol else {
            fatalError("❌ Invalid Cell Kind!")
        }

        if let cell = cell as? GameCertificateCell {
            cell.associatedItemKind = kind
            if let index = indexOfCertificateForPresenter(from: indexPath) {
                cell.fieldView.textField.text = presenter.specialConditions[index].value
            }
        }

        if (cell.delegate as? GameOrderVC) == nil {
            cell.delegate = self
        }

        return cell
    }

    func tableView(
        _ tableView: UITableView,
        willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        cell.layoutIfNeeded()
    }

    func tableView(
        _ tableView: UITableView,
        canEditRowAt indexPath: IndexPath
    ) -> Bool {
        items[indexPath.row] == .certificate && presenter.specialConditions.count > 1
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: nil,
            handler: { [weak self] _, _, completion in
                guard let self = self else { return }
                if let firstIndex = self.indexOfFirstCertificate {
                    let cellIndexForPresenter = indexPath.row - firstIndex
                    self.presenter.didPressDeleteSpecialCondition(at: cellIndexForPresenter)
                }
                completion(true)
            }
        )
        deleteAction.backgroundColor = .systemGray5Adapted
        if #available(iOS 13.0, *) {
            deleteAction.image = UIImage(systemName: "trash.circle.fill")
        } else {
            deleteAction.title = "Удалить"
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - UIScrollViewDelegate

extension GameOrderVC: UIScrollViewDelegate {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView.isKind(of: UITableView.self) else { return }

        let offset = scrollView.contentOffset.y + scrollView.safeAreaInsets.top

        gameImageView.isHidden = offset > 700
        imageDarkeningView.isHidden = offset > 700

        if offset <= 0 {
            gameImageViewHeightConstraint.constant = imageBaseHeight - offset
        } else {
            gameImageViewHeightConstraint.constant = imageBaseHeight - offset * 0.2
        }
    }
}
