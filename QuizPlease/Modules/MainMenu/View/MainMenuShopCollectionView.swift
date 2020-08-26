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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopItemCell.identifier, for: indexPath) as! ShopItemCell
        
        cell.configureCell(image: UIImage(named: "logoSmall"), price: 20 + indexPath.row)
        cell.getLabel.isHidden = true
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.scaleIn()
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.scaleOut()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectMenuItem(at: MenuItemKind.shop.rawValue)
    }
    
    func didPressMoreButton(in cell: MenuShopCell) {
        presenter.didSelectMenuItem(at: MenuItemKind.shop.rawValue)
    }
}
