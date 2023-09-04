//
//  Helpers.swift
//  QSTUI
//
//  Created by Huy Nguyen on 03/09/2023.
//

import Foundation
@testable import QST

struct TemporaryDirectory {
    let url: URL

    static var isFirstRun = true

    init() {
        let rootTempURL = Files.temporaryDirectory
            .appending(directory: "com.github.qst.testing")

        if TemporaryDirectory.isFirstRun {
            TemporaryDirectory.isFirstRun = false
            try? Files.removeItem(at: rootTempURL)
        }

        url = rootTempURL.appending(directory: UUID().uuidString)
        try? Files.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
    }

    func remove() {
        try? FileManager.default.removeItem(at: url)
    }
}
