//
//  PickCityVC.swift
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
    ///Pass a City object when loading VC
    var selectedCity: City!
    
    weak var delegate: PickCityVCDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareNavigationBar()
        loadCities()
    }
    
    func loadCities() {
        NetworkService.shared.getCities { (result) in
            switch result {
            case let .failure(error):
                print(error)
                self.showErrorConnectingToServerAlert()
            case let .success(cities):
                self.cities = cities
                self.reloadDataAndSelect()
            }
        }
    }
    
    func reloadDataAndSelect() {
        if let index = cities.firstIndex(where: { selectedCity?.id == $0.id }) {
            cities.remove(at: index)
            cities.insert(self.selectedCity, at: 0)
            tableView.reloadData()
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        } else {
            tableView.reloadData()
        }
    }
    
    @IBAction func doneButtonPressed(_ sender: Any) {
        delegate?.didPick(selectedCity)
        dismiss(animated: true)
    }
    
}
    
extension PickCityVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PickCityCell", for: indexPath)
        
        cell.textLabel?.text = cities[indexPath.row].title
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        selectedCity = cities[indexPath.row]
        cell.accessoryType = .checkmark
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        cell.accessoryType = .none
    }

}
