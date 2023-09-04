//
//  MovieListViewModelTests.swift
//  QSTTests
//
//  Created by Huy Nguyen on 04/09/2023.
//

import XCTest
import Combine
import CoreData
@testable import QST
@testable import QSTUI

final class MovieListViewModelTests: MovieListTestCase {
    var environment: MovieListEnvironment!
    var sut: MovieListViewModel!

    override func setUp() {
        super.setUp()

        setUp(store: store)
    }

    private func setUp(store: Store) {
        self.store = store
        self.environment = MovieListEnvironment(store: store)
        self.sut = MovieListViewModel(environment: environment)
        self.sut.isViewVisible = true
    }

    func testThatAllMoviesAreLoadedByDefault() {
        // GIVEN
        let entities = sut.entities

        // THEN
        XCTAssertEqual(entities.count, 5)
        XCTAssertTrue(entities is [MovieEntity])
    }

    func testThatEntitiesAreOrderedByTitle() {
        // WHEN
        environment.listOptions.sortBy = .title
        environment.listOptions.order = .ascending

        // THEN
        XCTAssertEqual(
            sut.entities,
            (sut.entities as! [MovieEntity]).sorted(by: { $0.title < $1.title })
        )
    }

    func testThatEntitiesAreOrderedByTitleDescending() {
        // WHEN
        environment.listOptions.sortBy = .title
        environment.listOptions.order = .descending

        // THEN
        XCTAssertEqual(
            sut.entities,
            (sut.entities as! [MovieEntity]).sorted(by: { $0.title > $1.title })
        )
    }

    func testThatEntitiesAreOrderedByReleaseDate() {
        // WHEN
        environment.listOptions.sortBy = .releaseDate
        environment.listOptions.order = .ascending

        // THEN
        XCTAssertEqual(
            sut.entities,
            (sut.entities as! [MovieEntity]).sorted(by: { $0.releaseDate < $1.releaseDate })
        )
    }

    func testThatEntitiesAreOrderedByReleaseDateDescending() {
        // WHEN
        environment.listOptions.sortBy = .releaseDate
        environment.listOptions.order = .descending

        // THEN
        XCTAssertEqual(
            sut.entities,
            (sut.entities as! [MovieEntity]).sorted(by: { $0.releaseDate > $1.releaseDate })
        )
    }
}
