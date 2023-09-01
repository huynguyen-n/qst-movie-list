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
    movies.forEach { store.storeMovie($0) } 
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
