//
//MARK:  MainMenuVC.swift
//  QuizPlease
//
//  Created by Владислав on 30.07.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- View Protocol
protocol MainMenuViewProtocol: UIViewController {
    var presenter: MainMenuPresenterProtocol! { get set }
    func configureTableView()
    func updateCityName(with name: String)
    func reloadMenuItems()
    func failureLoadingMenuItems(_ error: Error)
    
    ///if `points` is `nil`, the label will be hidden
    func reloadUserPointsAmount()
    
    func reloadShopItems()
}

class MainMenuVC: UIViewController {
    var presenter: MainMenuPresenterProtocol!

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var menuHeader: UIView!
    @IBOutlet weak var cityButton: UIButton!
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        MainMenuConfigurator().configure(self)
        presenter.viewDidLoad(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.tintColor = .labelAdapted
        navigationController?.navigationBar.barTintColor = .systemBackgroundAdapted
        setNavBarDefault()
        presenter.viewDidAppear(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    // delegate prepare(for:sender:) to the router
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
    
    @IBAction func cityButtonPressed(_ sender: UIButton) {
        presenter.didSelectCityButton()
    }
}

//MARK:- View Protocol Implementation
extension MainMenuVC: MainMenuViewProtocol {
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        logoImageView.image = logoImageView.image?.withRenderingMode(.alwaysOriginal)
        cityButton.titleLabel?.adjustsFontSizeToFitWidth = true
        cityButton.setTitleColor(.darkGray, for: .highlighted)
        //tableView.tableHeaderView = menuHeader
        
        tableView.register(UINib(nibName: ScheduleCell.identifier, bundle: nil), forCellReuseIdentifier: ScheduleCell.identifier)
        tableView.register(UINib(nibName: MenuProfileCell.identifier, bundle: nil), forCellReuseIdentifier: MenuProfileCell.identifier)
        tableView.register(UINib(nibName: WarmupCell.identifier, bundle: nil), forCellReuseIdentifier: WarmupCell.identifier)
        tableView.register(UINib(nibName: MenuHomeGameCell.identifier, bundle: nil), forCellReuseIdentifier: MenuHomeGameCell.identifier)
        tableView.register(UINib(nibName: MenuRatingCell.identifier, bundle: nil), forCellReuseIdentifier: MenuRatingCell.identifier)
        tableView.register(UINib(nibName: MenuShopCell.identifier, bundle: nil), forCellReuseIdentifier: MenuShopCell.identifier)
    }
    
    func updateCityName(with name: String) {
        cityButton.setTitle(name, for: .normal)
    }
    
    func failureLoadingMenuItems(_ error: Error) {
        showErrorConnectingToServerAlert()
    }
    
    func reloadMenuItems() {
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
    }
    
    func reloadShopItems() {
        guard let indexPath = presenter.indexPath(for: .shop) else { return }
        if let cell = tableView.cellForRow(at: indexPath) as? MenuShopCell {
            cell.reloadItems()
        }
    }
    
    func reloadUserPointsAmount() {
        guard let indexPath = presenter.indexPath(for: .profile) else { return }
        if let cell = tableView.cellForRow(at: indexPath) as? MenuProfileCell {
            cell.reloadUserPoints()
        }
    }
}

//MARK:- PickCityVCDelegate
extension MainMenuVC: PickCityVCDelegate {
    func didPick(_ city: City) {
        presenter.didChangeDefaultCity(city)
    }
}

//MARK:- MenuProfileCellDelegate
extension MainMenuVC: MenuProfileCellDelegate {
    func userPoints(in cell: MenuProfileCell) -> Double? {
        presenter.userPointsAmount()
    }
    
    func addGameButtonPressed(in cell: MenuProfileCell) {
        presenter.didPressAddGame()
    }
}


//MARK:- Table View Data Source
extension MainMenuVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.menuItems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let items = presenter.menuItems else { return UITableViewCell() }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: items[indexPath.row].identifier) as? MenuCellItemProtocol else { fatalError("Invalid Cell Kind") }
        let menuItem = items[indexPath.row]
        
        cell.configureCell(with: menuItem)
        (cell as? MenuShopCell)?.registerCollectoinView(self)
        
        if let profileCell = cell as? MenuProfileCell {
            profileCell.delegate = self
            profileCell.reloadUserPoints()
        }
        
        return cell
    }
}

//MARK:- Delegate
extension MainMenuVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return presenter.menuItems?[indexPath.row].height ?? 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.layoutIfNeeded()
        if let cell = cell as? MenuShopCell {
            cell.reloadItemsIfNeeded()
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != MainMenuItemKind.shop.rawValue
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        presenter.didSelectMenuItem(at: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MenuCellItemProtocol {
            cell.scaleIn()
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MenuCellItemProtocol {
            cell.scaleOut()
        }
    }
}
