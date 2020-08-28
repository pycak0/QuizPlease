//
//  MenuShopCell.swift
//  QuizPlease
//
//  Created by Владислав on 25.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol MenuShopCellDelegate: class {
    func didPressMoreButton(in cell: MenuShopCell)
}

class MenuShopCell: UITableViewCell, MenuCellItemProtocol {
    static let identifier: String = "MenuShopCell"
    
    ///Assigned in the `registerCollectoinView(_:) method`
    private weak var delegate: MenuShopCellDelegate?

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryLabel: UILabel!
    @IBOutlet weak var accessoryStack: UIStackView!
    @IBOutlet weak var collectionView: UICollectionView!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }
    
    func configureViews() {
        collectionView.register(UINib(nibName: ShopItemCell.identifier, bundle: nil), forCellWithReuseIdentifier: ShopItemCell.identifier)
    }
    
    func configureCell(with model: MenuItemProtocol) {
        titleLabel.text = model.title
        accessoryStack.addTapGestureRecognizer {
            self.delegate?.didPressMoreButton(in: self)
        }
    }
    
    typealias Delegate = UICollectionViewDataSource & UICollectionViewDelegate & MenuShopCellDelegate
    
    func registerCollectoinView(_ delegate: Delegate) {
        self.collectionView.dataSource = delegate
        self.collectionView.delegate = delegate
        self.delegate = delegate
    }
    
}