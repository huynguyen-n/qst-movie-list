//
//  Store+Configuration.swift
//  QST
//
//  Created by Huy Nguyen on 03/09/2023.
//

import Foundation

extension Store {
    public struct Options: OptionSet, Sendable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// Creates store if the file is missing. The intermediate directories must
        /// already exist.
        public static let create = Options(rawValue: 1 << 0)

        /// Flushes entities to disk immediately and synchronously.
        public static let synchronous = Options(rawValue: 1 << 2)
    }
}
