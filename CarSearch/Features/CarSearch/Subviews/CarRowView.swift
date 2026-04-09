//
//  CarRowView.swift
//  CarSearch
//
//  Created by Daan on 09/04/2026.
//

import SwiftUI

struct CarRowView: View, Equatable {
    let car: Car

    nonisolated static func == (lhs: CarRowView, rhs: CarRowView) -> Bool {
        lhs.car == rhs.car
    }

    var body: some View {
        HStack(spacing: 12) {
            carImage
            carDetails
            Spacer()
            priceLabel
        }
        .padding(.vertical, 8)
    }

    // MARK: - Subviews

    private var carImage: some View {
        Group {
            if let url = car.imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure, .empty:
                        imagePlaceholder
                    @unknown default:
                        imagePlaceholder
                    }
                }
            } else {
                imagePlaceholder
            }
        }
        .frame(width: 80, height: 60)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var imagePlaceholder: some View {
        Image(systemName: "car.fill")
            .font(.title2)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.systemGray5))
    }

    private var carDetails: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(car.make) \(car.model)")
                .font(.subheadline)
                .fontWeight(.semibold)
                .lineLimit(1)

            HStack(spacing: 8) {
                if let year = car.year {
                    Label(String(year), systemImage: "calendar")
                }
                if let fuelType = car.fuelType {
                    Label(fuelType, systemImage: "fuelpump")
                }
            }
            .font(.caption)
            .foregroundStyle(.secondary)

            if let city = car.city {
                Label(city, systemImage: "location")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var priceLabel: some View {
        VStack(alignment: .trailing, spacing: 2) {
            Text(car.formattedPrice)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundStyle(.blue)

            Text("/day")
                .font(.caption2)
                .foregroundStyle(.secondary)

            if !car.formattedDistance.isEmpty {
                Text(car.formattedDistance)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}
