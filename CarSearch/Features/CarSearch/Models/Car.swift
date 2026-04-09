//
//  Car.swift
//  CarSearch
//
//  Created by Daan on 09/04/2026.
//

import Foundation

nonisolated struct Car: Identifiable, Equatable, Sendable, Decodable {
    let id: String
    let make: String
    let model: String
    let year: Int?
    let price: Double?
    let currency: String?
    let imageURL: URL?
    let distance: Double?
    let fuelType: String?
    let city: String?
    let ownerName: String?

    var formattedPrice: String {
        guard let price, let currency else { return "N/A" }
        return String(format: "%.2f %@", price, currency)
    }

    var formattedDistance: String {
        guard let distance else { return "" }
        if distance >= 1000 {
            return String(format: "%.1f km", distance / 1000)
        }
        return String(format: "%.0f m", distance)
    }

    // MARK: - Decoding from nested API JSON

    /// Maps the flat search-result JSON keys to local properties.
    private enum CodingKeys: String, CodingKey {
        case id = "ci"
        case distance
        case car
        case user
        case priceInformation
    }

    private enum CarKeys: String, CodingKey {
        case make, model, year, fuelType, images, address
    }

    private enum AddressKeys: String, CodingKey {
        case city
    }

    private enum UserKeys: String, CodingKey {
        case firstName
    }

    private enum PriceKeys: String, CodingKey {
        case price
        case isoCurrencyCode
    }

    init(from decoder: any Decoder) throws {
        let root = try decoder.container(keyedBy: CodingKeys.self)

        id = try root.decode(String.self, forKey: .id)
        distance = try root.decodeIfPresent(Double.self, forKey: .distance)

        // Nested car object
        let carContainer = try root.nestedContainer(keyedBy: CarKeys.self, forKey: .car)
        make = try carContainer.decodeIfPresent(String.self, forKey: .make) ?? "Unknown"
        model = try carContainer.decodeIfPresent(String.self, forKey: .model) ?? "Unknown"
        year = try carContainer.decodeIfPresent(Int.self, forKey: .year)
        fuelType = try carContainer.decodeIfPresent(String.self, forKey: .fuelType)

        let images = try carContainer.decodeIfPresent([String].self, forKey: .images)
        imageURL = images?.first.flatMap { URL(string: $0) }

        let addressContainer = try? carContainer.nestedContainer(keyedBy: AddressKeys.self, forKey: .address)
        city = try addressContainer?.decodeIfPresent(String.self, forKey: .city)

        // Nested user object
        let userContainer = try? root.nestedContainer(keyedBy: UserKeys.self, forKey: .user)
        ownerName = try userContainer?.decodeIfPresent(String.self, forKey: .firstName)

        // Nested price object
        let priceContainer = try? root.nestedContainer(keyedBy: PriceKeys.self, forKey: .priceInformation)
        price = try priceContainer?.decodeIfPresent(Double.self, forKey: .price)
        currency = try priceContainer?.decodeIfPresent(String.self, forKey: .isoCurrencyCode)
    }

    // Memberwise init for previews/tests
    init(
        id: String, make: String, model: String, year: Int?, price: Double?,
        currency: String?, imageURL: URL?, distance: Double?, fuelType: String?,
        city: String?, ownerName: String?
    ) {
        self.id = id; self.make = make; self.model = model; self.year = year
        self.price = price; self.currency = currency; self.imageURL = imageURL
        self.distance = distance; self.fuelType = fuelType; self.city = city
        self.ownerName = ownerName
    }
}
