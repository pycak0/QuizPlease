//
//  ShopCompletionVC.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol ShopCompletionVCDelegate: class {
    func shopCompletionVC(_ vc: ShopCompletionVC, didCompletePurchaseForItem shopItem: ShopItem)
}

class ShopCompletionVC: UIViewController {
    
    //MARK:- Segment Kind
    enum SegmentKind: Int, CaseIterable, Encodable {
        case email, game
        
        var title: String {
            switch self {
            case .email:
                return "Получить на e-mail"
            case .game:
                return "Забрать на игре"
            }
        }
    }
    
    //MARK:- Outlets
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textFieldView: TitledTextFieldView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var segmentControl: HBSegmentedControl!
    
    weak var delegate: ShopCompletionVCDelegate?
    
    var shopItem: ShopItem!
    //var selectedGame: PassedGame?
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        configureViews()
    }
    
    //MARK:- Segment Changed
    @objc
    private func segmentChanged() {
        view.endEditing(true)
//        guard let deliveryType = SegmentKind(rawValue: segmentControl.selectedIndex) else { return }
//        var title = "Электронная почта"
//        var placeholder = "Введите адрес почты"
//        if deliveryType == .game {
//            title = "Забрать на игре"
//            placeholder = "Выберите игру"
//        }
//        textFieldView.title = title
//        textFieldView.placeholder = placeholder
//        textFieldView.textField.isEnabled = segmentControl.selectedIndex == 0
//        arrowImageView.isHidden = segmentControl.selectedIndex == 0
//        textFieldView.textField.text = ""
    }
    
    //MARK:- Did Press Field View
    @objc
    private func didPressFieldView() {
        guard !textFieldView.textField.isEnabled else { return }
        //gamesArray = [...]
        showChooseItemActionSheet(itemNames: ["game1", "game2"]) { [unowned self] (selectedName, selectedIndex) in
            self.textFieldView.textField.text = selectedName
            //self.selectedGame = gamesArray[selectedIndex]
        }
    }
    
    //MARK:- Confirm Button Pressed
    @IBAction func confirmButtonPressed(_ sender: Any) {
        guard let selectedSegmentKind = SegmentKind(rawValue: segmentControl.selectedIndex) else { return }
        guard let text = textFieldView.textField.text, text.isValidEmail else {
            textFieldView.shakeAnimation()
            return
        }
        let deliveryMethod: DeliveryMethod = selectedSegmentKind == .email ? .online : .game
        purchase(withDelivryMethod: deliveryMethod, email: text)
    }
    
    //MARK:- Purchase
    private func purchase(withDelivryMethod method: DeliveryMethod, email: String) {
        guard let itemId = shopItem.id else {
            self.showSimpleAlert(title: "Не удалось завершить покупку", message: "Произошла ошибка, но не волнуйтесь, Ваши бонусные баллы не были списаны. (desc: product id not found)")
            return
        }
        //let isSuccess = false
        NetworkService.shared.purchaseProduct(with: "\(itemId)", deliveryMethod: method, email: email) {  (isSuccess) in
            if isSuccess {
                self.showSimpleAlert(title: "Покупка прошла успешно",
                                     message: method.message, okButtonTitle: "Завершить") { okAction in
                    self.delegate?.shopCompletionVC(self, didCompletePurchaseForItem: self.shopItem)
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.showSimpleAlert(title: "Не удалось завершить покупку", message: "Произошла ошибка, но не волнуйтесь, Ваши бонусные баллы не были списаны. Можете попробовать подтвердить заказ ещё раз")
            }
        }
    }
    
    private func configureViews() {
        imageView.loadImage(path: shopItem.imagePath, placeholderImage: .logoColoredImage)
        configureSegmentControl()
        configureTextField()
    }
    
    private func configureSegmentControl() {
        segmentControl.items = SegmentKind.allCases.map { $0.title }
        segmentControl.dampingRatio = 0.9
        segmentControl.font = UIFont(name: "Gilroy-Bold", size: 16)
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    private func configureTextField() {
        textFieldView.addTapGestureRecognizer {
            self.didPressFieldView()
        }
        textFieldView.textField.keyboardType = .emailAddress
        textFieldView.textField.textContentType = .emailAddress
    }
     
}
