//
//  ConfirmVC.swift
//  QuizPlease
//
//  Created by Владислав on 20.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import BottomPopup

protocol ConfirmVCDelegate: class {
    func didAgreeToPurchase(item: ShopItem)
}

class ConfirmVC: BottomPopupViewController {
    let duration = 0.2
    
    override var popupTopCornerRadius: CGFloat { 30 }
    override var popupHeight: CGFloat { 530 }
    override var popupDismissDuration: Double { duration }
    override var popupPresentDuration: Double { duration }
    //override var popupShouldBeganDismiss: Bool { false }
    
    weak var delegate: ConfirmVCDelegate?
    
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var confirmMessageLabel: UILabel!
    @IBOutlet private weak var cancelButton: ScalingButton!
    @IBOutlet private weak var confirmButton: ScalingButton!
    
    var shopItem: ShopItem!

    override func viewDidLoad() {
        super.viewDidLoad()

        configureViews()
        setupData()
    }
    
    private func configureViews() {
        cancelButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        let radius: CGFloat = 20
        cancelButton.layer.cornerRadius = radius
        confirmButton.layer.cornerRadius = radius
        
        view.blurView.setupPopupBlur()
        
    }
    
    private func setupData() {
        itemImageView.image = shopItem.image
        descriptionLabel.text = shopItem.description
        
        let formattedPrice = shopItem.price.string(withAssociatedMaleWord: "балл")
        confirmMessageLabel.text = "Потратить \(formattedPrice) баллов на электронный сертификат?"
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        delegate?.didAgreeToPurchase(item: shopItem)
        dismiss(animated: true, completion: nil)
    }
}
