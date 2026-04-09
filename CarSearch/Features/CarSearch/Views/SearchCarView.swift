//
//  SearchCarView.swift
//  CarSearch
//
//  Created by Daan on 09/04/2026.
//

import SwiftUI

struct SearchCarView: View {
    @State private var viewModel = SearchCarViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                filterSection
                Divider()
                resultsList
            }
            .navigationTitle("Car Search")
            .searchable(text: $viewModel.searchText, prompt: "Search for a city…")
            .searchSuggestions {
                citySuggestions
            }
            .onChange(of: viewModel.searchText) {
                viewModel.onSearchTextChanged()
            }
        }
    }

    // MARK: - Search Suggestions

    private var citySuggestions: some View {
        ForEach(viewModel.citySuggestions) { city in
            Button {
                viewModel.selectCity(city)
            } label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(city.name)
                            .font(.subheadline)
                        Text(countryName(for: city.country))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Text(city.country)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    // MARK: - Filters

    private var filterSection: some View {
        SearchCarFilterBar(viewModel: viewModel)
            .padding(.horizontal)
            .padding(.vertical, 8)
    }

    // MARK: - Results

    private var resultsList: some View {
        Group {
            if let errorMessage = viewModel.errorMessage {
                errorView(message: errorMessage)
            } else if viewModel.cars.isEmpty && !viewModel.isLoading {
                emptyStateView
            } else {
                carList
            }
        }
    }

    private var carList: some View {
        List {
            ForEach(viewModel.cars) { car in
                CarRowView(car: car)
                    .equatable()
                    .onAppear {
                        viewModel.loadMoreIfNeeded(currentItem: car)
                    }
            }

            if viewModel.isLoading {
                loadingRow
            }
        }
        .listStyle(.plain)
    }

    private var loadingRow: some View {
        HStack {
            Spacer()
            ProgressView()
                .padding()
            Spacer()
        }
        .listRowSeparator(.hidden)
    }

    private var emptyStateView: some View {
        ContentUnavailableView(
            "Search for Cars",
            systemImage: "car.2",
            description: Text("Enter a city name above to find available cars.")
        )
    }

    private func errorView(message: String) -> some View {
        ContentUnavailableView {
            Label("Something went wrong", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Try Again") {
                viewModel.onFilterChanged()
            }
            .buttonStyle(.bordered)
        }
    }

    // MARK: - Helpers

    private func countryName(for code: String) -> String {
        switch code {
        case "NL": "Netherlands"
        case "DE": "Germany"
        case "SE": "Sweden"
        default: code
        }
    }
}

#Preview {
    SearchCarView()
}
