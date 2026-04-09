//
//  CarDecodingTests.swift
//  CarSearchTests
//
//  Created by Daan on 09/04/2026.
//

import Testing
import Foundation
@testable import CarSearch

@Suite("Car Decoding Tests")
struct CarDecodingTests {

    @Test("Decodes car from nested SnappCar API JSON")
    func decodesFullCarJSON() throws {
        let json = """
        {
            "ci": "abc123",
            "distance": 2500.0,
            "car": {
                "make": "Volkswagen",
                "model": "Golf",
                "year": 2020,
                "fuelType": "Gasoline",
                "images": ["https://picsum.photos/200/300"],
                "address": {
                    "city": "Amsterdam"
                }
            },
            "user": {
                "firstName": "Jan"
            },
            "priceInformation": {
                "price": 35.50,
                "isoCurrencyCode": "EUR"
            }
        }
        """.data(using: .utf8)!

        let car = try JSONDecoder().decode(Car.self, from: json)

        #expect(car.id == "abc123")
        #expect(car.make == "Volkswagen")
        #expect(car.model == "Golf")
        #expect(car.year == 2020)
        #expect(car.fuelType == "Gasoline")
        #expect(car.price == 35.50)
        #expect(car.currency == "EUR")
        #expect(car.city == "Amsterdam")
        #expect(car.ownerName == "Henk")
        #expect(car.distance == 2500.0)
        #expect(car.imageURL?.absoluteString == "https://picsum.photos/200/300")
    }

    @Test("Decodes car with missing optional fields")
    func decodesPartialCarJSON() throws {
        let json = """
        {
            "ci": "xyz789",
            "car": {
                "make": "BMW",
                "model": "i3"
            }
        }
        """.data(using: .utf8)!

        let car = try JSONDecoder().decode(Car.self, from: json)

        #expect(car.id == "xyz789")
        #expect(car.make == "BMW")
        #expect(car.model == "i3")
        #expect(car.year == nil)
        #expect(car.price == nil)
        #expect(car.currency == nil)
        #expect(car.imageURL == nil)
        #expect(car.city == nil)
        #expect(car.ownerName == nil)
        #expect(car.distance == nil)
    }

    @Test("Formats price correctly")
    func formattedPrice() {
        let car = Car(id: "1", make: "Test", model: "Car", year: nil, price: 42.50,
                      currency: "EUR", imageURL: nil, distance: nil, fuelType: nil,
                      city: nil, ownerName: nil)
        #expect(car.formattedPrice == "42.50 EUR")
    }

    @Test("Formats distance in km when >= 1000m")
    func formattedDistanceKilometers() {
        let car = Car(id: "1", make: "Test", model: "Car", year: nil, price: nil,
                      currency: nil, imageURL: nil, distance: 2500, fuelType: nil,
                      city: nil, ownerName: nil)
        #expect(car.formattedDistance == "2.5 km")
    }

    @Test("Formats distance in meters when < 1000m")
    func formattedDistanceMeters() {
        let car = Car(id: "1", make: "Test", model: "Car", year: nil, price: nil,
                      currency: nil, imageURL: nil, distance: 750, fuelType: nil,
                      city: nil, ownerName: nil)
        #expect(car.formattedDistance == "750 m")
    }
}
