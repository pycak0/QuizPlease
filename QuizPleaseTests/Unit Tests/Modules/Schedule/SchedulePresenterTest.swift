//
//  SchedulePresenterTest.swift
//  QuizPleaseTests
//
//  Created by Codex on 10.06.2026.
//

@testable import QuizPlease
import UIKit
import XCTest

final class SchedulePresenterTest: XCTestCase {

    private var interactor: ScheduleInteractorMock!
    private var router: ScheduleRouterMock!
    private var analytics: AnalyticsServiceMock!
    private var view: ScheduleViewMock!
    private var presenter: SchedulePresenter!

    override func setUp() {
        super.setUp()
        interactor = ScheduleInteractorMock()
        router = ScheduleRouterMock()
        analytics = AnalyticsServiceMock()
        view = ScheduleViewMock()
        presenter = SchedulePresenter(
            interactor: interactor,
            router: router,
            analyticsService: analytics
        )
        presenter.view = view
        view.presenter = presenter
    }

    override func tearDown() {
        presenter = nil
        view = nil
        analytics = nil
        router = nil
        interactor = nil
        super.tearDown()
    }

    func testViewDidLoadLoadsFirstPageOnlyAndNextPageNearEnd() {
        interactor.scheduleResults = [
            .success(SchedulePage(games: makeGames(ids: 1...30), hasMore: true)),
            .success(SchedulePage(games: makeGames(ids: 31...32), hasMore: false))
        ]

        presenter.viewDidLoad(view)

        XCTAssertEqual(interactor.loadScheduleRequests.map(\.page), [1])
        XCTAssertEqual(presenter.gamesCount, 30)
        XCTAssertEqual(view.reloadScheduleListCallCount, 1)

        presenter.didDisplayGame(at: 10)

        XCTAssertEqual(interactor.loadScheduleRequests.map(\.page), [1])

        presenter.didDisplayGame(at: 29)

        XCTAssertEqual(interactor.loadScheduleRequests.map(\.page), [1, 2])
        XCTAssertEqual(presenter.gamesCount, 32)
        XCTAssertEqual(view.reloadScheduleListCallCount, 2)
    }

    func testDoesNotLoadMoreAfterLastPage() {
        interactor.scheduleResults = [
            .success(SchedulePage(games: makeGames(ids: 1...2), hasMore: false))
        ]

        presenter.viewDidLoad(view)
        presenter.didDisplayGame(at: 1)

        XCTAssertEqual(interactor.loadScheduleRequests.map(\.page), [1])
        XCTAssertEqual(presenter.gamesCount, 2)
    }

    func testChangingFilterResetsPagination() {
        interactor.scheduleResults = [
            .success(SchedulePage(games: makeGames(ids: 1...30), hasMore: true)),
            .success(SchedulePage(games: makeGames(ids: 31...32), hasMore: false)),
            .success(SchedulePage(games: makeGames(ids: 101...102), hasMore: false))
        ]

        presenter.viewDidLoad(view)
        presenter.didDisplayGame(at: 29)
        presenter.didChangeScheduleFilter(newFilter: ScheduleFilter())

        XCTAssertEqual(interactor.loadScheduleRequests.map(\.page), [1, 2, 1])
        XCTAssertEqual(presenter.gamesCount, 2)
    }

    private func makeGames(ids: ClosedRange<Int>) -> [GameInfo] {
        ids.map { id in
            var game = GameInfo()
            game.id = "game-\(id)"
            return game
        }
    }
}

private final class ScheduleInteractorMock: ScheduleInteractorProtocol {

    weak var output: ScheduleInteractorOutput?
    var scheduleResults: [Result<SchedulePage, NetworkServiceError>] = []
    private(set) var loadScheduleRequests: [(filter: ScheduleFilter, page: Int)] = []

    func loadSchedule(
        filter: ScheduleFilter,
        page: Int,
        completion: @escaping (Result<SchedulePage, NetworkServiceError>) -> Void
    ) {
        loadScheduleRequests.append((filter: filter, page: page))

        guard !scheduleResults.isEmpty else {
            XCTFail("Unexpected schedule loading")
            return
        }

        completion(scheduleResults.removeFirst())
    }

    func loadDetailInfo(for game: GameInfo, completion: @escaping (GameInfo?) -> Void) {
        XCTFail("Unexpected detail info loading")
    }

    func getSubscribeStatus(gameId: String) {
        XCTFail("Unexpected subscribe status request")
    }

    func getSubscribedGameIds(completion: @escaping ((Set<String>) -> Void)) {
        completion([])
    }

    func getExtraInfoText(completion: @escaping (AlertData?) -> Void) {
        XCTFail("Unexpected extra info request")
    }
}

private final class ScheduleRouterMock: ScheduleRouterProtocol {

    let viewController = UIViewController()

    func prepare(for segue: UIStoryboardSegue, sender: Any?) { }

    func showGameInfo(with options: GamePageLaunchOptions) {
        XCTFail("Unexpected game page route")
    }

    func showScheduleFilters(with filterInfo: ScheduleFilter) {
        XCTFail("Unexpected filters route")
    }

    func showWarmup(popCurrent: Bool) {
        XCTFail("Unexpected warmup route")
    }

    func showHomeGame(popCurrent: Bool) {
        XCTFail("Unexpected home game route")
    }

    func showMap(for place: Place) {
        XCTFail("Unexpected map route")
    }

    func close() {
        XCTFail("Unexpected close route")
    }
}

private final class AnalyticsServiceMock: AnalyticsService {

    private(set) var sentEvents: [AnalyticsEvent] = []

    func sendEvent(_ event: AnalyticsEvent) {
        sentEvents.append(event)
    }
}

private final class ScheduleViewMock: UIViewController, ScheduleViewProtocol {

    var presenter: SchedulePresenterProtocol!
    private(set) var reloadScheduleListCallCount = 0
    private(set) var startLoadingCallCount = 0
    private(set) var stopLoadingCallCount = 0
    private(set) var noGamesText: String?
    private(set) var titleText: String?

    func reloadScheduleList() {
        reloadScheduleListCallCount += 1
    }

    func reloadGame(at index: Int) { }

    func showNoGamesInSchedule(text: String, links: [TextLink]) {
        noGamesText = text
    }

    func configure() { }

    func changeSubscribeStatus(forGameAt index: Int) { }

    func setTitle(_ title: String) {
        titleText = title
    }

    func startLoading() {
        startLoadingCallCount += 1
    }

    func stopLoading() {
        stopLoadingCallCount += 1
    }
}
