//
//MARK:  FiltersVC.swift
//  QuizPlease
//
//  Created by Владислав on 20.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import BottomPopup

//MARK:- Delegate Protocol
protocol FiltersVCDelegate: class {
    func didChangeFilter(_ newFilter: ScheduleFilter)
    
    //func didResetFilter()
    
    func didEndEditingFilters()
}

class FiltersVC: BottomPopupViewController {
    let duration = 0.2
    
    //MARK:- Properties
    @IBOutlet weak var topStack: UIStackView!
    @IBOutlet weak var bottomStack: UIStackView!
    @IBOutlet weak var clearFilterButton: UIButton!
    
    @IBOutlet weak var cityFilterView: FilterView!
    @IBOutlet weak var dateFilterView: FilterView!
    @IBOutlet weak var statusFilterView: FilterView!
    @IBOutlet weak var formatFilterView: FilterView!
    @IBOutlet weak var gameTypeFilterView: FilterView!
    @IBOutlet weak var barFilterView: FilterView!
    
    override var popupTopCornerRadius: CGFloat { 30 }
    override var popupHeight: CGFloat { 600 }
    override var popupDismissDuration: Double { duration }
    override var popupPresentDuration: Double { duration }
    
    weak var delegate: FiltersVCDelegate?
    
    var filter: ScheduleFilter!
    
    var dates: [ScheduleDate]?
    var statuses: [ScheduleStatus]?
    var gameTypes: [GameType]?
    var bars: [SchedulePlace]?
    
    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllFilters()
        configureViews()
        updateUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "PickCityFilter":
            guard let navC = segue.destination as? UINavigationController,
            let vc = navC.viewControllers.first as? PickCityVC else {
                fatalError("Incorrect data passed when showing PickCityVC from FiltersVC")
            }
            vc.selectedCity = filter.city
            vc.delegate = self
        default:
            print("No preparations for segue with id '\(segue.identifier ?? "")'")
        }
    }
    
    //MARK:- Configure Views
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
        
        addActions()
    }
    
    //MARK:- Add Actions
    private func addActions() {
        cityFilterView.addTapGestureRecognizer {
            self.performSegue(withIdentifier: "PickCityFilter", sender: nil)
        }
        dateFilterView.addTapGestureRecognizer {
            guard let dates = self.dates else { return }
            let dateNames = dates.map { $0.title }
            var selectedIndex = 0
            if let index = dateNames.firstIndex(of: self.filter.date?.title ?? "") { selectedIndex = index }
            self.showPickerSheet("Выберите время", with: dateNames, selectedIndex: selectedIndex) { [weak self] (selectedIndex) in
                guard let self = self else { return }
                self.filter.date = dates[selectedIndex]
                self.updateUI()
                self.delegate?.didChangeFilter(self.filter)
            }
        }
        statusFilterView.addTapGestureRecognizer {
            guard let statuses = self.statuses else { return }
            let statusNames = ["Все игры"] + statuses.map { $0.title }
            self.showChooseItemActionSheet(itemNames: statusNames, tintColor: .darkBlue) { [unowned self] (item, selectedIndex) in
                self.filter.status = selectedIndex == 0 ? nil : statuses[selectedIndex - 1]
                self.updateUI()
                self.delegate?.didChangeFilter(self.filter)
            }
        }
        formatFilterView.addTapGestureRecognizer {
            let formats = GameFormat.allCases.map { $0.title }
            self.showChooseItemActionSheet(itemNames: formats, tintColor: .darkBlue) { [weak self] (item, selectedIndex) in
                guard let self = self else { return }
                let newFormat = GameFormat.allCases[selectedIndex]
                self.filter.format = newFormat
                self.updateUI()
                self.delegate?.didChangeFilter(self.filter)
            }
        }
        gameTypeFilterView.addTapGestureRecognizer {
            guard let types = self.gameTypes else { return }
            let typeNames = types.map { $0.title }
            self.showChooseItemActionSheet(itemNames: typeNames, tintColor: .darkBlue) { [weak self] (item, selectedIndex) in
                guard let self = self else { return }
                self.filter.type = types[selectedIndex]
                self.updateUI()
                self.delegate?.didChangeFilter(self.filter)
            }
        }
        barFilterView.addTapGestureRecognizer {
            guard let bars = self.bars else { return }
            let barNames = ["Все бары"] + bars.map { $0.title }
            self.showPickerSheet("Выберите место", with: barNames, selectedIndex: 0) { [weak self] (selectedIndex) in
                guard let self = self else { return }
                self.filter.place = selectedIndex == 0 ? nil : bars[selectedIndex - 1]
                self.updateUI()
                self.delegate?.didChangeFilter(self.filter)
            }
        }
    }
    
    //MARK:- Loaf Filters
    private func loadFilters<T: ScheduleFilterProtocol>(_ type: T.Type, city_id: Int? = nil, completion: @escaping ([T]?) -> Void) {
        NetworkService.shared.getFilterOptions(type, scopeFor: city_id) { serverResult in
            switch serverResult {
            case let .failure(error):
                print(error)
                completion(nil)
            case let .success(filterValues):
                completion(filterValues)
            }
        }
    }
    
    func loadAllFilters() {
        loadFilters(GameType.self) { [weak self] in self?.gameTypes = $0 }
        loadFilters(ScheduleStatus.self) { [weak self] in self?.statuses = $0 }
        loadFilters(ScheduleDate.self) { [weak self] in self?.dates = $0 }
        loadFilters(SchedulePlace.self, city_id: filter.city.id) { [weak self] in self?.bars = $0 }
    }
    
    //MARK:- Update UI
    private func updateUI() {
        cityFilterView.title = filter.city.title
        dateFilterView.title = filter.date?.title ?? "Все время"
        statusFilterView.title = filter.status?.title ?? "Все игры"
        formatFilterView.title = filter.format?.title ?? "Все форматы"
        gameTypeFilterView.title = filter.type?.title ?? "Все типы"
        barFilterView.title = filter.place?.title ?? "Все бары"
    }
    
    //MARK:- Close Button Pressed
    @IBAction func closeButtonPressed(_ sender: Any) {
        delegate?.didEndEditingFilters()
        dismiss(animated: true, completion: nil)
    }
    
    //MARK:- Clear Filters Button Pressed
    @IBAction func clearFiltersButtonPressed(_ sender: Any) {
        filter = ScheduleFilter()
        updateUI()
        delegate?.didChangeFilter(filter)
    }
    
}

//MARK:- PickCityVCDelegate
extension FiltersVC: PickCityVCDelegate {
    func didPick(_ city: City) {
        filter.city = city
        loadFilters(SchedulePlace.self, city_id: filter.city.id) { [weak self] in self?.bars = $0 }
        updateUI()
        delegate?.didChangeFilter(filter)
    }
}
