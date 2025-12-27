//
//  Logger.swift
//  QuizPlease
//
//  Created by Русаков Владислав Андреевич on 27.12.2025.
//  Copyright © 2025 Владислав. All rights reserved.
//

/// A simple logging abstraction that defines methods for emitting messages at various severity levels.
///
/// Conforming types provide concrete logging behavior (e.g., printing to console, forwarding to a logging framework,
/// persisting to files, or sending to remote backends). Each method accepts contextual information (file, function,
/// and line) to aid in diagnosing issues and tracing execution.
///
/// Usage:
/// - Prefer calling the convenience overloads (usually provided via an extension) that default `file`, `function`,
///   and `line` using `#file`, `#function`, and `#line`.
/// - Use the appropriate severity to reflect intent:
///   - `debug`: Verbose details useful during development and troubleshooting.
///   - `info`: High‑level, expected operational messages.
///   - `warn`: Potentially problematic situations that are not necessarily errors.
///   - `error`: Failures or conditions that require attention.
///
/// Thread-safety:
/// - Conforming implementations should document whether calls are thread-safe and handle synchronization if needed.
///
/// - Parameters:
///   - message: The textual content to be logged. Keep messages concise and prefer structured data when available.
///   - file: The source file where the log originates (commonly defaulted to `#file`).
///   - function: The function or method name where the log originates (commonly defaulted to `#function`).
///   - line: The line number in the source file where the log is emitted (commonly defaulted to `#line`).
///
/// - Note: Consider redacting or omitting sensitive information (PII, credentials, tokens) from log messages.
protocol Logger {
    /// Logs a verbose diagnostic message intended primarily for development and troubleshooting.
    /// Use for fine‑grained details that help trace execution flow without indicating a problem.
    /// - Parameters:
    ///   - message: The debug message to log.
    ///   - file: The source file where the log originates (defaults to `#file` in convenience overloads).
    ///   - function: The function name where the log originates (defaults to `#function`).
    ///   - line: The line number where the log is emitted (defaults to `#line`).
    func debug(_ message: String,
               file: StaticString, function: StaticString, line: UInt)

    /// Logs an informational message that describes expected application events or state transitions.
    /// Use for high‑level operational messages that are useful in normal operation.
    /// - Parameters:
    ///   - message: The informational message to log.
    ///   - file: The source file where the log originates (defaults to `#file` in convenience overloads).
    ///   - function: The function name where the log originates (defaults to `#function`).
    ///   - line: The line number where the log is emitted (defaults to `#line`).
    func info(_ message: String,
              file: StaticString, function: StaticString, line: UInt)

    /// Logs a warning about an unexpected or potentially problematic situation that didn’t prevent operation.
    /// Use to flag conditions that may require attention but are not errors.
    /// - Parameters:
    ///   - message: The warning message to log.
    ///   - file: The source file where the log originates (defaults to `#file` in convenience overloads).
    ///   - function: The function name where the log originates (defaults to `#function`).
    ///   - line: The line number where the log is emitted (defaults to `#line`).
    func warn(_ message: String,
              file: StaticString, function: StaticString, line: UInt)

    /// Logs an error indicating a failure or a condition that requires immediate attention or handling.
    /// Use when an operation fails or the app encounters an unrecoverable issue.
    /// - Parameters:
    ///   - message: The error message to log.
    ///   - file: The source file where the log originates (defaults to `#file` in convenience overloads).
    ///   - function: The function name where the log originates (defaults to `#function`).
    ///   - line: The line number where the log is emitted (defaults to `#line`).
    func error(_ message: String,
               file: StaticString, function: StaticString, line: UInt)
}

extension Logger {
    func debug(_ message: String,
               file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        debug(message, file: file, function: function, line: line)
    }
    func info(_ message: String,
              file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        info(message, file: file, function: function, line: line)
    }
    func warn(_ message: String,
              file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        warn(message, file: file, function: function, line: line)
    }

    func error(_ message: String,
               file: StaticString = #file, function: StaticString = #function, line: UInt = #line) {
        error(message, file: file, function: function, line: line)
    }
    func error(_ message: String) {
        error(message, file: #file, function: #function, line: #line)
    }
}
