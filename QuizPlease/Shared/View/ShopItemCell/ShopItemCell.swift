//
// MARK: ShopItemCell.swift
//  QuizPlease
//
//  Created by Владислав on 31.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class ShopItemCell: UICollectionViewCell {
    static let identifier = "ShopItemCell"

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var getLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        cellView.layer.sublayers?.removeAll(where: { $0 is CAGradientLayer })
        imageView.image = nil
    }

    func configureCell(imagePath: String?, price: Int) {
        priceLabel.text = price.string(withAssociatedMaleWord: "балл")
        imageView.loadImage(path: imagePath, placeholderImage: .logoTemplateImage)
    }

    private func configureViews() {
        cellView.layer.cornerRadius = 25
        getLabel.layer.cornerRadius = getLabel.bounds.height / 2
    }
}
