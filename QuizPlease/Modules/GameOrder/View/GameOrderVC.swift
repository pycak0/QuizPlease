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

    var shouldScrollToSignUp: Bool! { get set }

    func reloadInfo()
    func configureTableView()

    ///Works only if view already contains at least one certificate cell
    func addCertificateCell()
    func removeCertificateCell(at index: Int)

    func editEmail()
    func editPhone()

    func setPrice(_ price: Double)
    func setBackgroundImage(with path: String)
    func endEditing()
}

class GameOrderVC: UIViewController {
    var presenter: GameOrderPresenterProtocol!

    var shouldScrollToSignUp: Bool!

    lazy var items: [GameInfoItemKind] = {
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
        if !presenter.registerForm.isFirstTime {
            _items.removeAll { $0 == .promocode }
        }
        return _items
    }()

    private(set) lazy var indexOfFirstCertificate: Int? = {
        items.firstIndex(of: .certificate)
    }()

    let hapticGenerator = UIImpactFeedbackGenerator(style: .medium)

    private let activityIndicator = UIActivityIndicatorView()

    @IBOutlet private weak var gameImageView: UIImageView!
    @IBOutlet private weak var imageDarkeningView: UIView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.delegate = self
            tableView.dataSource = self

            for cellKind in GameInfoItemKind.allCases where cellKind != .addExtraCertificate {
                tableView.register(UINib(nibName: cellKind.identifier, bundle: nil), forCellReuseIdentifier: cellKind.identifier)
            }
            tableView.register(GameAddExtraCertificateCell.self, forCellReuseIdentifier: GameAddExtraCertificateCell.identifier)
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.configureViews()
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

    func scrollToSignUp() {
        let indexPath = IndexPath(row: GameInfoItemKind.registration.rawValue, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }

    ///Scroll to the top of Register section, after that calls `completion` closure where returns a `GameRegisterCell` object (if no errors occured)
    func scrollToRegistrationCell(animated: Bool = true, completion: ((GameRegisterCell?) -> Void)?) {
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
}

// MARK: - GameOrderViewProtocol

extension GameOrderVC: GameOrderViewProtocol {
    func endEditing() {
        view.endEditing(true)
    }

    func reloadInfo() {
        tableView.reloadData()
    }

    func configureTableView() {
        if shouldScrollToSignUp {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.scrollToSignUp()
            }
        }
    }

    func startLoading() {
        activityIndicator.enableCentered(in: view, color: .systemBlue)
    }

    func stopLoading() {
        activityIndicator.stopAnimating()
    }

    func editEmail() {
        scrollToRegistrationCell { $0?.emailFieldView.textField.becomeFirstResponder() }
    }

    func editPhone() {
        scrollToRegistrationCell { (cell) in
            cell?.phoneFieldView.textField.becomeFirstResponder()
        }
    }

    func setPrice(_ price: Double) {
        guard let index = items.firstIndex(of: .onlinePayment) else { return }
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? GameOnlinePaymentCell {
            cell.setPrice(price)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //createCell(tableView, at: indexPath)

        let kind = items[indexPath.row]
        //guard let kind = GameInfoItemKind(rawValue: index) else { fatalError("Invalid Game Item Kind") }
        let cell = tableView.dequeueReusableCell(withIdentifier: kind.identifier, for: indexPath) as! GameOrderCellProtocol

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

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        items[indexPath.row] == .certificate && presenter.specialConditions.count > 1
    }

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(
            style: .destructive,
            title: nil,
            handler: { [weak self] action, view, completion in
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
        let offset = scrollView.contentOffset.y + scrollView.safeAreaInsets.top

        gameImageView.isHidden = offset > 700
        imageDarkeningView.isHidden = offset > 700

        guard offset < 0, scrollView.isKind(of: UITableView.self) else {
            gameImageView.transform = .identity
            imageDarkeningView.transform = .identity
            return
        }
        let scale = (1 + abs(offset) / 300)
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        gameImageView.transform = transform
        imageDarkeningView.transform = transform
    }
}
