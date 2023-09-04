//
//  MovieEntityCell.swift
//  Movie List Demo iOS
//
//  Created by Huy Nguyen on 30/08/2023.
//

import CoreData
import SwiftUI
import QST

struct MovieEntityCell: View {

    let entity: NSManagedObject

    var body: some View {
        switch EntityCell(entity) {
        case let .movie(entity): _MovieCell(movie: entity)
        }
    }
}

private struct _MovieCell: View {
    let movie: MovieEntity

    var body: some View {
        let cell = MovieCell(movie: movie)
            .background(NavigationLink("", destination: MovieDetailsView(movie: movie)).opacity(0))
        cell
    }
}

enum EntityCell {
    case movie(MovieEntity)

    init(_ entity: NSManagedObject) {
        if let movie = entity as? MovieEntity {
            self = .movie(movie)
        } else {
            fatalError("Unsupported entity: \(entity)")
        }
    }
}
