//
//  SearchCarFilterBar.swift
//  CarSearch
//
//  Created by Daan on 09/04/2026.
//

import SwiftUI

struct SearchCarFilterBar: View {
    @Bindable var viewModel: SearchCarViewModel

    var body: some View {
        HStack(spacing: 16) {
            distancePicker
            sortPicker
        }
    }

    // MARK: - Subviews

    private var distancePicker: some View {
        HStack(spacing: 4) {
            Image(systemName: "location.circle")
                .foregroundStyle(.secondary)
                .font(.caption)
            Picker("Distance", selection: $viewModel.filter.distance) {
                ForEach(SearchCarDistanceOption.allCases, id: \.self) { option in
                    Text(option.displayName).tag(option)
                }
            }
            .onChange(of: viewModel.filter.distance) {
                viewModel.onFilterChanged()
            }
        }
    }

    private var sortPicker: some View {
        HStack(spacing: 4) {
            Image(systemName: "arrow.up.arrow.down")
                .foregroundStyle(.secondary)
                .font(.caption)
            Picker("Sort", selection: $viewModel.filter.sort) {
                ForEach(SearchCarSortOption.allCases, id: \.self) { option in
                    Text(option.displayName).tag(option)
                }
            }
            .onChange(of: viewModel.filter.sort) {
                viewModel.onFilterChanged()
            }
        }
    }
}
