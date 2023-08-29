//
//  Store+Model.swift
//  QST
//
//  Created by Huy Nguyen on 29/08/2023.
//

import CoreData

extension Store {
    /// Returns Core Data model used by the store.
    static let model: NSManagedObjectModel = {
        typealias Entity = NSEntityDescription
        typealias Attribute = NSAttributeDescription
        typealias Relationship = NSRelationshipDescription

        let movie = Entity(class: MovieEntity.self)
        let movieDetails = Entity(class: MovieDetailsEntity.self)

        movie.properties = [
            Attribute(name: "id", type: .UUIDAttributeType),
            Attribute(name: "createdAt", type: .dateAttributeType),
            Attribute(name: "title", type: .stringAttributeType),
            Attribute(name: "duration", type: .integer16AttributeType),
            Relationship(name: "movieDetails", type: .oneToOne(isOptional: true), entity: movieDetails)
        ]

        movieDetails.properties = [
            Attribute(name: "id", type: .UUIDAttributeType),
            Attribute(name: "createdAt", type: .dateAttributeType),
            Attribute(name: "isWatchedList", type: .booleanAttributeType),
            Attribute(name: "title", type: .stringAttributeType),
            Attribute(name: "descriptions", type: .stringAttributeType),
            Attribute(name: "genre", type: .stringAttributeType),
            Attribute(name: "releaseDate", type: .dateAttributeType),
        ]

        let model = NSManagedObjectModel()
        model.entities = [movie, movieDetails]
        return model
    }()
}
