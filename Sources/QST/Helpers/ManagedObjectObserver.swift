//
//  ManagedObjectObserver.swift
//  Movie List Demo iOS
//
//  Created by Huy Nguyen on 29/08/2023.
//

import Foundation
import CoreData

public final class ManagedObjectsObserver<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    @Published private(set) public var objects: [T] = []

    private let controller: NSFetchedResultsController<T>

    init(request: NSFetchRequest<T>,
         context: NSManagedObjectContext,
         cacheName: String? = nil) {
        self.controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: cacheName)
        super.init()

        try? controller.performFetch()
        objects = controller.fetchedObjects ?? []

        controller.delegate = self
    }

    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        objects = self.controller.fetchedObjects ?? []
    }
}

public extension ManagedObjectsObserver where T == MovieEntity {
    static func movies(for context: NSManagedObjectContext) -> ManagedObjectsObserver {
        let request = NSFetchRequest<MovieEntity>(entityName: "\(MovieEntity.self)")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \MovieEntity.title, ascending: false)]

        return ManagedObjectsObserver(request: request, context: context, cacheName: "com.github.ytpull.video-cache")
    }
}
