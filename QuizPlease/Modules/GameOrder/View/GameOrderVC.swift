//
//  GameOrderVC.swift
//  QuizPlease
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

//MARK:- View Protocol
protocol GameOrderViewProtocol: UIViewController {
    var presenter: GameOrderPresenterProtocol! { get set }
    //var configurator: GameOrderConfiguratorProtocol! { get }
    
    var shouldScrollToSignUp: Bool! { get set }
    
    func reloadInfo()
    func configureTableView()
    
    func enableLoading()
    func disableLoading()
    
    func editEmail()
    func editPhone()
    
    func setPrice(_ price: Int)
    func setBackgroundImage(with path: String)
}

class GameOrderVC: UIViewController {
    //let configurator: GameOrderConfiguratorProtocol! = GameOrderConfigurator()
    var presenter: GameOrderPresenterProtocol!
    
    var shouldScrollToSignUp: Bool!
    
    lazy var items: [GameInfoItemKind] = {
        let types = presenter.game.availablePaymentTypes
        var _items = GameInfoItemKind.allCases
        if types.count == 1 && types.first! == .cash {
            _items.removeAll { $0 == .onlinePayment }
        }
        if !presenter.registerForm.isFirstTime {
            _items.removeAll { $0 == .promocode }
        }
        //if presenter.game.
        return _items
    }()
    
    var isFirstLoad = true
    
    private var activityIndicator = UIActivityIndicatorView()
    
    @IBOutlet private weak var gameImageView: UIImageView!
    @IBOutlet private weak var imageDarkeningView: UIView!
    @IBOutlet weak var tableView: UITableView!
        
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.configureViews()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.router.prepare(for: segue, sender: sender)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func scrollToSignUp() {
        let indexPath = IndexPath(row: GameInfoItemKind.registration.rawValue, section: 0)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    ///Scroll to the top of Register section, after that calls `completion` closure where returns a `GameRegisterCell` object (if no errors occured)
    func scrollToRegistrationCell(animated: Bool = true, completion: ((GameRegisterCell?) -> Void)?) {
        let indexPath = IndexPath(row: GameInfoItemKind.registration.rawValue, section: 0)
        
        if let cell = tableView.cellForRow(at: indexPath) as? GameRegisterCell {
            tableView.scrollToRow(at: indexPath, at: .top, animated: animated)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                completion?(cell)
            }
        } else {
            completion?(nil)
            print("Invalid cell kind at Register indexPath")
        }
        
    }

}

//MARK:- Protocol Implementation
extension GameOrderVC: GameOrderViewProtocol {
    func reloadInfo() {
        tableView.reloadData()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        for cellKind in GameInfoItemKind.allCases {
            tableView.register(UINib(nibName: cellKind.identifier, bundle: nil), forCellReuseIdentifier: cellKind.identifier)
        }
        
        if shouldScrollToSignUp {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.scrollToSignUp()
            }
        }
    }
    
    func enableLoading() {
        activityIndicator.enableCentered(in: view, color: .systemBlue)
    }
    
    func disableLoading() {
        activityIndicator.stopAnimating()
    }
    
    func editEmail() {
        scrollToRegistrationCell { $0?.emailFieldView.textField.becomeFirstResponder() }
    }
    
    func editPhone() {
        scrollToRegistrationCell { (cell) in
            cell?.phoneFieldView.textField.becomeFirstResponder()
        }
    }
    
    func setPrice(_ price: Int) {
        guard let index = items.firstIndex(of: .onlinePayment) else { return }
        if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? GameOnlinePaymentCell {
            cell.setPrice(price)
        }
    }
    
    func setBackgroundImage(with path: String) {
        let placeholder = gameImageView.image
        gameImageView.loadImage(
            path: path,
            placeholderImage: placeholder)
        { [weak self] image in
            guard let self = self else { return }
            if image == nil {
                self.gameImageView.loadImageFromMainDomain(path: path, placeholderImage: placeholder)
            }
        }
    }
}

//MARK:- Data Source & Delegate
extension GameOrderVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //createCell(tableView, at: indexPath)

        let kind = items[indexPath.row]
        //guard let kind = GameInfoItemKind(rawValue: index) else { fatalError("Invalid Game Item Kind") }
        let cell = tableView.dequeueReusableCell(withIdentifier: kind.identifier, for: indexPath) as! TableCellProtocol
        
        (cell as? GameCertificateCell)?.associatedItemKind = kind
        if let cell = cell as? GameOrderCellProtocol, (cell.delegate as? GameOrderVC) == nil {
            cell.delegate = self
        }
        
        //(cell as? GameOrderCellProtocol)?.delegate = self
        
        return cell
    }
    
}

//MARK:- UIScrollViewDelegate
extension GameOrderVC: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y + scrollView.safeAreaInsets.top
        
        gameImageView.isHidden = offset > 700
        imageDarkeningView.isHidden = offset > 700
        
        guard offset < 0, scrollView.isKind(of: UITableView.self) else {
            gameImageView.transform = .identity
            imageDarkeningView.transform = .identity
            return
        }
        let scale = (1 + abs(offset) / 300)
        let transform = CGAffineTransform(scaleX: scale, y: scale)
        gameImageView.transform = transform
        imageDarkeningView.transform = transform
    }
}
