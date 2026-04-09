//
//  SearchCarService.swift
//  CarSearch
//
//  Created by Daan on 09/04/2026.
//

import Foundation

/// A lightweight wrapper around the API response. Only used internally for decoding.
nonisolated struct SearchResponse: Decodable, Sendable {
    let results: [Car]
}

/// Fetches car search results from the SnappCar API.
nonisolated struct SearchCarService: Sendable {
    private let client: any HTTPClientProtocol

    init(client: any HTTPClientProtocol = HTTPClient()) {
        self.client = client
    }

    /// Searches for cars near the given city.
    func searchCars(
        city: City,
        filter: SearchCarFilter,
        limit: Int,
        offset: Int
    ) async throws -> [Car] {
        let endpoint = Endpoint(
            baseURL: "https://api.snappcar.nl",
            path: "/v2/search/query",
            queryItems: [
                URLQueryItem(name: "country", value: city.country),
                URLQueryItem(name: "lat", value: String(city.latitude)),
                URLQueryItem(name: "lng", value: String(city.longitude)),
                URLQueryItem(name: "max-distance", value: String(filter.distance.rawValue)),
                URLQueryItem(name: "sort", value: filter.sort.rawValue),
                URLQueryItem(name: "order", value: "asc"),
                URLQueryItem(name: "limit", value: String(limit)),
                URLQueryItem(name: "offset", value: String(offset)),
            ]
        )

        let response: SearchResponse = try await client.fetch(endpoint)
        return response.results
    }
}
