//
//MARK:  HomeGamesListVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- View Protocol
protocol HomeGameViewProtocol: UIViewController {
    var configurator: HomeGameConfiguratorProtocol { get }
    var presenter: HomeGamePresenterProtocol! { get set }
    
    func congigureCollectionView()
    func reloadHomeGamesList()
    
}

class HomeGamesListVC: UIViewController {
    let configurator: HomeGameConfiguratorProtocol = HomeGameConfigurator()
    var presenter: HomeGamePresenterProtocol!

    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(view: self)
        presenter.configureViews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        //navigationController?.navigationBar.tintColor = .labelAdapted
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }

}

//MARK:- Protocol Implementation
extension HomeGamesListVC: HomeGameViewProtocol {
    func congigureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: HomeGameCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeGameCell.identifier)
        
        headerView.layer.cornerRadius = 20
        headerView.clipsToBounds = true
        headerView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
    }
    
    func reloadHomeGamesList() {
       // collectionView.reloadSections(IndexSet(arrayLiteral: 0))
        collectionView.reloadData()
    }
}


//MARK:- Data Source & Delegate
extension HomeGamesListVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.games.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeGameCell.identifier, for: indexPath) as! HomeGameCell
        let game = presenter.games[indexPath.row]
        cell.configureCell(with: game)
        return cell
    }
    
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


//MARK:- Flow Layout
extension HomeGamesListVC: UICollectionViewDelegateFlowLayout {
    private struct SectionLayout {
        static let sectionInsets: CGFloat = 16
        static let interItemSpacing: CGFloat = 16
        static let cellsPerLine: CGFloat = 2
        static let cellAspectRatio: CGFloat = 8 / 11
        
        /**
         width       8
         ------- =  ---- = ASPECT RATIO    =>    height = width  /  aspectRatio
         height      11
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
