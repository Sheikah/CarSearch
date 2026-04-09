//
//  City.swift
//  CarSearch
//
//  Created by Daan on 09/04/2026.
//

import Foundation

nonisolated struct City: Identifiable, Hashable, Sendable {
    let id: String
    let name: String
    let country: String
    let latitude: Double
    let longitude: Double

    init(name: String, country: String, latitude: Double, longitude: Double) {
        self.id = "\(country)-\(name)"
        self.name = name
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
}

// TODO: Use the Google Places Details API to fetch the city details instead of hardcoding them here.
extension City {
    static let all: [City] = [
        // Netherlands
        City(name: "Amsterdam", country: "NL", latitude: 52.3676, longitude: 4.9041),
        City(name: "Rotterdam", country: "NL", latitude: 51.9225, longitude: 4.4792),
        City(name: "Utrecht", country: "NL", latitude: 52.0907, longitude: 5.1214),
        City(name: "The Hague", country: "NL", latitude: 52.0705, longitude: 4.3007),
        City(name: "Eindhoven", country: "NL", latitude: 51.4416, longitude: 5.4697),
        City(name: "Groningen", country: "NL", latitude: 53.2194, longitude: 6.5665),

        // Germany
        City(name: "Berlin", country: "DE", latitude: 52.5200, longitude: 13.4050),
        City(name: "Munich", country: "DE", latitude: 48.1351, longitude: 11.5820),
        City(name: "Hamburg", country: "DE", latitude: 53.5511, longitude: 9.9937),
        City(name: "Frankfurt", country: "DE", latitude: 50.1109, longitude: 8.6821),
        City(name: "Cologne", country: "DE", latitude: 50.9375, longitude: 6.9603),
        City(name: "Stuttgart", country: "DE", latitude: 48.7758, longitude: 9.1829),

        // Sweden
        City(name: "Stockholm", country: "SE", latitude: 59.3293, longitude: 18.0686),
        City(name: "Gothenburg", country: "SE", latitude: 57.7089, longitude: 11.9746),
        City(name: "Malmö", country: "SE", latitude: 55.6050, longitude: 13.0038),
        City(name: "Uppsala", country: "SE", latitude: 59.8586, longitude: 17.6389),
    ]
}
