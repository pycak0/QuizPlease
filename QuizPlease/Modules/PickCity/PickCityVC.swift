//
// MARK: PickCityVC.swift
//  QuizPlease
//
//  Created by Владислав on 02.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol PickCityVCDelegate: AnyObject {
    func didPick(_ city: City)
}

class PickCityVC: UITableViewController {

    var cities: [City] = []
    var filteredCities: [City] = []
    /// Pass a City object when loading VC
    private(set) var selectedCity: City?

    weak var delegate: PickCityVCDelegate?

    init(selectedCity: City?, delegate: PickCityVCDelegate?) {
        self.selectedCity = selectedCity
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar(
            title: "Выберите город",
            tintColor: .labelAdapted,
            barStyle: .transparent,
            scrollBarStyle: .transcluent(tintColor: .clear)
        )
        configure()
        loadCities()
    }

    func confirmSelection() {
        if navigationItem.searchController?.isActive ?? false {
            navigationItem.searchController?.isActive = false
        }
        guard let city = selectedCity else { return }
        delegate?.didPick(city)
        dismiss(animated: true)
    }

    // MARK: - Loading
    func loadCities() {
        NetworkService.shared.getCities { (result) in
            switch result {
            case let .failure(error):
                print(error)
                self.showErrorConnectingToServerAlert()
            case let .success(cities):
                self.cities = cities.sorted(by: { $0.title < $1.title })
                self.filteredCities = self.cities
                self.reloadDataAndSelect()
            }
        }
    }

    func reloadDataAndSelect() {
        if let city = selectedCity,
           let index = filteredCities.firstIndex(where: { city.id == $0.id }) {
            filteredCities.remove(at: index)
            filteredCities.insert(city, at: 0)
        }
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
        // tableView.reloadData()
    }

    private func configure() {
        configureSearchController()
        addBarButtonItems()
        tableView.register(PickCityCell.self, forCellReuseIdentifier: "\(PickCityCell.self)")
    }

    // MARK: - Search Controller Configuration
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Введите город"
        searchController.searchBar.autocorrectionType = .yes
        searchController.searchBar.tintColor = .labelAdapted

        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    private func addBarButtonItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "cross"),
            style: .done,
            target: self,
            action: #selector(cancelButtonPressed)
        )
        navigationItem.leftBarButtonItem = UIBarButtonItem()
    }

    @objc private func cancelButtonPressed() {
        dismiss(animated: true)
    }

    // MARK: - Filter
    private func filterCities(with query: String?) {
        guard let query = query?.lowercased(), !query.isEmpty else {
            filteredCities = cities
            reloadDataAndSelect()
            return
        }
        filteredCities = cities.filter { $0.title.lowercased().contains(query) }
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }

}

// MARK: - Data Source & Delegate
extension PickCityVC {

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(PickCityCell.self)", for: indexPath)

        let city = filteredCities[indexPath.row]
        cell.textLabel?.text = city.title
        cell.accessoryType = city.id == selectedCity?.id ? .checkmark : .none

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.visibleCells.forEach { $0.accessoryType = .none }
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        selectedCity = filteredCities[indexPath.row]
        cell.accessoryType = .checkmark

        confirmSelection()
    }

    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        cell.accessoryType = .none
    }

}

// MARK: - UISearchResultsUpdating
extension PickCityVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterCities(with: searchController.searchBar.text)
    }
}
