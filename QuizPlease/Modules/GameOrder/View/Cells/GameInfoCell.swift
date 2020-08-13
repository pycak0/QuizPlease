//
//  GameInfoCell.swift
//  QuizPlease
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import MapKit

class GameInfoCell: UITableViewCell, TableCellProtocol {
    static let identifier = "GameInfoCell"
    
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    @IBOutlet weak var availablePlacesImageView: UIImageView!
    @IBOutlet weak var availablePlacesLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }
    
    func configureViews() {
        cellView.layer.cornerRadius = 20
    }
    
}