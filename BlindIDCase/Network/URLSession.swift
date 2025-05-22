//
//  URLSession.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 22.05.2025.
//

import Foundation
import Combine

/// Protocol defining the requirements for an HTTP client
///
/// This protocol abstracts the network layer for making HTTP requests,
/// allowing for easier testing and potential implementation swapping.
protocol HTTPClient {
    /// Creates and returns a publisher for a given network request
    /// - Parameter request: The URLRequest to be executed
    /// - Returns: A publisher that emits the data and response upon completion or an error if the request fails
    func publisher(_ request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error>
}

extension URLSession: HTTPClient {
    struct InvalidHTTPResponseError: Error {}
    
    func publisher(_ request: URLRequest) -> AnyPublisher<(Data, HTTPURLResponse), Error> {
        return dataTaskPublisher(for: request)
            .tryMap ({ result in
                guard let httpResponse = result.response as? HTTPURLResponse else {
                    throw InvalidHTTPResponseError()
                }
                LogManager.shared.infoWithSuccess("Response received in publisher func.")
                return (result.data, httpResponse)
            })
            .eraseToAnyPublisher()
    }
}
