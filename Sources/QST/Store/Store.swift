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

    /// Returns the Core Data container associated with the store.
    public let container: NSPersistentContainer

    /// Returns the background managed object context used for all write operations.
    public let backgroundContext: NSManagedObjectContext

    /// Returns the view context for accessing entities on the main thread.
    public var viewContext: NSManagedObjectContext { container.viewContext }

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

    public init(storeURL: URL) throws {
        var isDirectory: ObjCBool = ObjCBool(false)
        let fileExists = Files.fileExists(atPath: storeURL.path, isDirectory: &isDirectory)
        let isArchive = fileExists && !isDirectory.boolValue
        self.url = storeURL

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
    }
}

// MARK: - Private Extension
private extension Store {
    static func makeContainer(databaseURL: URL) -> NSPersistentContainer {
        let container = NSPersistentContainer(name: databaseURL.lastPathComponent, managedObjectModel: Self.model)
        let store = NSPersistentStoreDescription(url: databaseURL)
        store.setValue("DELETE" as NSString, forPragmaNamed: "journal_mode")
        container.persistentStoreDescriptions = [store]
        return container
    }
}

// MARK: - Constants

let databaseFilename = "qst.sqlite"
