//
//MARK:  ShopVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- View Protocol
protocol ShopViewProtocol: UIViewController {
    var presenter: ShopPresenterProtocol! { get set }
    
    func configureCollectionView()
    func reloadCollectionView()
    func endLoadingAnimation()
    func showItemsEmpty()

    func showUserPoints(_ points: Int)
    
}

class ShopVC: UIViewController {
    var presenter: ShopPresenterProtocol!

    @IBOutlet private weak var userPointsLabel: UILabel!
    @IBOutlet private weak var shopCollectionView: UICollectionView!
    
    private var gradients = UIView.GradientPreset.shopItemPresets
        
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.setupView()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
    
    @IBAction func remindButtonPressed(_ sender: Any) {
        presenter.didPressRemindButton()
    }
    
    @objc
    private func refreshControlTriggered() {
        presenter.handleRefreshControl()
    }
}

//MARK:- Protocol Implementation
extension ShopVC: ShopViewProtocol {
    func configureCollectionView() {
        shopCollectionView.delegate = self
        shopCollectionView.dataSource = self
        
        shopCollectionView.register(UINib(nibName: ShopItemCell.identifier, bundle: nil), forCellWithReuseIdentifier: ShopItemCell.identifier)
        shopCollectionView.refreshControl = UIRefreshControl(target: self, action: #selector(refreshControlTriggered))
        
        userPointsLabel.isHidden = true
        userPointsLabel.layer.cornerRadius = 15

        shopCollectionView.refreshControl?.beginRefreshing()
    }
    
    func endLoadingAnimation() {
        shopCollectionView.refreshControl?.endRefreshing()
    }
    
    func reloadCollectionView() {
        //shopCollectionView.reloadData()
        shopCollectionView.isHidden = false
        shopCollectionView.reloadSections(IndexSet(arrayLiteral: 0))
    }
    
    func showItemsEmpty() {
        shopCollectionView.isHidden = true
    }
    
    func showUserPoints(_ points: Int) {
        userPointsLabel.isHidden = false
        userPointsLabel.text = "\(points) Б"
    }
}

//MARK:- ConfirmVC Delegate
extension ShopVC: ConfirmVCDelegate {
    func didAgreeToPurchase(item: ShopItem) {
        presenter.didAgreeToPurchase(item)
    }
}

extension ShopVC: ShopCompletionVCDelegate {
    func shopCompletionVC(_ vc: ShopCompletionVC, didCompletePurchaseForItem shopItem: ShopItem) {
        presenter.didPurchase(shopItem)
    }
}

//MARK:- Data Source
extension ShopVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShopItemCell.identifier, for: indexPath) as? ShopItemCell else {
            fatalError("Invalid Cell Kind")
        }
        let item = presenter.items[indexPath.item]
        cell.configureCell(imagePath: item.imagePath, price: item.priceNumber)
        
        let index = indexPath.row % gradients.count
        cell.cellView.addGradient(gradients[index])
                
        return cell
    }
    
    
}

//MARK:- Delegate
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectItem(at: indexPath.row)
    }
}


//MARK:- Flow Layout
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
