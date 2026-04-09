//
//  Endpoint.swift
//  CarSearch
//
//  Created by Daan on 09/04/2026.
//

import Foundation

nonisolated struct Endpoint: Sendable {
    let baseURL: String
    let path: String
    let queryItems: [URLQueryItem]

    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path += path
        components?.queryItems = queryItems
        return components?.url
    }
}
