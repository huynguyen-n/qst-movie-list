//
//  Helpers.swift
//  Movie
//
//  Created by Huy Nguyen on 29/08/2023.
//

import Foundation

var Files: FileManager { FileManager.default }

extension FileManager {
    @discardableResult
    func createDirectoryIfNeeded(at url: URL) -> Bool {
        guard !fileExists(atPath: url.path) else { return false }
        try? createDirectory(at: url, withIntermediateDirectories: true, attributes: [:])
        return true
    }
}

extension URL {
    func appending(filename: String) -> URL {
        appendingPathComponent(filename, isDirectory: false)
    }

    func appending(directory: String) -> URL {
        appendingPathComponent(directory, isDirectory: true)
    }

    static var temp: URL {
        let url = Files.temporaryDirectory
            .appending(directory: "com.qst.movie")
        Files.createDirectoryIfNeeded(at: url)
        return url
    }

    static var main: URL {
        let searchPath = FileManager.SearchPathDirectory.libraryDirectory
        var url = Files.urls(for: searchPath, in: .userDomainMask).first?
            .appending(directory: "Stores")
            .appending(directory: "com.qst.movie.store")  ?? URL(fileURLWithPath: "/dev/null")
        if !Files.createDirectoryIfNeeded(at: url) {
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try? url.setResourceValues(resourceValues)
        }
        return url
    }
}

public extension Int {
    var durationToString: String {
        let time = (hours: self / 60, mins: (self % 60))
        return "\(time.hours)h \(time.mins)min"
    }
}

enum LoadJSONError: Error {
    case fileNotFound
    case readDataFailure
    case decodeFailure
}

public typealias Movie = Store.Event.MovieCreated

public func loadJson() throws -> [Movie]? {
    guard let url = Bundle.main.url(forResource: "movies", withExtension: "json") else {
        throw LoadJSONError.fileNotFound
    }

    guard let data = try? Data(contentsOf: url) else {
        throw LoadJSONError.readDataFailure
    }

    return try decodeJSON(data: data)
}

public func decodeJSON(data: Data) throws -> [Movie]? {
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
