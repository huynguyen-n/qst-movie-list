//
//  MovieListViewModel.swift
//  Movie List Demo iOS
//
//  Created by Huy Nguyen on 30/08/2023.
//

import Foundation
import CoreData
import QST
import Combine
import SwiftUI

final class MovieListViewModel: ObservableObject {

    var visibleEntities: [NSManagedObject] { entities }

    @Published private(set) var entities: [NSManagedObject] = []

    var isViewVisible = false {
        didSet {
            guard oldValue != isViewVisible else { return }
            if isViewVisible {
                resetDataSource(options: environment.listOptions)
            } else {
                dataSource = nil
            }
        }
    }

    private let store: Store
    private let environment: MovieListEnvironment
    private let movies: ManagedObjectsObserver<MovieEntity>
    private var dataSource: MovieListDataSource?
    private var cancellables: [AnyCancellable] = []

    init(environment: MovieListEnvironment) {
        self.store = environment.store
        self.environment = environment

        self.movies = .movies(for: store.viewContext)

        $entities.sink { [weak self] in
            print($0)
        }.store(in: &cancellables)

//        movies.$objects.dropFirst().sink { [weak self] in
//            self?.refreshPreviousSessionButton(sessions: $0)
//        }.store(in: &cancellables)

        environment.$listOptions.dropFirst().sink { [weak self] in
            self?.resetDataSource(options: $0)
        }.store(in: &cancellables)
    }

    private func resetDataSource(options: MovieListOptions) {
        dataSource = MovieListDataSource(store: store, options: options)
        dataSource?.delegate = self
//        filtersCancellable = filters.$options.sink { [weak self] in
        dataSource?.predicate = .init()
//        }
    }
}

extension MovieListViewModel: MovieListDataSourceDelegate {
    func dataSourceDidRefresh(_ dataSource: MovieListDataSource) {
        entities = dataSource.entities
    }

    func dataSource(_ dataSource: MovieListDataSource, didUpdateWith diff: CollectionDifference<NSManagedObjectID>?) {
        entities = dataSource.entities
    }
}
