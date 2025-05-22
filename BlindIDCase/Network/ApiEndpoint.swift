//
//  ApiEndpoint.swift
//  BlindIDCase
//
//  Created by Oguz Yildirim on 22.05.2025.
//

import Foundation

/// Protocol that defines the requirements for API endpoints in the application
///
/// This protocol provides a standardized way to configure and create network requests
/// for different API endpoints by specifying URL components, HTTP method, headers, and body parameters.
protocol ApiEndpoint {
    var baseURLString: String { get }
    var apiVersion: String? { get }
    var separatorPath: String? { get }
    var path: String { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var params: [String: Any]? { get }
    var method: APIHTTPMethod { get }
    var customDataBody: Data? { get }
}

extension ApiEndpoint {
    /// Creates and returns a fully configured URLRequest based on the endpoint properties
    var makeRequest: URLRequest {
        guard let urlComponents = createURLComponents() else {
            fatalError("Could not create URL components from: \(baseURLString)")
        }
        
        guard let url = urlComponents.url else {
            fatalError("Could not create URL from components: \(urlComponents)")
        }
        
        var request = URLRequest(url: url)
        configureRequest(&request)
        
        return request
    }
    
    // MARK: - Private helpers
    
    /// Creates URLComponents from the endpoint configuration
    /// - Returns: Configured URLComponents or nil if creation fails
    private func createURLComponents() -> URLComponents? {
        guard var components = URLComponents(string: baseURLString) else {
            return nil
        }
        
        components.path = getFullPath()
        components.queryItems = queryItems
        
        return components
    }
    
    /// Configures the HTTP method, headers and body of the request
    /// - Parameter request: The URLRequest to configure
    private func configureRequest(_ request: inout URLRequest) {
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        
        setRequestBody(for: &request)
    }
    
    /// Sets the HTTP body for the request based on the available parameters
    /// - Parameter request: The URLRequest to configure with a body
    private func setRequestBody(for request: inout URLRequest) {
        if let customDataBody = customDataBody {
            request.httpBody = customDataBody
        } else if let params = params {
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: params)
                request.httpBody = jsonData
                
                if request.value(forHTTPHeaderField: "Content-Type") == nil {
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                }
            } catch {
                print("JSON serialization error: \(error)")
            }
        }
    }
    
    /// Constructs the full URL path by combining API version, separator path, and endpoint path
    /// - Returns: The complete path string starting with "/"
    private func getFullPath() -> String {
        var components: [String] = []
        
        if let apiVersion = apiVersion { components.append(apiVersion) }
        if let separatorPath = separatorPath { components.append(separatorPath) }
        components.append(path)
        
        return "/" + components.joined(separator: "/")
    }
}
