//
//  GamePageInfoCell.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 12.04.2023.
//  Copyright © 2023 Владислав. All rights reserved.
//

import UIKit
import MapKit

private enum Constants {

    static let verticalSpacing: CGFloat = 16
    static let horizontalSpacing: CGFloat = 16
    static let infoStackSpacing: CGFloat = 16
    static let mapHeight: CGFloat = 132
}

/// GamePage info cell
final class GamePageInfoCell: UITableViewCell {

    private var tapOnMapAction: (() -> Void)?

    // MARK: - UI Elements

    private let containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 20
        view.backgroundColor = .systemBackgroundAdapted
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.register(
            MapMarkerAnnotationView.self,
            forAnnotationViewWithReuseIdentifier: "\(MapMarkerAnnotationView.self)"
        )
        mapView.addTapGestureRecognizer { [weak self] in
            self?.tapOnMapAction?()
        }
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.delegate = self
        mapView.showsCompass = false
        mapView.isZoomEnabled = false
        mapView.isRotateEnabled = false
        mapView.isScrollEnabled = false
        mapView.isPitchEnabled = false

        return mapView
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        makeLayout()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private Methods

    private func makeLayout() {
        contentView.addSubview(containerView)
        containerView.addSubview(infoStackView)
        containerView.addSubview(mapView)

        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(
                equalTo: contentView.leadingAnchor, constant: Constants.horizontalSpacing),
            containerView.topAnchor.constraint(
                equalTo: contentView.topAnchor, constant: Constants.verticalSpacing),
            containerView.trailingAnchor.constraint(
                equalTo: contentView.trailingAnchor, constant: -Constants.horizontalSpacing),
            containerView.bottomAnchor.constraint(
                equalTo: contentView.bottomAnchor, constant: -Constants.verticalSpacing),

            infoStackView.leadingAnchor.constraint(
                equalTo: containerView.leadingAnchor, constant: Constants.infoStackSpacing),
            infoStackView.topAnchor.constraint(
                equalTo: containerView.topAnchor, constant: Constants.infoStackSpacing),
            infoStackView.trailingAnchor.constraint(
                equalTo: containerView.trailingAnchor, constant: -Constants.infoStackSpacing),

            mapView.topAnchor.constraint(
                equalTo: infoStackView.bottomAnchor, constant: Constants.infoStackSpacing),
            mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            mapView.heightAnchor.constraint(equalToConstant: Constants.mapHeight)
        ])
    }

    private func configureMapView(placeProvider: GamePageInfoPlaceProvider) {
        placeProvider.getPlaceAnnotation { [weak self] place in
            self?.setLocation(of: place)
        }
    }

    private func setLocation(of place: Place, radius: CLLocationDistance = 1000) {
        guard !mapView.annotations.contains(where: { place.isEqual($0) }) else {
            return
        }
        mapView.removeAnnotations(mapView.annotations)
        mapView.setCenter(place.coordinate, regionRadius: radius, animated: false)
        mapView.addAnnotation(place)
    }

    private func addInfo(items: [GamePageInfoLineViewModel]) {
        infoStackView.removeArrangedSubviews()
        for item in items {
            infoStackView.addArrangedSubview(GamePageInfoLineView(viewModel: item))
        }
    }
}

// MARK: - MKMapViewDelegate

extension GamePageInfoCell: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        mapView.deselectAnnotation(view.annotation, animated: true)
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        return mapView.dequeueReusableAnnotationView(MapMarkerAnnotationView.self, for: annotation)
    }
}

// MARK: - GamePageCellProtocol

extension GamePageInfoCell: GamePageCellProtocol {

    func configure(with item: GamePageItemProtocol) {
        guard let item = item as? GamePageInfoItem else { return }
        configureMapView(placeProvider: item.placeProvider)
        addInfo(items: item.infoLines)
        tapOnMapAction = item.tapOnMapAction
    }
}
