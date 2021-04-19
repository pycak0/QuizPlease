//
//  RatingInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol RatingInteractorProtocol {
    ///must be weak
    var output: RatingInteractorOutput? { get set }
    func loadRating(with filter: RatingFilter, page: Int)
    func cancelLoading()
}

protocol RatingInteractorOutput: class {
    func interactor(_ interactor: RatingInteractorProtocol, errorOccured error: SessionError)
    func interactor(_ interactor: RatingInteractorProtocol, didLoadRatingItems ratingItems: [RatingItem])
}

class RatingInteractor: RatingInteractorProtocol {
    private var timer: Timer?
    weak var output: RatingInteractorOutput?
    
    func cancelLoading() {
        timer?.invalidate()
    }
    
    func loadRating(with filter: RatingFilter, page: Int) {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { _ in
            self._loadRating(with: filter, page: page)
        }
    }
    
    private func _loadRating(with filter: RatingFilter, page: Int) {
        NetworkService.shared.getRating(
            cityId: filter.city.id,
            teamName: filter.teamName,
            league: filter.league.rawValue,
            ratingScope: filter.scope.rawValue,
            page: page
        ) { (serverResult) in
            switch serverResult {
            case let .failure(error):
                self.output?.interactor(self, errorOccured: error)
            case let .success(items):
                self.output?.interactor(self, didLoadRatingItems: items)
            }
        }
    }
}
