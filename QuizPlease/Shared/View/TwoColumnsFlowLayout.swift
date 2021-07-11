//
//  TwoColumnsFlowLayout.swift
//  QuizPlease
//
//  Created by Владислав on 11.07.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit

class TwoColumnsFlowLayout: UICollectionViewFlowLayout {
    /**
     ASPECT RATIO  = width / height
     
     So, e.g. height = width / aspectRatio
     */
    let cellAspectRatio: CGFloat
    let cellsPerLine: CGFloat
    
    override var itemSize: CGSize {
        get {
            guard let fullWidth = collectionView?.bounds.width else { return .zero }
            let rowWidth = fullWidth
                - 2 * sectionInset.top
                - minimumInteritemSpacing * (cellsPerLine - 1)
            
            let cellWidth = rowWidth / cellsPerLine
            let cellHeight = cellWidth / cellAspectRatio
            return CGSize(width: cellWidth, height: cellHeight)
        }
        set {
            fatalError("\(Self.self) does not support setting property `itemSize`")
        }
    }
    
    init(
        sectionInsets: CGFloat = 16,
        interItemSpacing: CGFloat = 16,
        cellsPerLine: CGFloat = 2,
        cellAspectRatio: CGFloat
    ) {
        self.cellsPerLine = cellsPerLine
        self.cellAspectRatio = cellAspectRatio
        super.init()
        sectionInset = UIEdgeInsets(all: sectionInsets)
        minimumInteritemSpacing = interItemSpacing
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
