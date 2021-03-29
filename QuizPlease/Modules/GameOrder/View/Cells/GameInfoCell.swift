//
//  GameInfoCell.swift
//  QuizPlease
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import MapKit

fileprivate struct SearchAttempt {
    var place: Place
    var query: String
}

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
    
    private var searchAttempts = [SearchAttempt]()
    private var attemptsUsed = 0

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
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
        dateLabel.text = info.blockData
        placeNameLabel.text = info.placeInfo.title
        placeAddressLabel.text = info.placeInfo.shortAddress
        
        configureMapView(with: info.placeInfo)
        
        gameStatusLabel.text = info.gameStatus?.comment ?? ""
        statusImageView.image = info.gameStatus?.image
    }
    
    func configureMapView(with place: Place) {
        searchAttempts = [
            SearchAttempt(place: place, query: place.fullAddress),
            SearchAttempt(place: place, query: place.cityName),
            SearchAttempt(place: place, query: place.cityNameLatin)
        ]
        evaluateAttempts()
    }
    
    private func evaluateAttempts() {
        if !searchAttempts.isEmpty {
            let attempt = searchAttempts.removeFirst()
            attemptsUsed += 1
            print("[\(Self.self)] Trying to geocode location for place (attempt #\(attemptsUsed)): \(attempt.place)...")
            MapService.getLocation(from: attempt.query) { [weak self] location in
                guard let self = self else { return }
                if let location = location {
                    print("[\(Self.self)] Successfully geocoded location for place \(attempt.place) from attempt #\(self.attemptsUsed)")
                    let radius: CLLocationDistance = self.attemptsUsed == 1 ? 1_000 : 10_000
                    self.setLocation(location, of: attempt.place, radius: radius)
                } else {
                    self.evaluateAttempts()
                }
            }
        }
    }
    
    private func setLocation(_ location: CLLocation, of place: Place, radius: CLLocationDistance = 1000) {
        self.mapView.centerToLocation(location, regionRadius: radius, animated: false)
        place.coordinate = location.coordinate
        self.mapView.addAnnotation(place)
    }
}
