//
//  Store.swift
//  QST
//
//  Created by Huy Nguyen on 29/08/2023.
//

import Foundation
import CoreData
import Combine

public final class Store: @unchecked Sendable, Identifiable {
    // MARK: - Public
    public var id: ObjectIdentifier { ObjectIdentifier(self) }

    /// The URL the store was initialized with.
    public let url: URL

    /// The options with which the store was opened with.
    public let options: Options

    /// Returns the Core Data container associated with the store.
    public let container: NSPersistentContainer

    /// Returns the background managed object context used for all write operations.
    public let backgroundContext: NSManagedObjectContext

    /// Returns the view context for accessing entities on the main thread.
    public var viewContext: NSManagedObjectContext { container.viewContext }

    /// Returns `true` if the store was opened with a QST archive. The archives are readonly.
    public let isArchive: Bool

    // MARK: - Shared

    /// Returns a shared store.
    public static var shared = Store.makeDefault()

    private static func makeDefault() -> Store {
        let storeURL = URL.main.appending(directory: "current.qst")
        guard let store = try? Store(storeURL: storeURL) else {
            return Store(inMemoryStore: storeURL) // Should never happen
        }
        return store
    }

    // MARK: - Private
    private var isSaveScheduled = false
    private let queue = DispatchQueue(label: "com.qst.movie.store")
    private let databaseURL: URL

    public init(storeURL: URL, options: Options = []) throws {
        var isDirectory: ObjCBool = ObjCBool(false)
        let fileExists = Files.fileExists(atPath: storeURL.path, isDirectory: &isDirectory)
        guard fileExists || options.contains(.create) else {
            throw Store.Error.fileDoesntExist
        }
        self.isArchive = fileExists && !isDirectory.boolValue
        self.url = storeURL
        self.options = options

        if !isArchive {
            self.databaseURL = storeURL.appending(filename: databaseFilename)
            if !Files.fileExists(atPath: storeURL.path) {
                try Files.createDirectory(at: storeURL, withIntermediateDirectories: false)
            }
        } else {
            self.databaseURL = URL.temp.appending(filename: databaseFilename)
        }
        self.container = Store.makeContainer(databaseURL: databaseURL)
        try container.loadStore()
        self.backgroundContext = container.newBackgroundContext()
    }

    public init(inMemoryStore storeURL: URL) {
        self.url = storeURL
        self.databaseURL = storeURL.appending(directory: databaseFilename)
        self.container = .inMemoryReadonlyContainer
        self.backgroundContext = container.newBackgroundContext()
        self.isArchive = true
        self.options = []
    }
}

// MARK: - Store (Accessing Movies)

extension Store {
    /// Returns all recorded movies, least recent movies come first.
    public func allMovies() throws -> [MovieEntity] {
        try viewContext.fetch(MovieEntity.self)
    }

    public func toggleWatchedList(for movie: MovieEntity) {
        perform {
            guard let _movie = $0.object(with: movie.objectID) as? MovieEntity else { return }
            _movie.isWatchedList.toggle()
        }
    }

    /// Removes all of the previously recorded movies.
    public func removeAll() {
        perform { _ in self._removeAll() }
    }

    private func _removeAll() {
        try? deleteEntities(for: MovieEntity.fetchRequest())
    }

    /// Safely closes the database and removes all information from the store.
    ///
    /// - note: After the store is destroyed, you can't write any new movies to it.
    public func destroy() throws {
        let coordinator = container.persistentStoreCoordinator
        for store in coordinator.persistentStores {
            if let storeURL = store.url {
                try coordinator.destroyPersistentStore(at: storeURL, ofType: NSSQLiteStoreType, options: [:])
            }
        }
        try Files.removeItem(at: url)
    }

    /// Safely closes the database.
    public func close() throws {
        for store in container.persistentStoreCoordinator.persistentStores {
            try container.persistentStoreCoordinator.remove(store)
        }
    }
}

// MARK: - Store (Storing Movie)
extension Store {
    /// Stores the given movie
    public func storeMovie(_ movie: Event.MovieCreated) {
        handle(.movieStored(.init(
            id: movie.id,
            title: movie.title,
            descriptions: movie.descriptions,
            thumbnail: movie.thumbnail,
            rating: movie.rating,
            duration: movie.duration,
            genre: movie.genre,
            releaseDate: movie.releaseDate,
            trailerURL: movie.trailerURL)))
    }

    /// Handles event created by the current store and dispatches it to observers.
    func handle(_ event: Event) {
        perform { _ in
            self._handle(event)
        }
    }
}

// MARK: - Private Extension
private extension Store {
    private func deleteEntities(for fetchRequest: NSFetchRequest<NSFetchRequestResult>) throws {
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs

        let result = try backgroundContext.execute(deleteRequest) as? NSBatchDeleteResult
        guard let ids = result?.result as? [NSManagedObjectID] else { return }

        NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: ids], into: [backgroundContext])

        viewContext.perform {
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: [NSDeletedObjectsKey: ids], into: [self.viewContext])
        }
    }

    static func makeContainer(databaseURL: URL) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: databaseURL.lastPathComponent, managedObjectModel: Self.model)
        let store = NSPersistentStoreDescription(url: databaseURL)
        store.setValue("DELETE" as NSString, forPragmaNamed: "journal_mode")
        container.persistentStoreDescriptions = [store]
        return container
    }

    // MARK: Performing Changes

    private func perform(_ changes: @escaping (NSManagedObjectContext) -> Void) {
        guard !isArchive else { return }

        if options.contains(.synchronous) {
            backgroundContext.performAndWait {
                changes(backgroundContext)
                self.saveAndReset()
            }
        } else {
            backgroundContext.perform {
                changes(self.backgroundContext)
                self.setNeedsSave()
            }
        }
    }

    private func setNeedsSave() {
        guard !isSaveScheduled else { return }
        isSaveScheduled = true
        queue.asyncAfter(deadline: .now() + .milliseconds(250)) { [weak self] in
            self?.flush()
        }
    }

    private func flush() {
        backgroundContext.perform { [weak self] in
            guard let self = self else { return }
            if self.isSaveScheduled, Files.fileExists(atPath: self.url.path) {
                self.saveAndReset()
                self.isSaveScheduled = false
            }
        }
    }

    private func saveAndReset() {
        do {
            try backgroundContext.save()
        } catch {
            debugPrint(error)
        }
        backgroundContext.reset()
    }

    private func _handle(_ event: Event) {
        switch event {
        case .movieStored(let event): process(event)
        }
    }

    private func process(_ event: Event.MovieCreated) {
        let movie = MovieEntity(context: backgroundContext)
        movie.id = event.id
        movie.title = event.title
        movie.descriptions = event.descriptions
        movie.descriptions = event.descriptions
        movie.thumbnail = event.thumbnail
        movie.rating = event.rating
        movie.duration = event.duration
        movie.genre = event.genre.joined(separator: ", ")
        movie.releaseDate = event.releaseDate
        movie.trailerURL = event.trailerURL
        movie.isWatchedList = false
    }
}

// MARK: - Store (Error)

extension Store {
    public enum Error: Swift.Error, LocalizedError {
        case fileDoesntExist
        case storeInvalid
        case fileAlreadyExists
        case unknownError

        public var errorDescription: String? {
            switch self {
            case .fileDoesntExist: return "File doesn't exist"
            case .storeInvalid: return "Store format is invalid"
            case .fileAlreadyExists: return "The file at the given location already exists"
            case .unknownError: return "Unexpected error"
            }
        }
    }
}

// MARK: - Constants

let databaseFilename = "qst.sqlite"
