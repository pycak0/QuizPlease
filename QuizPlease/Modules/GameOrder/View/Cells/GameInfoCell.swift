//
//  GameInfoCell.swift
//  QuizPlease
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import MapKit

protocol GameInfoCellDelegate: class {
    func gameInfo(for gameInfoCell: GameInfoCell) -> GameInfo
}

class GameInfoCell: UITableViewCell, GameOrderCellProtocol {
    static let identifier = "GameInfoCell"
    
    weak var delegate: AnyObject? {
        get { _delegate }
        set { _delegate = newValue as? GameInfoCellDelegate }
    }
    
    private weak var _delegate: GameInfoCellDelegate? {
        didSet {
            guard let info = _delegate?.gameInfo(for: self) else { return }
            configure(with: info)
        }
    }

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeAddressLabel: UILabel!
    
    @IBOutlet weak var availablePlacesStack: UIStackView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var gameStatusLabel: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }
    
    func configureViews() {
        cellView.layer.cornerRadius = 20
    }
    
    //MARK:- Configure
    func configure(with info: GameInfo) {
        priceLabel.text = info.priceDetails
        timeLabel.text = "в \(info.time)"
        placeNameLabel.text = info.placeInfo.title
        placeAddressLabel.text = info.placeInfo.shortAddress
        
        configureMapView(with: info.placeInfo)
        
        gameStatusLabel.text = info.gameStatus?.comment ?? ""
        switch info.gameStatus {
        case .placesAvailable:
            statusImageView.image = UIImage(named: "fireIcon")
        case .reserveAvailable, .noPlaces:
            statusImageView.image = UIImage(named: "soldOut")
        default:
            statusImageView.image = nil
        }
                
        //mapView.centerToAddress(info.placeInfo.address, addAnnotation: info.placeInfo, regionRadius: 300, animated: false)
    }
    
    func configureMapView(with place: Place) {
        MapService.getLocation(from: place.fullAddress) { [weak self] (location) in
            guard let self = self, let location = location else { return }
            self.mapView.centerToLocation(location, animated: false)
            place.coordinate = location.coordinate
            self.mapView.addAnnotation(place)
        }
    }
    
}
