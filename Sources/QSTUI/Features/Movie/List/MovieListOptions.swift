//
//  MovieListOptions.swift
//  Movie List Demo iOS
//
//  Created by Huy Nguyen on 30/08/2023.
//

import Foundation
import QST

struct MovieListOptions: Equatable {
    var sortBy: SortBy = .title
    var order: Ordering = .descending

    enum Ordering: String, CaseIterable {
        case descending = "Descending"
        case ascending = "Ascending"
    }
    
    enum SortBy: String, CaseIterable {
        case title = "Title"
        case releaseDate = "Release Date"

        var key: String {
            switch self {
            case .title: return "title"
            case .releaseDate: return "releaseDate"
            }
        }
    }
}
