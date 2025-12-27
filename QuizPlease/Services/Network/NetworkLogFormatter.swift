//
//  NetworkLogFormatter.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 27.12.2025.
//  Copyright © 2025 Владислав. All rights reserved.
//

import Foundation

/// Общие утилиты форматирования для сетевых логов:
/// - prettyHeaders: красивый вывод хедеров (JSON-подобный, отсортированный), `<empty>` если пусто.
/// - prettyBody: попытка pretty-print JSON тела, иначе UTF-8 строка, `<empty>` если пусто.
/// - getString: простой UTF-8 вывод данных (если нужно без pretty JSON).
final class NetworkLogFormatter {

    private enum Constants {
        static let emptyData: String = "<empty>"
        static let stringRepresentationError: String = "<error>"
    }

    // MARK: - Public API

    static func prettyHeaders(_ headers: [AnyHashable: Any]) -> String {
        prettyHeaders(normalizeHeaders(headers))
    }

    static func prettyHeaders(_ headers: [String: String]) -> String {
        if headers.isEmpty {
            return Constants.emptyData
        }
        guard
            let data = try? JSONSerialization.data(withJSONObject: headers, options: [.prettyPrinted, .sortedKeys]),
            let string = String(data: data, encoding: .utf8)
        else {
            return headers.description
        }
        return string
    }

    static func prettyBody(_ data: Data?) -> String {
        guard let data = data, !data.isEmpty else { return Constants.emptyData }

        // Попробуем JSON
        if let obj = try? JSONSerialization.jsonObject(with: data, options: []),
           JSONSerialization.isValidJSONObject(obj),
           let prettyData = try? JSONSerialization.data(withJSONObject: obj, options: [.prettyPrinted, .sortedKeys]),
           let prettyString = String(data: prettyData, encoding: .utf8) {
            return prettyString
        }

        // Фоллбэк в строку
        return String(data: data, encoding: .utf8) ?? Constants.stringRepresentationError
    }

    static func getString(_ data: Data?) -> String {
        guard let data = data, !data.isEmpty else { return Constants.emptyData }
        return String(data: data, encoding: .utf8) ?? Constants.stringRepresentationError
    }

    // MARK: - Internal

    private static func normalizeHeaders(_ headers: [AnyHashable: Any]) -> [String: String] {
        var result: [String: String] = [:]
        for (key, value) in headers {
            let k = String(describing: key)
            switch value {
            case let s as String:
                result[k] = s
            case let arr as [String]:
                result[k] = arr.joined(separator: ", ")
            default:
                result[k] = String(describing: value)
            }
        }
        return result
    }
}

