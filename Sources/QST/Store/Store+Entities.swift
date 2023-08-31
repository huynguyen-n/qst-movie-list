//
//  Store+Entities.swift
//  QST
//
//  Created by Huy Nguyen on 29/08/2023.
//

import CoreData

public final class MovieEntity: NSManagedObject {
    @NSManaged public var id: String
    @NSManaged public var title: String
    @NSManaged public var descriptions: String
    @NSManaged public var rating: Double
    @NSManaged public var duration: Int
    @NSManaged public var genre: String
    @NSManaged public var releaseDate: Date
    @NSManaged public var trailerURL: String
}
