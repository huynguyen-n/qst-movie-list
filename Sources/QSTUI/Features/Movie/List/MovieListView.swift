//
//  MovieListView.swift
//  Movie List Demo iOS
//
//  Created by Huy Nguyen on 29/08/2023.
//

import Combine
import SwiftUI
import QST

struct MovieListView: View {

    @EnvironmentObject var environment: MovieListEnvironment

    var body: some View {
        _InternalMovieListView(environment: environment)
    }
}

private struct _InternalMovieListView: View {

    private let environment: MovieListEnvironment
    @StateObject private var listViewModel: IgnoringUpdates<MovieListViewModel>
    
    init(environment: MovieListEnvironment) {
        self.environment = environment

        let listViewModel = MovieListViewModel(environment: environment)

        _listViewModel = StateObject(wrappedValue: IgnoringUpdates(listViewModel))
    }

    var body: some View {
        contents
            .environmentObject(listViewModel.value)
            .onAppear { listViewModel.value.isViewVisible = true }
            .onDisappear { listViewModel.value.isViewVisible = false }
    }

    @ViewBuilder private var contents: some View {
        _MovieListView()
    }
}

private struct _MovieListView: View {
    @Environment(\.store) private var store

    var body: some View {
        List {
            MovieListContentView()
        }
        .listStyle(.plain)
    }
}
