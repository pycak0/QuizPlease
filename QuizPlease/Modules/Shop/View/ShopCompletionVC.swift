//
//  ShopCompletionVC.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol ShopCompletionVCDelegate: AnyObject {
    func shopCompletionVC(_ vc: ShopCompletionVC, didCompletePurchaseForItem shopItem: ShopItem)
}

final class ShopCompletionVC: UIViewController {

    // MARK: - Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var segmentControl: HBSegmentedControl!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var textFieldView: TitledTextFieldView! {
        didSet {
            textFieldView.addTapGestureRecognizer { self.didPressFieldView() }
            textFieldView.textField.keyboardType = .emailAddress
            textFieldView.textField.textContentType = .emailAddress
        }
    }

    weak var delegate: ShopCompletionVCDelegate?

    var shopItem: ShopItem!
    // var selectedGame: PassedGame?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar(barStyle: .transcluent(tintColor: view.backgroundColor))
        configureViews()
    }

    // MARK: - Segment Changed
    @objc
    private func segmentChanged() {
        view.endEditing(true)
    }

    // MARK: - Did Press Field View
    @objc
    private func didPressFieldView() {
        guard !textFieldView.textField.isEnabled else { return }
        // gamesArray = [...]
        showChooseItemActionSheet(itemNames: ["game1", "game2"]) { [unowned self] (selectedName, _) in
            self.textFieldView.textField.text = selectedName
            // self.selectedGame = gamesArray[selectedIndex]
        }
    }

    // MARK: - Confirm Button Pressed
    @IBAction func confirmButtonPressed(_ sender: Any) {
        let index = segmentControl.selectedIndex
        let chosenDelivery: DeliveryMethod? = shopItem.isOfflineDeliveryOnly
        ? .game
        : DeliveryMethod(title: segmentControl.items[index])

        guard let deliveryMethod = chosenDelivery else {
            showSimpleAlert(
                title: "Произошла ошибка",
                message: "Выбранная опция получения товара недоступна в данный момент"
            )
            return
        }
        guard let text = textFieldView.textField.text, text.isValidEmail else {
            textFieldView.shake()
            return
        }
        purchase(withDelivryMethod: deliveryMethod, email: text)
    }

    // MARK: - Purchase
    private func purchase(withDelivryMethod method: DeliveryMethod, email: String) {
        guard let itemId = shopItem.id else {
            self.showSimpleAlert(
                title: "Не удалось завершить покупку",
                message: "Произошла ошибка, но не волнуйтесь, Ваши бонусные баллы не были списаны. " +
                "(desc: product id not found)"
            )
            return
        }
        NetworkService.shared.purchaseProduct(
            with: "\(itemId)",
            deliveryMethod: method,
            email: email
        ) { [weak self] (result) in
            guard let self = self else { return }

            switch result {
            case let .failure(error):
                self.handleError(error)
            case let .success(response):
                if response.message == "ok" {
                    self.showSimpleAlert(
                        title: "Покупка прошла успешно",
                        message: method.message,
                        okButtonTitle: "OK"
                    ) { _ in
                        self.delegate?.shopCompletionVC(self, didCompletePurchaseForItem: self.shopItem)
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self.showSimpleAlert(
                        title: "Не удалось завершить покупку",
                        message: "Произошла ошибка, но не волнуйтесь, Ваши бонусные баллы не были списаны. " +
                        "Можете попробовать подтвердить заказ ещё раз"
                    )
                }
            }
        }
    }

    private func handleError(_ error: NetworkServiceError) {
        print(error)
        switch error {
        case .invalidToken:
            showNeedsAuthAlert(title: "Для совершения покупок необходимо авторизоваться")
        default:
            showErrorConnectingToServerAlert()
        }
    }

    private func configureViews() {
        imageView.loadImage(path: shopItem.imagePath, placeholderImage: .logoColoredImage)
        if shopItem.isOfflineDeliveryOnly {
            segmentControl.isHidden = true
            questionLabel.numberOfLines = 0
            questionLabel.text = "Мы доставим этот ништяк на вашу следующую игру! " +
            "Наш менеджер свяжется с вами после подтверждения заказа."
        } else {
            configureSegmentControl()
        }
    }

    private func configureSegmentControl() {
        segmentControl.items = shopItem.availableDeliveryMethods.map { $0.title }
        segmentControl.dampingRatio = 0.9
        segmentControl.font = .gilroy(.bold, size: 16)
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
}
