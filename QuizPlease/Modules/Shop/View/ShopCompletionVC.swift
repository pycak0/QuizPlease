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
    @IBOutlet weak var emailField: TitledTextFieldView!
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
        
    }
    
    private func configureViews() {
        imageView.image = shopItem.image
        configureSegmentControl()
    }
    
    func configureSegmentControl() {
        segmentControl.items = ["Получить на e-mail", "Забрать на игре"]
        segmentControl.dampingRatio = 0.7
        segmentControl.font = UIFont(name: "Gilroy-Bold", size: 16)
        segmentControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
     
}
