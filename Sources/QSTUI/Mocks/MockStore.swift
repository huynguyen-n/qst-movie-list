//
//  MockStore.swift
//  QSTUI
//
//  Created by Huy Nguyen on 30/08/2023.
//

import Foundation
import QST

private let rootURL = FileManager.default.temporaryDirectory.appendingPathComponent("qst-demo")

private let cleanup: Void = {
    try? FileManager.default.removeItem(at: rootURL)
    try! FileManager.default.createDirectory(at: rootURL, withIntermediateDirectories: true, attributes: nil)
}()

public extension Store {
    static let mock: Store = {
        let store = makeMockStore()
        _syncPopulateStore(store)
        return store
    }()

    static let preview = makeMockStore()

    func populate() {
        _syncPopulateStore(self)
    }
}

private func makeMockStore() -> Store {
    _ = cleanup

    let storeURL = rootURL.appendingPathComponent("\(UUID().uuidString).qst")
    return try! Store(storeURL: storeURL)
}

private func _syncPopulateStore(_ store: Store) {
    guard let movies = try? loadJson(fileName: "movies") else {
        return
    }
    movies.forEach { model in
        store.storeMovie(
            id: model.id,
            title: model.title,
            descriptions: model.descriptions,
            rating: model.rating,
            duration: model.duration,
            genre: model.genre,
            releaseDate: model.releaseDate,
            trailerURL: model.trailerURL
        )
    }
}

enum LoadJSONError: Error {
    case fileNotFound
    case readDataFailure
    case decodeFailure
}

private typealias Movie = Store.Event.MovieCreated

private func loadJson(fileName: String) throws -> [Movie]? {
    guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
        throw LoadJSONError.fileNotFound
    }

    guard let data = try? Data(contentsOf: url) else {
        throw LoadJSONError.readDataFailure
    }

    guard let movies = try? JSONDecoder().decode([Movie].self, from: data) else {
        throw LoadJSONError.decodeFailure
    }

    return movies
}
