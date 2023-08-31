//
//  MovieListEnvironment.swift
//  Movie List Demo iOS
//
//  Created by Huy Nguyen on 30/08/2023.
//

import Foundation
import Combine
import CoreData
import QST
import SwiftUI

/// Contains every dependency that the movie views have.
///
/// - warning: It's marked with `ObservableObject` to make it possible to be used
/// with `@StateObject` and `@EnvironmentObject`, but it never changes.
final class MovieListEnvironment: ObservableObject {

    let title: String
    let store: Store

    @Published var listOptions: MovieListOptions = .init()

    let router = MovieListRouter()

    init(store: Store) {
        self.title = "Movies"
        self.store = store
    }
}

// MARK: Environment

private struct StoreKey: EnvironmentKey {
    static let defaultValue: Store = .shared
}

private struct RouterKey: EnvironmentKey {
    static let defaultValue: MovieListRouter = .init()
}

extension EnvironmentValues {
    var store: Store {
        get { self[StoreKey.self] }
        set { self[StoreKey.self] = newValue }
    }

    var router: MovieListRouter {
        get { self[RouterKey.self] }
        set { self[RouterKey.self] = newValue }
    }
}

extension View {
    func injecting(_ environment: MovieListEnvironment) -> some View {
        self.background(MovieListRouterView()) // important: order
            .environmentObject(environment)
            .environmentObject(environment.router)
            .environment(\.router, environment.router)
            .environment(\.store, environment.store)
            .environment(\.managedObjectContext, environment.store.viewContext)
    }
}
