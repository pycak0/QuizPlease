//
//MARK:  ShopVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class ShopVC: UIViewController {

    @IBOutlet weak var shopCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureCollectionView()
    }
    

}

extension ShopVC {
    func configureCollectionView() {
        shopCollectionView.register(UINib(nibName: ShopItemCell.nibName, bundle: nil), forCellWithReuseIdentifier: ShopItemCell.reuseIdentifier)
        
        shopCollectionView.delegate = self
        shopCollectionView.dataSource = self
    }
}

extension ShopVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopItemCell.reuseIdentifier, for: indexPath) as? ShopItemCell else {
            fatalError("Invalid Cell Kind")
        }
        cell.configureCell(image: nil, price: indexPath.item)
                
        return cell
    }
    
    
}

extension ShopVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.scaleIn()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) {
            cell.contentView.scaleOut()
        }
    }
}


extension ShopVC: UICollectionViewDelegateFlowLayout {
    private struct SectionLayout {
        static let sectionInsets: CGFloat = 16
        static let interItemSpacing: CGFloat = 16
        static let cellsPerLine: CGFloat = 2
        static let cellAspectRatio: CGFloat = 3 / 4
        
        /**
         width       3
         ------- =  ---- = ASPECT RATIO    =>    height = width  /  aspectRatio
         height      4
         */
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let fullWidth = collectionView.bounds.width
        let rowWidth = fullWidth
                        - 2 * SectionLayout.sectionInsets
                        - SectionLayout.interItemSpacing * (SectionLayout.cellsPerLine - 1)
        
        let cellWidth = rowWidth / SectionLayout.cellsPerLine
        let cellHeight = cellWidth / SectionLayout.cellAspectRatio
        
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = SectionLayout.sectionInsets
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return SectionLayout.interItemSpacing
    }
    
}
