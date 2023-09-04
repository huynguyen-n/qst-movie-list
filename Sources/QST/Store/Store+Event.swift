//
//  Store+Event.swift
//  QSTUI
//
//  Created by Huy Nguyen on 29/08/2023.
//

import Foundation

extension Store {
    /// The events used for syncing data between stores.
    @frozen public enum Event {
        case movieStored(MovieCreated)

        public struct MovieCreated: Codable, Sendable {
            public var id: String
            public var title: String
            public var descriptions: String
            public var thumbnail: String
            public var rating: Double
            public var duration: Int
            public var genre: [String]
            public var releaseDate: Date
            public var trailerURL: String

            public init(id: String, title: String, descriptions: String, thumbnail: String, rating: Double, duration: Int, genre: [String], releaseDate: Date, trailerURL: String) {
                self.id = id
                self.title = title
                self.descriptions = descriptions
                self.thumbnail = thumbnail
                self.rating = rating
                self.duration = duration
                self.genre = genre
                self.releaseDate = releaseDate
                self.trailerURL = trailerURL
            }

            init(_ entity: MovieEntity) {
                self.id = entity.id
                self.title = entity.title
                self.duration = entity.duration
                self.descriptions = entity.descriptions
                self.thumbnail = entity.thumbnail
                self.rating = entity.rating
                self.genre = entity.genre.components(separatedBy: ", ")
                self.releaseDate = entity.releaseDate
                self.trailerURL = entity.trailerURL
            }
        }
    }
}
