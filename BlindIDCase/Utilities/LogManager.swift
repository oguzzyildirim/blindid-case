//
//  LogHelper.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 21.05.2025.
//

import Foundation

/// Singleton manager for handling application logging with different severity levels
///
/// This utility provides a centralized way to log messages throughout the application
/// with appropriate visual indicators for different log types.
final class LogManager: NSObject {
    override private init() {}

    static let shared = LogManager()

    func infoWithSuccess(_ message: Any...) {
        log(type: "✅", message: message)
    }
    
    func info(_ message: Any...) {
        log(type: "ℹ️", message: message)
    }

    func error(_ message: Any...) {
        log(type: "❌", message: message)
    }

    func warning(_ message: Any...) {
        log(type: "⚠️", message: message)
    }

    /// Internal method that formats and prints the log message
    /// - Parameters:
    ///   - type: The emoji indicator for the log type
    ///   - message: The content to be logged
    private func log(type: String, message: Any...) {
        let combinedString = message.map { String(describing: $0) }.joined(separator: " ")
        let logString = [type, " BlindID-Logger --> ", combinedString]
            .map { String(describing: $0) }
            .joined(separator: "")
        print(logString)
    }
}
