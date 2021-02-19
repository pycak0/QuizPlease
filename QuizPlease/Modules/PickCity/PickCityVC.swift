//
//MARK:  PickCityVC.swift
//  QuizPlease
//
//  Created by Владислав on 02.09.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit

protocol PickCityVCDelegate: class {
    func didPick(_ city: City)
}

class PickCityVC: UITableViewController {
    
    var cities: [City] = []
    var filteredCities: [City] = []
    ///Pass a City object when loading VC
    var selectedCity: City!
    
    weak var delegate: PickCityVCDelegate?

    //MARK:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureSearchController()
        prepareNavigationBar()
        loadCities()
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    func confirmSelection() {
        if navigationItem.searchController?.isActive ?? false {
            navigationItem.searchController?.isActive = false
        }
        delegate?.didPick(selectedCity)
        dismiss(animated: true)
    }
    
    //MARK:- Loading
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
        if let index = filteredCities.firstIndex(where: { selectedCity?.id == $0.id }) {
            filteredCities.remove(at: index)
            filteredCities.insert(self.selectedCity, at: 0)
        }
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
        //tableView.reloadData()
    }
    
    //MARK:- Search Controller Configuration
    private func configureSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Введите город"
        searchController.searchBar.autocorrectionType = .yes
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    //MARK:- Filter
    private func filterCities(with query: String?) {
        guard let query = query?.lowercased(), !query.isEmpty else {
            filteredCities = cities
            reloadDataAndSelect()
            return
        }
        filteredCities = cities.filter { $0.title.lowercased().contains(query) }
        tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
    }
    
}
    
//MARK:- Data Source & Delegate
extension PickCityVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filteredCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickCityCell", for: indexPath)
        
        let city = filteredCities[indexPath.row]
        cell.textLabel?.text = city.title
        cell.accessoryType = city.id == selectedCity.id ? .checkmark : .none
        
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

//MARK:- UISearchResultsUpdating
extension PickCityVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterCities(with: searchController.searchBar.text)
    }
}
