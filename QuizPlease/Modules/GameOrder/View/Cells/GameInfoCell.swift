//
//  GameInfoCell.swift
//  QuizPlease
//
//  Created by Владислав on 12.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import UIKit
import MapKit

private struct SearchAttempt {
    let place: Place
    let query: String
}

protocol GameInfoCellDelegate: AnyObject {
    func gameInfo(for gameInfoCell: GameInfoCell) -> GameInfo

    func gameInfoCellDidTapOnMap(_ cell: GameInfoCell)
}

final class GameInfoCell: UITableViewCell, GameOrderCellProtocol {

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
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var placeNameLabel: UILabel!
    @IBOutlet private weak var placeAddressLabel: UILabel!

    @IBOutlet weak var availablePlacesStack: UIStackView!
    @IBOutlet private weak var statusImageView: UIImageView!
    @IBOutlet private weak var gameStatusLabel: UILabel!

    @IBOutlet private weak var mapView: MKMapView! {
        didSet {
            mapView.delegate = self
            mapView.addTapGestureRecognizer { [weak self] in
                guard let self = self else { return }
                self._delegate?.gameInfoCellDidTapOnMap(self)
            }
            mapView.isPitchEnabled = false
            setMapInteractions(enabled: false)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        configureViews()
    }

    // MARK: - Configure

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

    func setMapInteractions(enabled isEnabled: Bool) {
        mapView.isZoomEnabled = isEnabled
        mapView.isRotateEnabled = isEnabled
        mapView.isScrollEnabled = isEnabled
    }

    // MARK: - Private Methods

    private func configureViews() {
        cellView.layer.cornerRadius = 20
    }

    private func configureMapView(with place: Place) {
        if !place.isZeroCoordinate {
            setLocation(of: place)
            return
        }
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
                    let logMessage = "[\(Self.self)] Successfully geocoded location " +
                    "for place \(attempt.place) from attempt #\(self.attemptsUsed)"
                    print(logMessage)

                    attempt.place.coordinate = location.coordinate
                    let radius: CLLocationDistance = self.attemptsUsed == 1 ? 1_000 : 10_000
                    self.setLocation(of: attempt.place, radius: radius)
                } else {
                    self.evaluateAttempts()
                }
            }
        }
    }

    private func setLocation(of place: Place, radius: CLLocationDistance = 1000) {
        self.mapView.setCenter(place.coordinate, regionRadius: radius, animated: false)
        self.mapView.addAnnotation(place)
    }
}

// MARK: - MKMapViewDelegate

extension GameInfoCell: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
    }
}
