//
//  MainMenuShopCollectionView.swift
//  QuizPlease
//
//  Created by Владислав on 26.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- Shop Cell Collection View
extension MainMenuVC: UICollectionViewDelegate, UICollectionViewDataSource, MenuShopCellDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = presenter.sampleShopItems.count
        collectionView.isHidden = !(count > 0)
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopItemCell.identifier, for: indexPath) as! ShopItemCell
        
        let item = presenter.sampleShopItems[indexPath.row]
        cell.configureCell(imagePath: item.imagePath, price: item.priceNumber)
        cell.getLabel.isHidden = true
        
        let count = UIView.GradientPreset.shopItemPresets.count
        if count > 0 {
            let gradientPreset = UIView.GradientPreset.shopItemPresets[indexPath.row % count]
            cell.cellView.addGradient(gradientPreset)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.scaleIn()
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.scaleOut()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectMenuItem(at: MainMenuItemKind.shop.rawValue)
    }
    
    func didPressMoreButton(in cell: MenuShopCell) {
        presenter.didSelectMenuItem(at: MainMenuItemKind.shop.rawValue)
    }
    
    func didPressRemindButton(in cell: MenuShopCell) {
        presenter.didPressMenuRemindButton()
    }
}
