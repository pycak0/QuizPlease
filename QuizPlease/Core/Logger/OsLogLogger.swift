//
//  OsLogLogger.swift
//  QuizPlease
//
//  Created by Assistant on 27.12.2025.
//

import Foundation
import os

/// Logger based on os.Logger.
/// - Groups logs by source file (category from file name) within the app’s subsystem (bundle ID by default).
/// - Supports levels: `debug`, `info`, `warn`, `error`.
/// - Lightweight and thread-safe; suitable for use across the app.
final class OsLogLogger: Logger {

    enum Level: String {
        case debug = "DEBUG"
        case info  = "INFO"
        case warn  = "WARN"
        case error = "ERROR"
    }

    private let subsystem: String

    // Local timestamp with milliseconds, cached and thread-safe enough for logging use.
    private static let timestampFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        return f
    }()

    init(subsystem: String = Bundle.main.bundleIdentifier ?? "QuizPlease") {
        self.subsystem = subsystem
    }

    private func category(from file: StaticString) -> String {
        // Преобразуем путь файла в короткое имя, например "RatingInteractor"
        let full = String(describing: file)
        let last = full.split(separator: "/").last.map(String.init) ?? full
        return last.replacingOccurrences(of: ".swift", with: "")
    }

    private func makeLogger(file: StaticString) -> os.Logger {
        os.Logger(subsystem: subsystem, category: category(from: file))
    }

    private func shortFunctionName(from function: StaticString) -> String {
        // Пример входа: "get(_:apiPath:parameters:headers:authorizationKind:networkConfiguration:completion:)"
        // или "UsersAPI.get(_:apiPath:...)".
        // Берём строку до "(" и отрезаем всё до последней точки, чтобы получить короткое имя: "get".
        let full = String(describing: function)
        let beforeParen = full.split(separator: "(").first.map(String.init) ?? full
        if let lastDot = beforeParen.lastIndex(of: ".") {
            return String(beforeParen[beforeParen.index(after: lastDot)...])
        }
        return beforeParen
    }

    private func fileName(from file: StaticString) -> String {
        let full = String(describing: file)
        let last = full.split(separator: "/").last.map(String.init) ?? full
        return last
    }

    private func timestampNow() -> String {
        OsLogLogger.timestampFormatter.string(from: Date())
    }

    private func format(level: Level,
                        message: String,
                        file: StaticString,
                        function: StaticString,
                        line: UInt) -> String {
        let ts = timestampNow()
        let filePart = "\(fileName(from: file)):\(line)"
        let fn = shortFunctionName(from: function)
        // Пример: "2025-12-27 21:03:12.345 [INFO] [UsersAPI.swift:66 get] REQUEST ..."
        return "\(ts) [\(level.rawValue)] [\(filePart) \(fn)] \(message)"
    }

    func debug(_ message: String,
               file: StaticString, function: StaticString, line: UInt) {
        let logger = makeLogger(file: file)
        let formatted = format(level: .debug, message: message, file: file, function: function, line: line)
        logger.debug("\(formatted, privacy: .public)")
    }

    func info(_ message: String,
              file: StaticString, function: StaticString, line: UInt) {
        let logger = makeLogger(file: file)
        let formatted = format(level: .info, message: message, file: file, function: function, line: line)
        logger.info("\(formatted, privacy: .public)")
    }

    func warn(_ message: String,
              file: StaticString, function: StaticString, line: UInt) {
        let logger = makeLogger(file: file)
        let formatted = format(level: .warn, message: message, file: file, function: function, line: line)
        logger.warning("\(formatted, privacy: .public)")
    }

    func error(_ message: String,
               file: StaticString, function: StaticString, line: UInt) {
        let logger = makeLogger(file: file)
        let formatted = format(level: .error, message: message, file: file, function: function, line: line)
        logger.error("\(formatted, privacy: .public)")
    }
}
