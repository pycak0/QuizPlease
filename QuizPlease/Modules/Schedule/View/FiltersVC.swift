//
//  FiltersVC.swift
//  QuizPlease
//
//  Created by Владислав on 20.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import BottomPopup

// MARK: - Delegate Protocol

protocol FiltersVCDelegate: AnyObject {

    /// Method is called whenever a change occurs in a filter
    func didChangeFilter(_ newFilter: ScheduleFilter)

    /// Method is called before Filter screen will close
    func didEndEditingFilters()
}

final class FiltersVC: BottomPopupViewController {
    let duration = 0.2

    // MARK: - Properties

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

    var dates: [ScheduleFilterOption]?
    var statuses: [ScheduleFilterOption]?
    var gameTypes: [ScheduleFilterOption]?
    var bars: [ScheduleFilterOption]?

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        loadAllFilters()
        configureViews()
        updateUI()
    }

    // MARK: - Configure Views

    func configureViews() {
        let color = UIColor.darkBlue.withAlphaComponent(0.3)
        let radius: CGFloat = 20

        topStack.arrangedSubviews.forEach {
            $0.backgroundColor = color
            $0.layer.cornerRadius = radius
        }
        bottomStack.arrangedSubviews.forEach {
            $0.backgroundColor = color
            $0.layer.cornerRadius = radius
        }

        clearFilterButton.layer.cornerRadius = radius
        clearFilterButton.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        view.blurView.setupPopupBlur()
        // view.addBlur(color: UIColor.middleBlue.withAlphaComponent(0.4))

        addActions()
    }

    // MARK: - Add Actions

    private func addActions() {
        cityFilterView.addTapGestureRecognizer {
            self.showCityPicker()
        }
        dateFilterView.addTapGestureRecognizer {
            self.showOptions(for: self.dates) { self.filter.date = $0 }
        }
        statusFilterView.addTapGestureRecognizer {
            self.showOptions(for: self.statuses) { self.filter.status = $0 }
        }
        gameTypeFilterView.addTapGestureRecognizer {
            self.showOptions(for: self.gameTypes) { self.filter.type = $0 }
        }
        barFilterView.addTapGestureRecognizer {
            self.showOptions(for: self.bars) { self.filter.place = $0 }
        }
        formatFilterView.addTapGestureRecognizer {
            let formats = GameFormat.allCases.map { $0.title }
            self.showOptions(with: formats) { (selectedIndex) in
                let newFormat = GameFormat.allCases[selectedIndex]
                self.filter.format = newFormat == .all ? nil : newFormat
            }
        }
    }

    private func showCityPicker() {
        let pickCityVc = PickCityVC(
            selectedCity: filter.city,
            delegate: self
        )
        let navC = UINavigationController(rootViewController: pickCityVc)
        present(navC, animated: true)
    }

    // MARK: - Show Options Sheet

    /// - warning: `updateFilterWith` closure must update `filter`'s property with new value for correct work.
    private func showOptions(
        for filterOptions: [ScheduleFilterOption]?,
        updateFilterWith: @escaping (ScheduleFilterOption?) -> Void
    ) {
        guard let names = filterOptions?.map({ $0.title }) else { return }
        showOptions(with: names) { (selectedIndex) in
            updateFilterWith(filterOptions?[selectedIndex])
        }
    }

    private func showOptions(
        with givenNames: [String],
        updateWithSelectedIndex: @escaping (Int) -> Void
    ) {
        showChooseItemActionSheet(
            itemNames: givenNames,
            tintColor: .darkBlueDynamic
        ) { [weak self] (_, selectedIndex) in
            guard let self = self else { return }

            updateWithSelectedIndex(selectedIndex)
            self.updateUI()
            self.delegate?.didChangeFilter(self.filter)
        }
    }

    // MARK: - Load Filters

    private func loadFilters(
        _ type: ScheduleFilterType,
        cityId: Int? = nil,
        completion: @escaping ([ScheduleFilterOption]?) -> Void
    ) {
        let cityId = cityId ?? filter.city.id
        NetworkService.shared.getFilterOptions(type, scopeFor: cityId) { serverResult in
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
        loadFilters(.types) { [weak self] in self?.gameTypes = $0 }
        loadFilters(.statuses) { [weak self] in self?.statuses = $0 }
        loadFilters(.months) { [weak self] in self?.dates = $0 }
        loadFilters(.places) { [weak self] in self?.bars = $0 }
    }

    // MARK: - Update UI

    private func updateUI() {
        cityFilterView.title = filter.city.title
        dateFilterView.title = filter.date?.title ?? "Все время"
        statusFilterView.title = filter.status?.title ?? "Все игры"
        formatFilterView.title = filter.format?.title ?? "Все форматы"
        gameTypeFilterView.title = filter.type?.title ?? "Все типы"
        barFilterView.title = filter.place?.title ?? "Все бары"
    }

    // MARK: - Close Button Pressed

    @IBAction func closeButtonPressed(_ sender: Any) {
        delegate?.didEndEditingFilters()
        dismiss(animated: true, completion: nil)
    }

    // MARK: - Clear Filters Button Pressed

    @IBAction func clearFiltersButtonPressed(_ sender: Any) {
        filter = ScheduleFilter()
        updateUI()
        delegate?.didChangeFilter(filter)
    }
}

// MARK: - PickCityVCDelegate

extension FiltersVC: PickCityVCDelegate {
    func didPick(_ city: City) {
        filter.city = city
        loadAllFilters()
        updateUI()
        delegate?.didChangeFilter(filter)
    }
}
