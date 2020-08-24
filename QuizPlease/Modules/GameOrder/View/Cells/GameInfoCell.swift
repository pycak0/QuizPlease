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
    
    func configure(with info: GameInfo) {
        priceLabel.text = "\(info.price) ₽ с человека"
        timeLabel.text = "в \(info.time)"
        placeNameLabel.text = info.place.name
        placeAddressLabel.text = info.place.address
                
        mapView.centerToAddress(info.place.address, regionRadius: 300, animated: false)
        mapView.addAnnotation(info.place)
    }
    
}
