//
//  Store+Entities.swift
//  QST
//
//  Created by Huy Nguyen on 29/08/2023.
//

import CoreData

public final class MovieEntity: NSManagedObject {
    @NSManaged public var createdAt: Date
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var duration: Int
    @NSManaged public var details: MovieDetailsEntity?
}

public final class MovieDetailsEntity: NSManagedObject {
    @NSManaged public var createdAt: Date
    @NSManaged public var id: UUID
    @NSManaged public var isWatchedList: Bool
    @NSManaged public var title: String
    @NSManaged public var descriptions: String
    @NSManaged public var genre: String
    @NSManaged public var releaseDate: Date
}
