//
//  MovieListContentView.swift
//  Movie List Demo iOS
//
//  Created by Huy Nguyen on 30/08/2023.
//

import SwiftUI

struct MovieListContentView: View {

    @EnvironmentObject var viewModel: MovieListViewModel

    var body: some View {
        if viewModel.entities.isEmpty {
            Text("Empty")
                .font(.subheadline)
                .foregroundColor(.secondary)
        } else {
            ForEach(viewModel.visibleEntities, id: \.objectID) { entity in
                MovieEntityCell(entity: entity)
                    .id(entity.objectID)
            }
        }
    }
}
