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

    weak var delegate: ShopCompletionVCDelegate?
    var shopItem: ShopItem!

    // MARK: - Outlets

    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var segmentControl: HBSegmentedControl!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var confirmButton: ScalingButton!
    @IBOutlet private weak var stackView: UIStackView!
    @IBOutlet private weak var textFieldView: TitledTextFieldView! {
        didSet {
            textFieldView.addTapGestureRecognizer { self.didPressFieldView() }
            textFieldView.textField.keyboardType = .emailAddress
            textFieldView.textField.textContentType = .emailAddress
        }
    }

    // MARK: - Private Properties

    private let analyticsService: AnalyticsService = ServiceAssembly.shared.analytics
    private let networkService: NetworkServiceProtocol = ServiceAssembly.shared.networkService
    private let webPageRouter: WebPageRouter = WebPageRouterImpl()
    private let errorHapticsGenerator = UINotificationFeedbackGenerator()

    private let personalDataCheckbox: AgreementCheckboxView = {
        let checkbox = AgreementCheckboxView()
        checkbox.checkboxColor = .systemBlue
        return checkbox
    }()

    private let mailingConsentCheckbox: AgreementCheckboxView = {
        let checkbox = AgreementCheckboxView()
        checkbox.checkboxColor = .systemBlue
        return checkbox
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar(barStyle: .transcluent(tintColor: view.backgroundColor))
        configureViews()
        configureCheckboxes()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        errorHapticsGenerator.prepare()
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
    @IBAction
    private func confirmButtonPressed(_ sender: UIButton) {
        guard !segmentControl.items.isEmpty else {
            showErrorDeliveryMethodUnavailable()
            return
        }
        let index = segmentControl.selectedIndex
        let chosenDelivery: DeliveryMethod? = shopItem.isOfflineDeliveryOnly
        ? .game
        : DeliveryMethod(title: segmentControl.items[index])

        guard let deliveryMethod = chosenDelivery else {
            showErrorDeliveryMethodUnavailable()
            return
        }
        guard let text = textFieldView.textField.text, text.isValidEmail else {
            errorHapticsGenerator.notificationOccurred(.error)
            textFieldView.shake()
            return
        }
        guard personalDataCheckbox.isSelected else {
            errorHapticsGenerator.notificationOccurred(.error)
            personalDataCheckbox.showError()
            return
        }
        purchase(withDelivryMethod: deliveryMethod, email: text)
    }

    private func showErrorDeliveryMethodUnavailable() {
        showSimpleAlert(
            title: "Произошла ошибка",
            message: "Выбранная опция получения товара недоступна в данный момент"
        )
    }

    // MARK: - Purchase
    private func purchase(withDelivryMethod method: DeliveryMethod, email: String) {
        guard let itemId = shopItem.productId else {
            self.showSimpleAlert(
                title: "Не удалось завершить покупку",
                message: "Произошла ошибка, но не волнуйтесь, ваши бонусные баллы не были списаны. " +
                "(desc: product id not found)"
            )
            return
        }
        confirmButton.isEnabled = false

        let request = ShopPurchaseRequest(
            productId: itemId,
            deliveryMethod: method.id,
            cityId: AppSettings.defaultCity.id,
            email: email,
            isPersonalDataConsent: personalDataCheckbox.isSelected,
            isMarketingConsent: mailingConsentCheckbox.isSelected
        )

        networkService.post(
            request,
            apiPath: ApiConstants.Path.orderBuy,
            parameters: nil,
            headers: nil,
            authorizationKind: .bearer,
            reponseType: ServerResponse<ShopPurchaseResponse>.self
        ) { [weak self] result in
            guard let self = self else { return }
            self.confirmButton.isEnabled = true

            switch result {
            case let .failure(error):
                self.handleError(error)
            case let .success(response):
                let data = response.data
                if data.description != nil || data.title != nil {

                    self.analyticsService.sendEvent(.spendVirtualCurrency(
                        value: self.shopItem.priceNumber,
                        itemName: self.shopItem.title
                    ))

                    self.showSimpleAlert(
                        title: "Покупка прошла успешно",
                        message: method.message
                    ) { _ in
                        self.delegate?.shopCompletionVC(self, didCompletePurchaseForItem: self.shopItem)
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    self.showSimpleAlert(
                        title: "Не удалось завершить покупку",
                        message: "Произошла ошибка, но не волнуйтесь, ваши бонусные баллы не были списаны. " +
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

    private func configureCheckboxes() {
        personalDataCheckbox.configure(
            text: "Даю согласие на обработку моих персональных данных для целей и на условиях, изложенных в Политике конфиденциальности",
            links: [
                .init(text: "согласие", url: AppSettings.userAgreementUrl),
                .init(text: "Политике конфиденциальности", url: AppSettings.privacyPolicyUrl)
            ]
        )

        mailingConsentCheckbox.configure(
            text: "Даю согласие на получение информационных и рекламных сообщений",
            links: [
                .init(text: "согласие", url: AppSettings.mailingAgreementUrl)
            ]
        )

        personalDataCheckbox.onLinkTap = { [weak self] url in
            self?.webPageRouter.open(url: url)
        }

        mailingConsentCheckbox.onLinkTap = { [weak self] url in
            self?.webPageRouter.open(url: url)
        }

        stackView.addArrangedSubview(personalDataCheckbox)
        stackView.addArrangedSubview(mailingConsentCheckbox)
    }
}

