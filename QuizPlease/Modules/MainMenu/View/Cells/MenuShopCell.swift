//
//  MenuShopCell.swift
//  QuizPlease
//
//  Created by Владислав on 25.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol MenuShopCellDelegate: AnyObject {
    func didPressMoreButton(in cell: MenuShopCell)
    func didPressRemindButton(in cell: MenuShopCell)
}

final class MenuShopCell: UITableViewCell, MenuCellItemProtocol {

    /// Assigned in the `registerCollectoinView(_:) method`
    private weak var delegate: MenuShopCellDelegate?

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var accessoryLabel: UILabel!
    @IBOutlet weak var accessoryStack: UIStackView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var emptyItemsView: UIView!
    @IBOutlet private weak var remindButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        configureViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        emptyItemsView.layer.borderColor = UIColor.opaqueSeparatorAdapted.cgColor
    }

    func configureViews() {
        collectionView.register(
            UINib(nibName: "\(ShopItemCell.self)", bundle: nil),
            forCellWithReuseIdentifier: "\(ShopItemCell.self)"
        )
        accessoryStack.addTapGestureRecognizer {
            self.delegate?.didPressMoreButton(in: self)
        }
        remindButton.addTarget(self, action: #selector(remindButtonPressed), for: .touchUpInside)
    }

    @objc private func remindButtonPressed() {
        delegate?.didPressRemindButton(in: self)
    }

    func configureCell(with model: MainMenuItemProtocol) {
        titleLabel.text = model.title
    }

    typealias Delegate = UICollectionViewDataSource & UICollectionViewDelegate & MenuShopCellDelegate

    func registerCollectoinView(_ delegate: Delegate) {
        self.collectionView.dataSource = delegate
        self.collectionView.delegate = delegate
        self.delegate = delegate
        collectionView.reloadData()
    }

    func reloadItems() {
        collectionView.reloadData()
    }

    func reloadItemsIfNeeded() {
        if collectionView.visibleCells.count == 0 {
            reloadItems()
        }
    }
}
