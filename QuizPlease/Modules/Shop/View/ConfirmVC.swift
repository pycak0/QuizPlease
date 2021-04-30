//
//  ConfirmVC.swift
//  QuizPlease
//
//  Created by Владислав on 20.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import BottomPopup

//MARK:- Delegate Protocol
protocol ConfirmVCDelegate: class {
    func didAgreeToPurchase(item: ShopItem)
}

class ConfirmVC: BottomPopupViewController {
    let duration = 0.2
    
    //MARK:- Override props
    override var popupTopCornerRadius: CGFloat { 30 }
    override var popupHeight: CGFloat { 530 }
    override var popupDismissDuration: Double { duration }
    override var popupPresentDuration: Double { duration }
    //override var popupShouldBeganDismiss: Bool { false }
    
    weak var delegate: ConfirmVCDelegate?
    
    //MARK:- Outlets
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var confirmMessageLabel: UILabel!
    @IBOutlet private weak var cancelButton: ScalingButton!
    @IBOutlet private weak var confirmButton: ScalingButton!
    
    var shopItem: ShopItem!

    //MARK:- Lifecycle
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
        itemImageView.loadImage(path: shopItem.imagePath, placeholderImage: .logoColoredImage)
        descriptionLabel.text = shopItem.description
        titleLabel.text = shopItem.title
        let priceFormatted = shopItem.priceNumber.string(withAssociatedMaleWord: "балл")
        let title = shopItem.title.trimmingCharacters(in: .whitespacesAndNewlines)
        confirmMessageLabel.text = "Потратить \(priceFormatted) на «\(title)»?"
        
    }
    
    //MARK:- Actions
    @IBAction
    private func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction
    private func confirmButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        delegate?.didAgreeToPurchase(item: shopItem)
    }
}
