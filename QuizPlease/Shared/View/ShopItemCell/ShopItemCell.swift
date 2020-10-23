//
//MARK:  ShopItemCell.swift
//  QuizPlease
//
//  Created by Владислав on 31.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class ShopItemCell: UICollectionViewCell {
    static let identifier = "ShopItemCell"

    @IBOutlet private weak var cellView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var getLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViews()
    }
    
    func configureCell(imagePath: String?, price: Int) {
        priceLabel.text = price.string(withAssociatedMaleWord: "балл")
        imageView.loadImage(path: imagePath, placeholderImage: .logoColoredImage)
    }
    
    private func configureViews() {
        cellView.layer.cornerRadius = 25
        getLabel.layer.cornerRadius = getLabel.bounds.height / 2
    }
}
