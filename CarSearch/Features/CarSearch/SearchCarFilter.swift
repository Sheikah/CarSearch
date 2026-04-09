//
//  SearchCarFilter.swift
//  CarSearch
//
//  Created by Daan on 09/04/2026.
//

import Foundation

nonisolated enum SearchCarDistanceOption: Int, CaseIterable, Sendable {
    case close = 3000
    case medium = 5000
    case far = 7000

    var displayName: String {
        "\(rawValue / 1000) km"
    }
}

nonisolated enum SearchCarSortOption: String, CaseIterable, Sendable {
    case price
    case recommended
    case distance

    var displayName: String {
        rawValue.capitalized
    }
}

nonisolated struct SearchCarFilter: Equatable, Sendable {
    var distance: SearchCarDistanceOption = .close
    var sort: SearchCarSortOption = .recommended
}
