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
    var configurator: ShopConfiguratorProtocol { get }
    var presenter: ShopPresenterProtocol! { get set }
    
    func configureCollectionView()
    func reloadCollectionView()
}

class ShopVC: UIViewController {
    let configurator: ShopConfiguratorProtocol = ShopConfigurator()
    var presenter: ShopPresenterProtocol!

    @IBOutlet weak var userPointsLabel: UILabel!
    
    @IBOutlet weak var shopCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(self)
        presenter.configureViews()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
    
    private func configureRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .labelAdapted
        refreshControl.addTarget(self, action: #selector(refreshControlTriggered), for: .valueChanged)
        shopCollectionView.refreshControl = refreshControl
    }
    
    @objc
    private func refreshControlTriggered() {
        presenter.handleRefreshControl { [weak self] in
            self?.shopCollectionView.refreshControl?.endRefreshing()
        }
    }
    

}

//MARK:- Protocol Implementation
extension ShopVC: ShopViewProtocol {
    func configureCollectionView() {
        shopCollectionView.delegate = self
        shopCollectionView.dataSource = self
        
        shopCollectionView.register(UINib(nibName: ShopItemCell.identifier, bundle: nil), forCellWithReuseIdentifier: ShopItemCell.identifier)
        
        userPointsLabel.layer.cornerRadius = 15
    }
    
    func reloadCollectionView() {
        shopCollectionView.reloadData()
    }
}

extension ShopVC: ConfirmVCDelegate {
    func didAgreeToPurchase(item: ShopItem) {
        presenter.didAgreeToPurchase(item)
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
        cell.configureCell(image: item.image, price: item.price)
                
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
