//
//  MockHTTPClient.swift
//  CarSearchTests
//
//  Created by Daan on 09/04/2026.
//

import Foundation
@testable import CarSearch

/// A stub HTTP client that returns pre-configured responses or throws errors.
final class MockHTTPClient: HTTPClientProtocol, @unchecked Sendable {
    var result: Any?
    var error: Error?
    var lastEndpoint: Endpoint?

    func fetch<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T {
        lastEndpoint = endpoint

        if let error {
            throw error
        }

        guard let result = result as? T else {
            fatalError("MockHTTPClient: result type mismatch. Expected \(T.self)")
        }

        return result
    }
}
