//
//  ApiErrorDTO.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 22.05.2025.
//

import Foundation

/// Data transfer object that represents API error responses
///
/// This struct maps the common error structure returned by the API,
/// containing an error code, message, and optional detailed error items.
struct ApiErrorDTO: Codable {
    let code: String?
    let message: String?
    let errorItems: [String: String]?
}

enum APIErrorHandler: Error {
    case customApiError(ApiErrorDTO)
    case requestFailed
    case normalError(Error)
    case tokenExpired
    case decodingError(Error)
    case emptyErrorWithStatusCode(String)

    /// A human-readable description of the error
    ///
    /// This computed property formats the error information in a consistent way
    /// that can be presented to users or logged for debugging purposes.
    /// - Returns: String description of the error
    var errorDescription: String? {
        switch self {
        case let .customApiError(apiErrorDTO):
            var errorItems: String?
            if let errorItemsDTO = apiErrorDTO.errorItems {
                errorItems = ""
                for item in errorItemsDTO {
                    errorItems?.append(item.key)
                    errorItems?.append(" ")
                    errorItems?.append(item.value)
                    errorItems?.append("\n")
                }
            }
            if errorItems == nil && apiErrorDTO.code == nil &&
                apiErrorDTO.message == nil
            {
                errorItems = "Internal error!"
            }
            return String(format: "%@ %@ \n %@", apiErrorDTO.code ?? "",
                          apiErrorDTO.message ?? "", errorItems ?? "")
        case .requestFailed:
            return "request failed"
        case let .normalError(error):
            return error.localizedDescription
        case .tokenExpired:
            return "Token problems"
        case let .decodingError(error):
            return "Decoding error: \(error.localizedDescription)"
        case let .emptyErrorWithStatusCode(status):
            return status
        }
    }
}
