//
//  CoreData+Extensions.swift
//  Movie
//
//  Created by Huy Nguyen on 29/08/2023.
//

import CoreData
import Foundation

extension NSPersistentContainer {
    static var inMemoryReadonlyContainer: NSPersistentContainer {
        let container = NSPersistentContainer(name: "EmptyStore", managedObjectModel: Store.model)
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, _ in }
        return container
    }

    func loadStore() throws {
        var loadError: Swift.Error?
        loadPersistentStores { description, error in
            if let error = error {
                debugPrint("Failed to load persistent store \(description) with error: \(error)")
                loadError = error
            }
        }
        if let error = loadError {
            throw error
        }
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
    }
}

extension NSEntityDescription {
    convenience init<T>(class customClass: T.Type) where T: NSManagedObject {
        self.init()
        self.name = String(describing: customClass) // e.g. `MovieEntity`
        self.managedObjectClassName = T.self.description() // e.g. `QST.MovieEntity`
    }
}

extension NSAttributeDescription {
    convenience init(name: String, type: NSAttributeType, _ configure: (NSAttributeDescription) -> Void = { _ in }) {
        self.init()
        self.name = name
        self.attributeType = type
        configure(self)
    }
}

enum RelationshipType {
    case oneToMany
    case oneToOne(isOptional: Bool = false)
}

extension NSRelationshipDescription {
    convenience init(name: String,
                     type: RelationshipType,
                     deleteRule: NSDeleteRule = .cascadeDeleteRule,
                     entity: NSEntityDescription) {
        self.init()
        self.name = name
        self.deleteRule = deleteRule
        self.destinationEntity = entity
        switch type {
        case .oneToMany:
            self.maxCount = 0
            self.minCount = 0
        case .oneToOne(let isOptional):
            self.maxCount = 1
            self.minCount = isOptional ? 0 : 1
        }
    }
}
