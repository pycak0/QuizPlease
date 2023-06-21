//
//  MapPresenter.swift
//  QuizPlease
//
//  Created by Владислав on 01.11.2021.
//  Copyright © 2021 Владислав. All rights reserved.
//

import Foundation

final class MapPresenter {

    /// Map Screen
    weak var view: MapViewInput?

    /// Map Interactor
    private let interactor: MapInteractorInput

    /// Map Router
    private let router: MapRouterProtocol

    // MARK: - Lifecycle

    init(
        interactor: MapInteractorInput,
        router: MapRouterProtocol
    ) {
        self.interactor = interactor
        self.router = router
    }
}

// MARK: - MapViewOutput

extension MapPresenter: MapViewOutput {

    func viewDidLoad() {
        interactor.getPlaceAnnotation { [weak self] place in
            self?.view?.addPlace(place, animated: false)
        }
    }

    func didTapClose() {
        router.close()
    }

    func didTapDirections(for place: Place) {
        router.openMapWithRoute(to: place)
    }

    func zoomInPressed() {
        view?.zoomIn()
    }

    func zoomOutPressed() {
        view?.zoomOut()
    }

    func locationPressed() {
        interactor.requestLocationAuthorizationStatus { [weak view] isGranted in
            if isGranted {
                view?.toggleUserTrackingMode(animated: true)
            }
        }
    }

    func didTapPlace(_ place: Place) {
        view?.showInfoView(for: place)
    }
}
