//
//  MovieCell.swift
//  Movie List Demo iOS
//
//  Created by Huy Nguyen on 30/08/2023.
//

import SwiftUI
import QST

struct MovieCell: View {

    let movie: MovieEntity

    var body: some View {
        VStack {
            HStack {
                Text(movie.title)
            }
            .listRowSeparator(.hidden)
            .clipped()
            .cornerRadius(8)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
