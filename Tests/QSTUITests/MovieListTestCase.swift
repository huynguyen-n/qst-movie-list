//
//  MovieListTestCase.swift
//  QSTTests
//
//  Created by Huy Nguyen on 03/09/2023.
//

import XCTest
import Combine
@testable import QST
@testable import QSTUI

class MovieListTestCase: XCTestCase {
    var store: Store!
    let directory = TemporaryDirectory()
    var cancellables: [AnyCancellable] = []

    override func setUp() {
        super.setUp()

        let storeURL = directory.url.appendingPathComponent("\(UUID().uuidString).qst")
        store = try! Store(storeURL: storeURL, options: [.create, .synchronous])
        store.makeMockUIMovies()
    }

    override func tearDown() {
        super.tearDown()

        try? store.destroy()
        directory.remove()
    }
}
