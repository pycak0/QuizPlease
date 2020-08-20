//
//  FiltersVC.swift
//  QuizPlease
//
//  Created by Владислав on 20.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import BottomPopup

class FiltersVC: BottomPopupViewController {
    let duration = 0.2
    
    @IBOutlet weak var topStack: UIStackView!
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var clearFilterButton: UIButton!
    
    override var popupTopCornerRadius: CGFloat { 30 }
    override var popupHeight: CGFloat { 600 }
    override var popupDismissDuration: Double { duration }
    override var popupPresentDuration: Double { duration }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func configureViews() {
        let color = UIColor.darkBlue.withAlphaComponent(0.3)
        let radius: CGFloat = 20
        
        topStack.arrangedSubviews.forEach( {
            $0.backgroundColor = color
            $0.layer.cornerRadius = radius
        })
        bottomStack.arrangedSubviews.forEach( {
            $0.backgroundColor = color
            $0.layer.cornerRadius = radius
        })
        
        clearFilterButton.layer.cornerRadius = radius
        clearFilterButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.addBlur(color: UIColor.middleBlue.withAlphaComponent(0.4))
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearFiltersButtonPressed(_ sender: Any) {
    }
    
}
