//
//  SearchCarServiceTests.swift
//  CarSearchTests
//
//  Created by Daan on 09/04/2026.
//

import Testing
import Foundation
@testable import CarSearch

@Suite("SearchCarService Tests")
struct SearchCarServiceTests {

    // MARK: - Helpers

    private let amsterdam = City(name: "Amsterdam", country: "NL", latitude: 52.3676, longitude: 4.9041)
    private let defaultFilter = SearchCarFilter()

    private func makeSUT() -> (service: SearchCarService, client: MockHTTPClient) {
        let client = MockHTTPClient()
        let service = SearchCarService(client: client)
        return (service, client)
    }

    // MARK: - Success

    @Test("Returns decoded cars from a valid API response")
    func searchCarsReturnsDecodedResults() async throws {
        let (service, client) = makeSUT()
        client.result = SearchResponse(results: [
            Car(id: "1", make: "Tesla", model: "Model 3", year: 2022, price: 45.0,
                currency: "EUR", imageURL: nil, distance: 1200, fuelType: "Electric",
                city: "Amsterdam", ownerName: "Jan")
        ])

        let cars = try await service.searchCars(city: amsterdam, filter: defaultFilter, limit: 10, offset: 0)

        #expect(cars.count == 1)
        #expect(cars.first?.make == "Tesla")
        #expect(cars.first?.model == "Model 3")
    }

    @Test("Returns empty array when API returns no results")
    func searchCarsReturnsEmptyArray() async throws {
        let (service, client) = makeSUT()
        client.result = SearchResponse(results: [])

        let cars = try await service.searchCars(city: amsterdam, filter: defaultFilter, limit: 10, offset: 0)

        #expect(cars.isEmpty)
    }

    // MARK: - Endpoint Construction

    @Test("Builds the correct endpoint with query parameters")
    func searchCarsBuildCorrectEndpoint() async throws {
        let (service, client) = makeSUT()
        client.result = SearchResponse(results: [])

        let filter = SearchCarFilter(distance: .far, sort: .price)
        _ = try await service.searchCars(city: amsterdam, filter: filter, limit: 5, offset: 20)

        let endpoint = try #require(client.lastEndpoint)
        let url = try #require(endpoint.url)
        let urlString = url.absoluteString

        #expect(urlString.contains("api.snappcar.nl"))
        #expect(urlString.contains("/v2/search/query"))
        #expect(urlString.contains("country=NL"))
        #expect(urlString.contains("lat=52.3676"))
        #expect(urlString.contains("lng=4.9041"))
        #expect(urlString.contains("max-distance=7000"))
        #expect(urlString.contains("sort=price"))
        #expect(urlString.contains("limit=5"))
        #expect(urlString.contains("offset=20"))
    }

    // MARK: - Error Handling

    @Test("Throws when HTTP client returns an error")
    func searchCarsThrowsOnHTTPError() async {
        let (service, client) = makeSUT()
        client.error = HTTPClientError.httpError(statusCode: 500)

        await #expect(throws: HTTPClientError.self) {
            _ = try await service.searchCars(city: amsterdam, filter: defaultFilter, limit: 10, offset: 0)
        }
    }

    @Test("Throws on invalid URL")
    func searchCarsThrowsOnInvalidURL() async {
        let (service, client) = makeSUT()
        client.error = HTTPClientError.invalidURL

        await #expect(throws: HTTPClientError.self) {
            _ = try await service.searchCars(city: amsterdam, filter: defaultFilter, limit: 10, offset: 0)
        }
    }
}
