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

        movie.properties = [
            Attribute(name: "id", type: .stringAttributeType),
            Attribute(name: "title", type: .stringAttributeType),
            Attribute(name: "descriptions", type: .stringAttributeType),
            Attribute(name: "thumbnail", type: .stringAttributeType),
            Attribute(name: "rating", type: .doubleAttributeType),
            Attribute(name: "duration", type: .integer64AttributeType),
            Attribute(name: "genre", type: .stringAttributeType),
            Attribute(name: "releaseDate", type: .dateAttributeType),
            Attribute(name: "trailerURL", type: .stringAttributeType),
        ]

//        Attribute(name: "isWatchedList", type: .booleanAttributeType),

        let model = NSManagedObjectModel()
        model.entities = [movie]
        return model
    }()
}
