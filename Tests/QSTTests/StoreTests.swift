//
//  StoreTests.swift
//  QSTTests
//
//  Created by Huy Nguyen on 03/09/2023.
//

import XCTest
import Foundation
import CoreData
import Combine
@testable import QST

final class StoreTests: StoreBaseTests {

    // MARK: - Init

    override func setUp() {
        super.setUp()

        store = try! Store(storeURL: storeURL, options: [.create, .synchronous])
    }


    func testInitStoreMissing() throws {
        // GIVEN
        let storeURL = directory.url.appending(filename: UUID().uuidString)

        // WHEN/THEN
        XCTAssertThrowsError(try Store(storeURL: storeURL))
    }

    func testInitCreateStoreIntermediateDirectoryMissing() throws {
        // GIVEN
        let storeURL = directory.url
            .appending(directory: UUID().uuidString)
            .appending(filename: UUID().uuidString)

        // WHEN/THEN
        XCTAssertThrowsError(try Store(storeURL: storeURL))
    }

    func testInitStoreWithURL() throws {
        // GIVEN
        populate(store: store)
        XCTAssertEqual(try store.allMovies().count, 5)

        let originalStore = store
        try? store.close()

        // WHEN loading the store with the same url
        store = try Store(storeURL: storeURL)

        // THEN data is persisted
        XCTAssertEqual(try store.allMovies().count, 5)

        // CLEANUP
        try? originalStore?.destroy()
    }

    func testInitWithArchiveURL() throws {
        // GIVEN
        let storeURL = directory.url.appending(filename: "stores-archive-latest.qst")

        // WHEN
        let store = try XCTUnwrap(Store(storeURL: storeURL, options: .create))
        defer { try? store.destroy() }

        // THEN entities can be opened
        XCTAssertEqual(try store.viewContext.count(for: MovieEntity.self), 0)
    }

    func testInitWithArchiveURLNoExtension() throws {
        // GIVEN
        let storeURL = directory.url.appending(filename: "stores-archive-latest")

        // WHEN
        let store = try XCTUnwrap(Store(storeURL: storeURL, options: .create))
        defer { try? store.destroy() }

        // THEN entities can be opened
        XCTAssertEqual(try store.viewContext.count(for: MovieEntity.self), 0)
    }

    func testInitWithPackageURL() throws {
        // GIVEN
        let storeURL = try makeQSTPackage()

        // WHEN
        let store = try XCTUnwrap(Store(storeURL: storeURL, options: .create))
        defer { try? store.destroy() }

        // THEN entities can be opened
        XCTAssertEqual(try store.viewContext.count(for: MovieEntity.self), 0)
    }

    // MARK: - Remove All

    func testRemoveAll() throws {
        // GIVEN
        populate(store: store)

        print(try store.allMovies())
        let context = store.viewContext
        XCTAssertEqual(try context.count(for: MovieEntity.self), 5)

        // WHEN
        store.removeAll()

        // THEN both message and metadata are removed
        XCTAssertEqual(try context.count(for: MovieEntity.self), 0)
    }
}
