//
//  RatingInteractor.swift
//  QuizPlease
//
//  Created by Владислав on 04.08.2020.
//  Copyright © 2020 Владислав. All rights reserved.
//

import Foundation

private enum RatingInteractorConstants {
    static let ratingItemsPerPage: Int = 20
}

protocol RatingInteractorProtocol {
    /// must be weak
    var output: RatingInteractorOutput? { get set }
    func loadRating(with filter: RatingFilter, page: Int, delay: Double)
    func loadLeagues()
    func cancelLoading()
}

protocol RatingInteractorOutput: AnyObject {
    func interactor(_ interactor: RatingInteractorProtocol, errorOccured error: NetworkServiceError)
    func interactor(_ interactor: RatingInteractorProtocol, didLoadRatingItems ratingItems: [RatingTeamItemData])
    func interactor(_ interactor: RatingInteractorProtocol, didLoadLeagues leagues: [RatingLeagueData])
}

class RatingInteractor: RatingInteractorProtocol {
    private var timer: Timer?
    private var runningTasks = [Cancellable?]()
    weak var output: RatingInteractorOutput?

    private let networkService: NetworkServiceProtocol
    private let log: Logger

    init(
        networkService: NetworkServiceProtocol,
        log: Logger
    ) {
        self.networkService = networkService
        self.log = log
    }

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

    func loadLeagues() {
        let token = networkService.get(
            RatingLeagueResponseData.self,
            apiPath: ApiConstants.Path.ratingExternal,
            parameters: nil,
            headers: nil,
            authorizationKind: .none,
            networkConfiguration: .rating
        ) { [weak self] result in
            guard let self else { return }
            switch result {
            case let .failure(error):
                self.output?.interactor(self, errorOccured: error)
            case let .success(data):
                self.output?.interactor(self, didLoadLeagues: data.result)
            }
        }
        runningTasks.append(token)
    }

    private func _loadRating(with filter: RatingFilter, page: Int) {
        let isSeason = filter.scope == .season

        var parameters: [String: String?] = [
            "city": "\(filter.city.slug)",
            "bySeason": "\(isSeason)",
            "page": "\(page)",
            "perPage": "\(RatingInteractorConstants.ratingItemsPerPage)",
            "order": "points",
            "orderBy": "desc",
            "title": filter.teamName
        ]

        if let leagueId = filter.league?.id {
            parameters["rating"] = "\(leagueId)"
        } else {
            log.warn("leagueId is nil")
        }

        let token = networkService.get(
            RatingTeamResponseData.self,
            apiPath: ApiConstants.Path.ratingTeamsExternal,
            parameters: parameters,
            headers: nil,
            authorizationKind: .none,
            networkConfiguration: .rating
        ) { [weak self] (serverResult) in
            guard let self = self else { return }
            switch serverResult {
            case let .failure(error):
                self.output?.interactor(self, errorOccured: error)
            case let .success(data):
                self.processSuccessResponse(data)
            }
        }

        runningTasks.append(token)
    }

    private func processSuccessResponse(_ data: RatingTeamResponseData) {
        let items = data.result
        output?.interactor(self, didLoadRatingItems: items)
    }
}
