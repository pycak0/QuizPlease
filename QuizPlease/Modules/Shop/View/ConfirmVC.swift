//
//  ConfirmVC.swift
//  QuizPlease
//
//  Created by Владислав on 20.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import BottomPopup

class ConfirmVC: BottomPopupViewController {
    let duration = 0.2
    
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var confirmMessageLabel: UILabel!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet private weak var confirmButton: UIButton!
    
    var shopItem: ShopItem!
    
    override var popupTopCornerRadius: CGFloat { 30 }
    override var popupHeight: CGFloat { 530 }
    override var popupDismissDuration: Double { duration }
    override var popupPresentDuration: Double { duration }
    //override var popupShouldBeganDismiss: Bool { false }

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
        
        view.addBlur(color: UIColor.middleBlue.withAlphaComponent(0.4))
        
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
        dismiss(animated: true, completion: nil)
    }
}
