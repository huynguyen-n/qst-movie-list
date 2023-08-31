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
        _MovieCell(entityCell: EntityCell(entity))
    }
}

private struct _MovieCell: View {
    let entityCell: EntityCell

    var body: some View {
        switch entityCell {
        case .movie(let movieEntity):
            return MovieCell(movie: movieEntity)
        }
    }
}

enum EntityCell {
    case movie(MovieEntity)

    init(_ entity: NSManagedObject) {
        if let movieEntity = entity as? MovieEntity {
            self = .movie(movieEntity)
        } else {
            fatalError("Unsupported entity: \(entity)")
        }
    }
}
