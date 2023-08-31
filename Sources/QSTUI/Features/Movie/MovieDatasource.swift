//
//  MovieListDatasource.swift
//  Movie List Demo iOS
//
//  Created by Huy Nguyen on 30/08/2023.
//

import Foundation
import CoreData
import Combine
import QST

protocol MovieListDataSourceDelegate: AnyObject {
    /// The data source reloaded the entire dataset.
    func dataSourceDidRefresh(_ dataSource: MovieListDataSource)

    /// An incremental update. If the diff is nil, it means the app is displaying
    /// a grouped view that doesn't support diffing.
    func dataSource(_ dataSource: MovieListDataSource, didUpdateWith diff: CollectionDifference<NSManagedObjectID>?)
}

final class MovieListDataSource: NSObject, NSFetchedResultsControllerDelegate {
    weak var delegate: MovieListDataSourceDelegate?

    var sortDescriptors: [NSSortDescriptor] = [] {
        didSet { controller.fetchRequest.sortDescriptors = sortDescriptors }
    }

    struct PredicateOptions {
        var isOnlyErrors = false
        var predicate: NSPredicate?
        var focus: NSPredicate?
    }

    var predicate: PredicateOptions = .init() {
        didSet { refreshPredicate() }
    }

    private let store: Store
    private let options: MovieListOptions
    private let controller: NSFetchedResultsController<NSManagedObject>
    private var controllerDelegate: NSFetchedResultsControllerDelegate?

    init(store: Store, options: MovieListOptions = .init()) {
        self.store = store
        self.options = options

        let entityName = "\(MovieEntity.self)"
        let sortKey = options.sortBy.key

        let request = NSFetchRequest<NSManagedObject>(entityName: entityName)
        request.sortDescriptors = [
            NSSortDescriptor(key: sortKey, ascending: options.order == .ascending)
        ].compactMap { $0 }
        request.relationshipKeyPathsForPrefetching = ["request"]
        controller = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: store.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        super.init()

        controllerDelegate = {
            let delegate = MovieListFetchDelegate()
            delegate.delegate = self
            return delegate
        }()
        controller.delegate = controllerDelegate
    }

    // MARK: Accessing Entities

    var numberOfObjects: Int {
        controller.fetchedObjects?.count ?? 0
    }

    func object(at indexPath: IndexPath) -> NSManagedObject {
        controller.object(at: indexPath)
    }

    var entities: [NSManagedObject] {
        controller.fetchedObjects ?? []
    }

    var sections: [NSFetchedResultsSectionInfo]? {
        controller.sectionNameKeyPath == nil ? nil : controller.sections
    }

    // MARK: NSFetchedResultsControllerDelegate

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.dataSource(self, didUpdateWith: nil)
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith diff: CollectionDifference<NSManagedObjectID>) {
        delegate?.dataSource(self, didUpdateWith: diff)
    }

    // MARK: Predicate

    private func refreshPredicate() {
        controller.fetchRequest.predicate = nil
        refresh()
    }

    func refresh() {
        try? controller.performFetch()
        delegate?.dataSourceDidRefresh(self)
    }
}

private final class MovieListFetchDelegate: NSObject, NSFetchedResultsControllerDelegate {
    weak var delegate: NSFetchedResultsControllerDelegate?

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith diff: CollectionDifference<NSManagedObjectID>) {
        delegate?.controller?(controller, didChangeContentWith: diff)
    }
}
