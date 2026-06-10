//
//  ScheduleInteractorTest.swift
//  QuizPleaseTests
//
//  Created by Codex on 10.06.2026.
//

@testable import QuizPlease
import XCTest

final class ScheduleInteractorTest: XCTestCase {

    private var networkServiceMock: ScheduleNetworkServiceMock!
    private var interactor: ScheduleInteractor!

    override func setUp() {
        super.setUp()
        networkServiceMock = ScheduleNetworkServiceMock()
        interactor = ScheduleInteractor(
            networkService: networkServiceMock,
            gameInfoLoader: GameInfoLoaderStub(),
            userService: UserServiceStub()
        )
    }

    override func tearDown() {
        interactor = nil
        networkServiceMock = nil
        super.tearDown()
    }

    func testLoadScheduleRequestsSpecifiedPage() throws {
        let pageIds = (1...30).map { "game-\($0)" }
        networkServiceMock.getResults = [
            .success(try makeResponse(ids: pageIds))
        ]

        let result = loadSchedule(filter: try makeFilter(), page: 3)
        let schedulePage = try result.get()

        XCTAssertEqual(schedulePage.games.map(\.id), pageIds)
        XCTAssertTrue(schedulePage.hasMore)
        XCTAssertEqual(networkServiceMock.getRequests.count, 1)
        XCTAssertEqual(networkServiceMock.getRequests[0].parameter("page"), "3")
        XCTAssertEqual(networkServiceMock.getRequests[0].parameter("per_page"), "30")
    }

    func testLoadScheduleReturnsNoMorePagesWhenPageIsPartial() throws {
        networkServiceMock.getResults = [
            .success(try makeResponse(ids: ["game-1", "game-2"]))
        ]

        let result = loadSchedule(filter: try makeFilter(), page: 1)
        let schedulePage = try result.get()

        XCTAssertFalse(schedulePage.hasMore)
        XCTAssertEqual(schedulePage.games.map(\.id), ["game-1", "game-2"])
    }

    func testLoadScheduleKeepsFilterParameters() throws {
        networkServiceMock.getResults = [
            .success(try makeResponse(ids: []))
        ]

        _ = loadSchedule(filter: try makeFilter(), page: 1)

        let request = try XCTUnwrap(networkServiceMock.getRequests.first)
        XCTAssertEqual(request.apiPath, ApiConstants.Path.game)
        XCTAssertEqual(request.parameter("city_id"), "99")
        XCTAssertEqual(request.parameter("isMobile"), "1")
        XCTAssertEqual(request.parameter("order"), "date")
        XCTAssertEqual(request.parameter("month"), "1")
        XCTAssertEqual(request.parameter("formats[]"), "2")
        XCTAssertEqual(request.parameter("places[]"), "3")
        XCTAssertEqual(request.parameter("statuses[]"), "4")
        XCTAssertEqual(request.parameter("game_types[]"), "5")
    }

    func testLoadScheduleReturnsFailureWhenPageFails() throws {
        networkServiceMock.getResults = [
            .failure(.serverError(500))
        ]

        let result = loadSchedule(filter: try makeFilter(), page: 2)

        switch result {
        case .failure(.serverError(500)):
            break
        default:
            XCTFail("Expected serverError(500), got \(result)")
        }
        XCTAssertEqual(networkServiceMock.getRequests.count, 1)
        XCTAssertEqual(networkServiceMock.getRequests[0].parameter("page"), "2")
    }

    private func loadSchedule(
        filter: ScheduleFilter,
        page: Int
    ) -> Result<SchedulePage, NetworkServiceError> {
        let expectation = expectation(description: "Schedule loaded")
        var actualResult: Result<SchedulePage, NetworkServiceError>?

        interactor.loadSchedule(filter: filter, page: page) { result in
            actualResult = result
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 1)
        return actualResult ?? .failure(.serverError(-1))
    }

    private func makeFilter() throws -> ScheduleFilter {
        let date = try makeFilterOption(id: "1")
        let format = try makeFilterOption(id: "2")
        let type = try makeFilterOption(id: "5")
        let place = try makeFilterOption(id: "3")
        let status = try makeFilterOption(id: "4")

        return ScheduleFilter(
            city: City(id: 99, title: "Test City", slug: "test-city"),
            date: date,
            format: format,
            type: type,
            place: place,
            status: status
        )
    }

    private func makeFilterOption(id: String) throws -> ScheduleFilterOption {
        let json = #"{"id":"\#(id)","title":"Option"}"#
        let data = Data(json.utf8)
        return try JSONDecoder().decode(ScheduleFilterOption.self, from: data)
    }

    private func makeResponse(ids: [String]) throws -> ServerResponse<ScheduledGamesResponse> {
        let games = ids
            .map { #"{"id":"\#($0)","datetime":"10.06.26 08:00"}"# }
            .joined(separator: ",")
        let json = #"{"data":{"data":[\#(games)]}}"#
        let data = Data(json.utf8)
        return try JSONDecoder().decode(ServerResponse<ScheduledGamesResponse>.self, from: data)
    }
}

private final class ScheduleNetworkServiceMock: NetworkServiceProtocol {

    struct GetRequest {
        let apiPath: String
        let parameters: [String: String?]

        func parameter(_ name: String) -> String? {
            parameters[name] ?? nil
        }
    }

    var getResults: [Result<ServerResponse<ScheduledGamesResponse>, NetworkServiceError>] = []
    private(set) var getRequests: [GetRequest] = []

    // swiftlint:disable function_parameter_count
    func get<T>(
        _ type: T.Type,
        apiPath: String,
        parameters: [String: String?]?,
        headers: [String: String]?,
        authorizationKind: NetworkService.AuthorizationKind,
        networkConfiguration: NetworkConfiguration,
        completion: @escaping ((Result<T, NetworkServiceError>) -> Void)
    ) -> Cancellable? where T: Decodable {
        getRequests.append(GetRequest(apiPath: apiPath, parameters: parameters ?? [:]))

        guard !getResults.isEmpty else {
            XCTFail("Unexpected GET request")
            return nil
        }

        let result = getResults.removeFirst()
        switch result {
        case let .success(response):
            guard let typedResponse = response as? T else {
                XCTFail("Unexpected response type: \(type)")
                return nil
            }
            completion(.success(typedResponse))
        case let .failure(error):
            completion(.failure(error))
        }

        return nil
    }

    func afPost<Response>(
        with bodyParameters: [String: String?],
        queryParameters: [String: String?]?,
        and headers: [String: String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) where Response: Decodable {
        XCTFail("Unexpected POST request")
    }

    func afPost<Response>(
        with multipartFormDataObjects: MultipartFormDataObjects,
        queryParameters: [String: String?]?,
        and headers: [String: String]?,
        to apiPath: String,
        responseType: Response.Type,
        authorizationKind: NetworkService.AuthorizationKind,
        completion: @escaping (Result<Response, NetworkServiceError>) -> Void
    ) where Response: Decodable {
        XCTFail("Unexpected multipart POST request")
    }

    func post<Object, Response>(
        _ object: Object,
        apiPath: String,
        parameters: [String: String?]?,
        headers: [String: String]?,
        authorizationKind: NetworkService.AuthorizationKind,
        reponseType: Response.Type,
        completion: @escaping ((Result<Response, NetworkServiceError>) -> Void)
    ) -> Cancellable? where Object: Encodable, Response: Decodable {
        XCTFail("Unexpected JSON POST request")
        return nil
    }
    // swiftlint:enable function_parameter_count
}

private final class GameInfoLoaderStub: GameInfoLoader {

    func load(gameId: String, completion: @escaping (Result<GameInfo, Error>) -> Void) {
        XCTFail("Unexpected game info loading")
    }

    func getCachedGame(gameId: String) -> GameInfo? {
        nil
    }
}

private final class UserServiceStub: UserService {

    var isloggedIn: Bool { false }

    func getUserInfo(completion: @escaping (Result<UserInfo, NetworkServiceError>) -> Void) {
        XCTFail("Unexpected user info request")
    }

    func loadUserInfo(completion: @escaping (Result<UserInfo, NetworkServiceError>) -> Void) {
        XCTFail("Unexpected user info loading")
    }

    func deleteAccount(completion: @escaping (Result<Void, NetworkServiceError>) -> Void) {
        XCTFail("Unexpected account deletion")
    }

    func updateToken(completion: (() -> Void)?) {
        XCTFail("Unexpected token update")
    }

    func logout() {
        XCTFail("Unexpected logout")
    }
}
