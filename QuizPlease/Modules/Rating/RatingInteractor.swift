//
//  RatingInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

protocol RatingInteractorProtocol {
    /// must be weak
    var output: RatingInteractorOutput? { get set }
    func loadRating(with filter: RatingFilter, page: Int, delay: Double)
    func cancelLoading()
}

protocol RatingInteractorOutput: AnyObject {
    func interactor(_ interactor: RatingInteractorProtocol, errorOccured error: NetworkServiceError)
    func interactor(_ interactor: RatingInteractorProtocol, didLoadRatingItems ratingItems: [RatingTeamItem])
}

class RatingInteractor: RatingInteractorProtocol {
    private var timer: Timer?
    private var runningTasks = [Cancellable?]()
    weak var output: RatingInteractorOutput?

    func cancelLoading() {
        timer?.invalidate()
        runningTasks.forEach { $0?.cancel() }
        runningTasks.removeAll()
    }

    func loadRating(with filter: RatingFilter, page: Int, delay: Double) {
        cancelLoading()
        timer = Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { [weak self] _ in
            self?._loadRating(with: filter, page: page)
        }
    }

    private func _loadRating(with filter: RatingFilter, page: Int) {
        let token = NetworkService.shared.getRating(
            cityId: filter.city.id,
            teamName: filter.teamName,
            league: filter.league.rawValue,
            ratingScope: filter.scope.rawValue,
            page: page
        ) { [weak self] (serverResult) in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                self.output?.interactor(self, errorOccured: error)
            case let .success(items):
                self.output?.interactor(self, didLoadRatingItems: items)
            }
        }
        runningTasks.append(token)
    }
}
