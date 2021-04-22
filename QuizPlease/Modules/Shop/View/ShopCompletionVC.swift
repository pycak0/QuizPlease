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
    
    //MARK:- Outlets
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var textFieldView: TitledTextFieldView!
    @IBOutlet private weak var arrowImageView: UIImageView!
    @IBOutlet private weak var segmentControl: HBSegmentedControl!
    
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
        let index = segmentControl.selectedIndex
        guard let deliveryMethod = DeliveryMethod(title: segmentControl.items[index]) else { return }
        guard let text = textFieldView.textField.text, text.isValidEmail else {
            textFieldView.shakeAnimation()
            return
        }
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
        segmentControl.items = shopItem.availableDeliveryMethods.map { $0.title }
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
