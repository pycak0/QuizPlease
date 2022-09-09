//
//  MapViewController.swift
//  QuizPlease
//
//  Created by Владислав on 01.11.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import UIKit
import MapKit
import YooKassaPaymentsApi

/// Output Map View protocol
protocol MapViewOutput: AnyObject {

    /// Map View screen was loaded
    func viewDidLoad()

    /// Map close button pressed
    func didTapClose()

    /// Directions button was pressed
    func didTapDirections(for place: Place)

    /// Zoom-in button pressed
    func zoomInPressed()

    /// Zoom-out button pressed
    func zoomOutPressed()

    /// Location button pressed
    func locationPressed()

    /// Place annotation was tapped on map
    func didTapPlace(_ place: Place)
}

/// Input Map View protocol
protocol MapViewInput: AnyObject {

    /// Center map to given coordinate
    func setCenter(to coordinate: CLLocationCoordinate2D, animated: Bool)

    /// Add place annotation on map and center to this place
    func addPlace(_ place: Place, animated: Bool)

    /// Zoom in map by 2x with animation
    func zoomIn()

    /// Zoom out map by 2x with animation
    func zoomOut()

    /// Toggle user location tracking mode
    ///
    /// This method updates map UI and tracking mode one by one
    /// from not following user location (0) to following it (1) and following with heading (2)
    ///
    /// - Warning: This method does not check and access for tracking user's geolocation.
    func toggleUserTrackingMode(animated: Bool)

    /// Show view with info about given place annotation
    func showInfoView(for place: Place)

    /// Hide info view, if any is opened
    func hideInfoView()
}

final class MapViewController: UIViewController {

    enum Constants {
        static let buttonWidth: CGFloat = 42
        static let spacing: CGFloat = 16
        static let zoomScale: CGFloat = 2
        static let infoPadding: CGFloat = 8
    }

    private let output: MapViewOutput

    // MARK: - UI Elements

    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.isPitchEnabled = false
        mapView.showsUserLocation = true
        mapView.showsCompass = false
        mapView.delegate = self
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()

    private lazy var compassButton: MKCompassButton = {
        let compassButton = MKCompassButton(mapView: mapView)
        compassButton.compassVisibility = .adaptive
        compassButton.translatesAutoresizingMaskIntoConstraints = false
        return compassButton
    }()

    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapClose), for: .touchUpInside)
        button.setImage(.xmark, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let controlsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var plusButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapPlus), for: .touchDown)
        button.setImage(.plus, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var minusButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapMinus), for: .touchDown)
        button.setImage(.minus, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(didTapLocation), for: .touchUpInside)
        button.setImage(.location, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private lazy var infoView: MapInfoView = {
        let infoView = MapInfoView()
        infoView.delegate = self
        infoView.layer.cornerRadius = 12
        infoView.translatesAutoresizingMaskIntoConstraints = false
        return infoView
    }()

    private lazy var infoViewHeight: CGFloat = {
        UIScreen.main.bounds.height / 5
    }()

    /// Buttons on the map
    private var controls: [UIButton] {
        [closeButton, plusButton, minusButton, locationButton]
    }

    // MARK: - Lifecycle

    init(output: MapViewOutput) {
        self.output = output
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
        output.viewDidLoad()
    }

    // MARK: - UI Configuration

    private func configureViews() {
        makeMapConstraints()
        makeCloseButtonConstraints()
        makeCompassConstraints()
        makeControlConstraints()
        makeLocationButtonConstraints()
        configureInfoView()
        configureControls()
    }

    private func makeMapConstraints() {
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func makeCloseButtonConstraints() {
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(
                equalTo: mapView.leadingAnchor,
                constant: Constants.spacing
            ),
            closeButton.topAnchor.constraint(
                equalTo: mapView.layoutMarginsGuide.topAnchor,
                constant: Constants.spacing
            ),
            closeButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            closeButton.heightAnchor.constraint(equalTo: closeButton.widthAnchor)
        ])
    }

    private func makeCompassConstraints() {
        view.addSubview(compassButton)
        NSLayoutConstraint.activate([
            compassButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -Constants.spacing),
            compassButton.centerYAnchor.constraint(equalTo: closeButton.centerYAnchor)
        ])
    }

    private func makeControlConstraints() {
        [plusButton, minusButton].forEach {
            $0.heightAnchor.constraint(equalToConstant: Constants.buttonWidth).isActive = true
            controlsStackView.addArrangedSubview($0)
        }
        view.addSubview(controlsStackView)
        NSLayoutConstraint.activate([
            controlsStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            controlsStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.spacing),
            controlsStackView.widthAnchor.constraint(equalToConstant: Constants.buttonWidth)
        ])
    }

    private func makeLocationButtonConstraints() {
        view.addSubview(locationButton)
        NSLayoutConstraint.activate([
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.spacing),
            locationButton.widthAnchor.constraint(equalToConstant: Constants.buttonWidth),
            locationButton.heightAnchor.constraint(equalTo: locationButton.widthAnchor),
            locationButton.topAnchor.constraint(
                equalTo: controlsStackView.bottomAnchor,
                constant: Constants.spacing * 5
            )
        ])
    }

    private func configureInfoView() {
        view.addSubview(infoView)
        NSLayoutConstraint.activate([
            infoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.infoPadding),
            infoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.infoPadding),
            infoView.bottomAnchor.constraint(
                equalTo: view.layoutMarginsGuide.bottomAnchor,
                constant: -Constants.infoPadding
            )
        ])
    }

    private func configureControls() {
        controls.forEach {
            $0.backgroundColor = .systemBackgroundAdapted
            $0.layer.cornerRadius = Constants.buttonWidth / 2
            $0.tintColor = .labelAdapted
        }
    }

    private func updateLocationButtonImage(for mode: MKUserTrackingMode) {
        if #available(iOS 13.0, *) {
            locationButton.setImage(mode.icon, for: .normal)
        }
    }

    // MARK: - Private Methods

    private func setUserTrackingMode(_ mode: MKUserTrackingMode, animated: Bool) {
        mapView.setUserTrackingMode(mode, animated: animated)
        updateLocationButtonImage(for: mode)
    }

    // MARK: - Actions

    @objc private func didTapClose() {
        output.didTapClose()
    }

    @objc private func didTapPlus() {
        output.zoomInPressed()
    }

    @objc private func didTapMinus() {
        output.zoomOutPressed()
    }

    @objc private func didTapLocation() {
        output.locationPressed()
    }
}

// MARK: - MapViewInput

extension MapViewController: MapViewInput {

    func setCenter(to coordinate: CLLocationCoordinate2D, animated: Bool) {
        let location = CLLocation(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
        mapView.setCenter(location, regionRadius: 1_000, animated: animated)
    }

    func addPlace(_ place: Place, animated: Bool) {
        mapView.addAnnotation(place)
        mapView.showAnnotations([place], animated: animated)
    }

    func zoomIn() {
        setUserTrackingMode(.none, animated: false)
        mapView.setZoom(scale: Constants.zoomScale, animated: true)
    }

    func zoomOut() {
        setUserTrackingMode(.none, animated: false)
        mapView.setZoom(scale: 1 / Constants.zoomScale, animated: true)
    }

    func toggleUserTrackingMode(animated: Bool) {
        let newValue = (mapView.userTrackingMode.rawValue + 1) % 3
        guard let mode = MKUserTrackingMode(rawValue: newValue) else { return }
        setUserTrackingMode(mode, animated: animated)
    }

    func showInfoView(for place: Place) {
        infoView.place = place
        infoView.show(animated: true)
        mapView.showAnnotations([place], animated: true)
    }

    func hideInfoView() {
        infoView.hide(animated: true) { [self] in
            mapView.deselectAnnotation(infoView.place, animated: true)
            infoView.place = nil
        }
    }
}

// MARK: - MKMapViewDelegate

extension MapViewController: MKMapViewDelegate {

    func mapView(_ mapView: MKMapView, didChange mode: MKUserTrackingMode, animated: Bool) {
        updateLocationButtonImage(for: mode)
    }

    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? Place else { return }
        output.didTapPlace(annotation)
    }

    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        hideInfoView()
    }
}

// MARK: - MapInfoViewDelegate

extension MapViewController: MapInfoViewDelegate {
    func userLocation() -> CLLocation? {
        mapView.userLocation.location
    }

    func mapInfoViewDidPressDirections(_ mapInfoView: MapInfoView) {
        guard let place = mapInfoView.place else { return }
        output.didTapDirections(for: place)
    }

    func mapInfoViewDidPressClose(_ mapInfoView: MapInfoView) {
        hideInfoView()
    }

    func mapInfoViewDidSwipeToClose(_ mapInfoView: MapInfoView) {
        hideInfoView()
    }
}

// MARK: - MKUserTrackingMode + Icon

private extension MKUserTrackingMode {

    @available(iOS 13.0, *)
    var icon: UIImage? {
        let name: String
        switch self {
        case .none:
            name = "location"
        case .follow:
            name = "location.fill"
        case .followWithHeading:
            name = "location.north.line.fill"
        @unknown default:
            name = "location"
        }
        return UIImage(systemName: name)
    }
}
