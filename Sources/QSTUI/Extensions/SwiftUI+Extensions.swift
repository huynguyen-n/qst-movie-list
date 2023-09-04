//
//  SwiftUI+Extensions.swift
//  Movie List Demo iOS
//
//  Created by Huy Nguyen on 30/08/2023.
//

import SwiftUI

extension View {
    func invisible() -> some View {
        self.hidden().accessibilityHidden(true)
    }
}

/// Allows you to use `@StateObject` only for memory management (without observing).
final class IgnoringUpdates<T>: ObservableObject {
    var value: T
    init(_ value: T) { self.value = value }
}
