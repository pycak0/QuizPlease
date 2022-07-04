//
// MARK: ShopVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// MARK: - View Protocol
protocol ShopViewProtocol: UIViewController, LoadingIndicator {
    var presenter: ShopPresenterProtocol! { get set }

    func reloadCollectionView()
    func showItemsEmpty()
    func showUserPoints(_ points: Double)
}

class ShopVC: UIViewController {
    var presenter: ShopPresenterProtocol!

    @IBOutlet private weak var userPointsLabel: UILabel! {
        didSet {
            userPointsLabel.isHidden = true
            userPointsLabel.layer.cornerRadius = 15
        }
    }

    @IBOutlet private weak var shopCollectionView: UICollectionView! {
        didSet {
            shopCollectionView.register(UINib(nibName: ShopItemCell.identifier, bundle: nil), forCellWithReuseIdentifier: ShopItemCell.identifier)
            shopCollectionView.refreshControl = UIRefreshControl(target: self, action: #selector(refreshControlTriggered))
            shopCollectionView.collectionViewLayout = TwoColumnsFlowLayout(cellAspectRatio: 3 / 4)
            shopCollectionView.delegate = self
            shopCollectionView.dataSource = self
        }
    }

    @IBOutlet private weak var emptyProductsView: UIView!

    private var gradients = UIView.GradientPreset.shopItemPresets

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar(barStyle: .transcluent(tintColor: view.backgroundColor))
        presenter.viewDidLoad(self)
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

// MARK: - Protocol Implementation
extension ShopVC: ShopViewProtocol {
    func startLoading() {
        shopCollectionView.refreshControl?.beginRefreshing()
    }

    func stopLoading() {
        if shopCollectionView.refreshControl?.isRefreshing ?? false {
            shopCollectionView.refreshControl?.endRefreshing()
        }
    }

    func reloadCollectionView() {
        emptyProductsView.isHidden = true
        shopCollectionView.reloadSections(IndexSet(integer: 0))
    }

    func showItemsEmpty() {
        emptyProductsView.isHidden = false
    }

    func showUserPoints(_ points: Double) {
        userPointsLabel.isHidden = false
        let pointsStr = NumberFormatter.decimalGroupingFormatter.string(from: points as NSNumber) ?? "N/A"
        userPointsLabel.text = "\(pointsStr) Б"
    }
}

// MARK: - ConfirmVC Delegate
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

// MARK: - Data Source
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

// MARK: - Delegate
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
