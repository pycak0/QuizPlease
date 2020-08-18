//
//MARK:  HomeGameVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol HomeGameViewProtocol: UIViewController {
    var configurator: HomeGameConfiguratorProtocol { get }
    var presenter: HomeGamePresenterProtocol! { get set }
    
    func congigureCollectionView()
    func reloadHomeGamesList()
    
}

class HomeGameVC: UIViewController {
    let configurator: HomeGameConfiguratorProtocol = HomeGameConfigurator()
    var presenter: HomeGamePresenterProtocol!

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(view: self)
        presenter.configureViews()

    }

}

extension HomeGameVC: HomeGameViewProtocol {
    func congigureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: HomeGameCell.identifier, bundle: nil), forCellWithReuseIdentifier: HomeGameCell.identifier)
    }
    
    func reloadHomeGamesList() {
        collectionView.reloadSections(IndexSet(arrayLiteral: 0))
    }
}


extension HomeGameVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeGameCell.identifier, for: indexPath) as! HomeGameCell
        
        return cell
    }
    
}
