//
//  SearchCarViewModel.swift
//  CarSearch
//
//  Created by Daan on 09/04/2026.
//

import Foundation
import Observation

/// ViewModel that manages car search state, including city search,
/// filter changes, and infinite-scroll pagination.
@Observable
final class SearchCarViewModel {
    // MARK: - Published State

    /// The user's current search text for filtering cities.
    var searchText: String = ""

    /// The currently selected city (nil until user picks one).
    var selectedCity: City?

    /// Cities matching the current search text, shown as search suggestions.
    var citySuggestions: [City] = []

    /// The current set of filter selections.
    var filter: SearchCarFilter = SearchCarFilter()

    /// The list of cars returned by the API.
    private(set) var cars: [Car] = []

    /// Whether a network request is currently in progress.
    private(set) var isLoading: Bool = false

    /// Whether more pages are available to load.
    private(set) var canLoadMore: Bool = false

    /// The current error message, if any.
    private(set) var errorMessage: String?

    // MARK: - Private State

    private let service: SearchCarService
    private let pageSize = 10

    /// Start loading next page when this many items from the end.
    private let prefetchThreshold = 3

    private var currentOffset = 0
    private var searchTask: Task<Void, Never>?
    private var paginationTask: Task<Void, Never>?
    private var debounceTask: Task<Void, Never>?

    // MARK: - Init

    init(service: SearchCarService = SearchCarService()) {
        self.service = service
    }

    // MARK: - City Search

    /// Filters the hardcoded city list locally with a 500ms debounce.
    func onSearchTextChanged() {
        debounceTask?.cancel()

        let query = searchText.trimmingCharacters(in: .whitespaces).lowercased()

        guard !query.isEmpty else {
            citySuggestions = []
            return
        }

        debounceTask = Task {
            try? await Task.sleep(for: .milliseconds(500))
            guard !Task.isCancelled else { return }
            citySuggestions = City.all.filter { $0.name.lowercased().contains(query) }
        }
    }

    /// Called when the user selects a city from suggestions.
    func selectCity(_ city: City) {
        selectedCity = city
        searchText = city.name
        citySuggestions = []

        performSearch()
    }

    // MARK: - Filter Changes

    /// Called when any filter value changes. Resets pagination and performs a fresh search.
    func onFilterChanged() {
        guard selectedCity != nil else { return }
        performSearch()
    }

    // MARK: - Pagination

    /// Called by each row's `onAppear`. Triggers prefetching when nearing the end of the list.
    func loadMoreIfNeeded(currentItem: Car) {
        // Find the index of the current item
        guard let index = cars.firstIndex(where: { $0.id == currentItem.id }) else { return }

        // Check if we're within the prefetch threshold.
        let thresholdIndex = cars.count - prefetchThreshold
        guard index >= thresholdIndex, canLoadMore, !isLoading else { return }

        loadNextPage()
    }

    // MARK: - Private Methods

    /// Performs a fresh search.
    private func performSearch() {
        searchTask?.cancel()
        paginationTask?.cancel()

        currentOffset = 0
        cars = []
        canLoadMore = false
        errorMessage = nil

        searchTask = Task {
            await fetchCars(offset: 0, isNewSearch: true)
        }
    }

    private func loadNextPage() {
        paginationTask?.cancel()

        paginationTask = Task {
            await fetchCars(offset: currentOffset, isNewSearch: false)
        }
    }

    private func fetchCars(offset: Int, isNewSearch: Bool) async {
        guard let city = selectedCity else { return }
        guard !Task.isCancelled else { return }

        isLoading = true
        errorMessage = nil

        do {
            let results = try await service.searchCars(
                city: city,
                filter: filter,
                limit: pageSize,
                offset: offset
            )

            // Check cancellation after await
            guard !Task.isCancelled else { return }

            if isNewSearch {
                cars = results
            } else {
                cars.append(contentsOf: results)
            }

            currentOffset = cars.count
            canLoadMore = results.count == pageSize

        } catch is CancellationError {
            // Silently ignore cancellation
        } catch {
            guard !Task.isCancelled else { return }
            errorMessage = error.localizedDescription
        }

        if !Task.isCancelled {
            isLoading = false
        }
    }
}
