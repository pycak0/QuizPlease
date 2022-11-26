//
//  DeeplinkParser.swift
//  QuizPlease
//
//  Created by Владислав on 02.10.2022.
//  Copyright © 2022 Владислав. All rights reserved.
//

import Foundation

/// Service that parses URL (deeplink or universal link) to  `DeeplinkKind`
protocol DeeplinkParser {

    /// Parse URL
    /// - Parameter url: URL (deeplink or universal link)
    /// - Returns: `DeeplinkKind` instance, if could parse the provided URL. Otherwise, returns `nil`.
    func parse(url: URL) -> Applink?
}

/// Class that implements service that parses URL (deeplink or universal link) to  `DeeplinkKind`
final class DeeplinkParserImpl: DeeplinkParser {

    // MARK: - DeeplinkParser

    func parse(url: URL) -> Applink? {
        guard let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            return nil
        }
        let queryDictionary = urlComponents.queryDictionary ?? [:]
        var endpoint: String?
        let path = urlComponents.path
        var pathComponents = urlComponents.path.components(separatedBy: "/").filter { !$0.isEmpty }

        if url.scheme == "quizplease" {
            // deeplnik, i.e. quizplease://<...>
            endpoint = urlComponents.host
        } else {
            // univeresal link, i.e. https://hostname/<...>
            if !pathComponents.isEmpty {
                endpoint = pathComponents.removeFirst()
            }
        }

        guard let endpoint = endpoint, !endpoint.isEmpty else {
            return nil
        }

        return parseLink(
            endpoint: endpoint,
            pathComponents: pathComponents,
            queryDictionary: queryDictionary
        )
    }

    // MARK: - Private Methods

    private func parseLink(
        endpoint: String,
        pathComponents: [String],
        queryDictionary: [String: String?]
    ) -> Applink? {

        var parameters = queryDictionary as? [String: String] ?? [:]

        switch endpoint {
        case "schedule":
            break

        case "game":
            if let gameId = pathComponents.first {
                parameters["gameId"] = gameId
            }

        default:
            return nil
        }

        return Applink(identifier: endpoint, parameters: parameters)
    }
}
