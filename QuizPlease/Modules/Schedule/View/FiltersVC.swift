//
//  FiltersVC.swift
//  QuizPlease
//
//  Created by Владислав on 20.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import BottomPopup

//MARK:- Delegate Protocol
protocol FiltersVCDelegate: class {
    func didChangeFilter(of type: ScheduleFilterType)
    
    func didEndEditingFilters()
}

class FiltersVC: BottomPopupViewController {
    let duration = 0.2
    
    @IBOutlet weak var topStack: UIStackView!
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var clearFilterButton: UIButton!
    
    @IBOutlet weak var cityFilterView: UIView!
    @IBOutlet weak var dateFilterView: UIView!
    @IBOutlet weak var statusFilterView: UIView!
    @IBOutlet weak var formatFilterView: UIView!
    @IBOutlet weak var gameTypeFilterView: UIView!
    @IBOutlet weak var barFilterView: UIView!
    
    override var popupTopCornerRadius: CGFloat { 30 }
    override var popupHeight: CGFloat { 600 }
    override var popupDismissDuration: Double { duration }
    override var popupPresentDuration: Double { duration }
    
    weak var delegate: FiltersVCDelegate?
    
    var dates = [String]()
    var statuses = [String]()
    var formats = [String]()
    var gameTypes = [String]()
    var bars = [String]()
    
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
        view.blurView.setupPopupBlur()
        //view.addBlur(color: UIColor.middleBlue.withAlphaComponent(0.4))
        
        cityFilterView.addTapGestureRecognizer {
            //load values and show alert/picker
        }
        dateFilterView.addTapGestureRecognizer {
            
        }
        statusFilterView.addTapGestureRecognizer {
        }
        formatFilterView.addTapGestureRecognizer {
        }
        gameTypeFilterView.addTapGestureRecognizer {
        }
        barFilterView.addTapGestureRecognizer {
        }
    }
    
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        delegate?.didEndEditingFilters()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearFiltersButtonPressed(_ sender: Any) {
    }
    
}
