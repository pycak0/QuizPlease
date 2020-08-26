//
//  ShopCompletionVC.swift
//  QuizPlease
//
//  Created by Владислав on 24.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

class ShopCompletionVC: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var textFieldView: TitledTextFieldView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var segmentControl: HBSegmentedControl!
    
    var shopItem: ShopItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        
        configureViews()
    }
    
    @IBAction func confirmButtonPressed(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    private func segmentChanged() {
        view.endEditing(true)
        var title = "Электронная почта"
        var placeholder = "Введите адрес почты"
        if segmentControl.selectedIndex == 1 {
            title = "Забрать на игре"
            placeholder = "Выберите игру"
        }
        textFieldView.title = title
        textFieldView.placeholder = placeholder
        textFieldView.textField.isEnabled = segmentControl.selectedIndex == 0
        arrowImageView.isHidden = segmentControl.selectedIndex == 0
        textFieldView.textField.text = ""
    }
    
    @objc
    private func didPressFieldView() {
        guard !segmentControl.isEnabled else { return }
        showChooseTeamActionSheet(teamNames: ["game1", "game2"]) { (selectedName) in
            self.textFieldView.textField.text = selectedName
        }
    }
    
    private func configureViews() {
        imageView.image = shopItem.image
        configureSegmentControl()
        
        textFieldView.addTapGestureRecognizer {
            self.didPressFieldView()
        }
    }
    
    func configureSegmentControl() {
        segmentControl.items = ["Получить на e-mail", "Забрать на игре"]
        segmentControl.dampingRatio = 0.9
        segmentControl.font = UIFont(name: "Gilroy-Bold", size: 16)
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
     
}
