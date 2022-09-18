//
// MARK: HomeGamesListVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

// MARK: - View Protocol

protocol HomeGameViewProtocol: UIViewController {
    var presenter: HomeGamePresenterProtocol! { get set }
    func reloadHomeGamesList()
}

final class HomeGamesListVC: UIViewController {

    var presenter: HomeGamePresenterProtocol!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }

    // MARK: - UI Elements

    @IBOutlet weak var headerView: UIView! {
        didSet {
            headerView.layer.cornerRadius = 25
            headerView.clipsToBounds = true
            headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }

    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.collectionViewLayout = TwoColumnsFlowLayout(cellAspectRatio: 8 / 11)
            collectionView.register(
                UINib(nibName: HomeGameCell.identifier, bundle: nil),
                forCellWithReuseIdentifier: HomeGameCell.identifier
            )
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        HomeGameConfigurator().configure(self)
        presenter.viewDidLoad(self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
}

// MARK: - HomeGameViewProtocol

extension HomeGamesListVC: HomeGameViewProtocol {

    func reloadHomeGamesList() {
        collectionView.reloadSections(IndexSet(integer: 0))
    }
}

// MARK: - UICollectionViewDataSource

extension HomeGamesListVC: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.games.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(HomeGameCell.self, for: indexPath)
        let game = presenter.games[indexPath.row]
        cell.configureCell(with: game)
        return cell
    }
}

// MARK: - UICollectionViewDelegate

extension HomeGamesListVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter.didSelectHomeGame(at: indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.scaleIn()
    }

    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        collectionView.cellForItem(at: indexPath)?.scaleOut()
    }
}
