//
//  StoreBaseTests.swift
//  QSTTests
//
//  Created by Huy Nguyen on 03/09/2023.
//

import XCTest
import Foundation
import CoreData
import Combine
@testable import QST

class StoreBaseTests: XCTestCase {
    let directory = TemporaryDirectory()
    var storeURL: URL!
    var date: Date = Date()

    var store: Store!
    var cancellables: [AnyCancellable] = []

    override func setUp() {
        super.setUp()

        try? FileManager.default.createDirectory(at: directory.url, withIntermediateDirectories: true, attributes: nil)
        storeURL = directory.url.appending(filename: "test-store")
    }

    override func tearDown() {
        super.tearDown()

        try? store.destroy()
        directory.remove()

        try? FileManager.default.removeItem(at: URL.temp)
    }

    func makeStore() -> Store {
        return try! Store(storeURL: directory.url.appending(filename: UUID().uuidString))
    }

    func makeQSTPackage() throws -> URL {
        let storeURL = directory.url.appending(filename: UUID().uuidString)
        let store = try Store(storeURL: storeURL, options: .create)
        populate(store: store)
        try? store.close()
        return storeURL
    }
}
