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
    func cancelLoading()
}

protocol RatingInteractorOutput: AnyObject {
    func interactor(_ interactor: RatingInteractorProtocol, errorOccured error: NetworkServiceError)
    func interactor(_ interactor: RatingInteractorProtocol, didLoadRatingItems ratingItems: [RatingTeamItemData])
}

class RatingInteractor: RatingInteractorProtocol {
    private var timer: Timer?
    private var runningTasks = [Cancellable?]()
    weak var output: RatingInteractorOutput?

    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
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

    private func _loadRating(with filter: RatingFilter, page: Int) {
        let isSeason = filter.scope == .season

        // rank=legends&bySeason=false&page=1&perPage=10&order=points&orderBy=desc
        var parameters: [String: String?] = [
            "city": "\(filter.city.slug)",
            "rating": "\(filter.league.rawValue)",
            "bySeason": "\(isSeason)",
            "page": "\(page)",
            "perPage": "\(RatingInteractorConstants.ratingItemsPerPage)",
            "order": "points",
            "orderBy": "desc",
            "rank": "legends"
        ]

        if !filter.teamName.isEmpty {
            parameters["title"] = filter.teamName
        }

        let token = networkService.get(
            RatingTeamResponseData.self,
            apiPath: ApiConstants.Path.ratingTeams,
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
