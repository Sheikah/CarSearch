//
//  HTTPClient.swift
//  CarSearch
//
//  Created by Daan on 09/04/2026.
//

import Foundation

/// Protocol that abstracts HTTP fetching, enabling stubbing in tests.
protocol HTTPClientProtocol: Sendable {
    func fetch<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T
}

nonisolated struct HTTPClient: HTTPClientProtocol, Sendable {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetch<T: Decodable & Sendable>(_ endpoint: Endpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw HTTPClientError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPClientError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw HTTPClientError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw HTTPClientError.decodingError(error)
        }
    }
}

nonisolated enum HTTPClientError: LocalizedError {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            "The URL is invalid."
        case .invalidResponse:
            "Received an invalid response from the server."
        case .httpError(let statusCode):
            "Server returned status code \(statusCode)."
        case .decodingError(let error):
            "Failed to decode the response: \(error.localizedDescription)"
        }
    }
}
