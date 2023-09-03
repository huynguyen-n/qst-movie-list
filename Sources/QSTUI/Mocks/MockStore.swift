//
//  MockStore.swift
//  QSTUI
//
//  Created by Huy Nguyen on 30/08/2023.
//

import Foundation
import QST

private let rootURL = FileManager.default.temporaryDirectory.appendingPathComponent("qst-demo")

public extension Store {
    static let mock: Store = {
        let store = try! Store(storeURL: rootURL)
        _syncPopulateStore(store)
        return store
    }()

    static let preview = try! Store(storeURL: rootURL)

    func populate() {
        _syncPopulateStore(self)
    }

    func makeMockMovie() -> MovieEntity {
        guard let movie = try? loadJson()?.first else {
            fatalError("Can not load JSON")
        }
        let entity = MovieEntity(context: viewContext)
        entity.id = movie.id
        entity.title = movie.title
        entity.descriptions = movie.descriptions
        entity.descriptions = movie.descriptions
        entity.thumbnail = movie.thumbnail
        entity.rating = movie.rating
        entity.duration = movie.duration
        entity.genre = movie.genre.joined(separator: ", ")
        entity.releaseDate = movie.releaseDate
        entity.trailerURL = movie.trailerURL
        return entity
    }
}

private func _syncPopulateStore(_ store: Store) {
    guard (try? store.allMovies())?.isEmpty == true else {
        return
    }
    let movies = try? loadJson()
    movies?.forEach { store.storeMovie($0) }
}

enum LoadJSONError: Error {
    case fileNotFound
    case readDataFailure
    case decodeFailure
}

private typealias Movie = Store.Event.MovieCreated

private func loadJson() throws -> [Movie]? {
    guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
        throw LoadJSONError.fileNotFound
    }

    guard let data = try? Data(contentsOf: url) else {
        throw LoadJSONError.readDataFailure
    }

    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .formatted(.customDateFormatter)
    guard let movies = try? decoder.decode([Movie].self, from: data) else {
        throw LoadJSONError.decodeFailure
    }

    return movies
}

private extension DateFormatter {
    static let customDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-mm-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}
