//
//  MovieListRouter.swift
//  Movie List Demo iOS
//
//  Created by Huy Nguyen on 30/08/2023.
//

import SwiftUI
import CoreData

final class MovieListRouter: ObservableObject {
    @Published var isShowingFilters = false
}

struct MovieListRouterView: View {
    @EnvironmentObject var environment: MovieListEnvironment
    @EnvironmentObject var router: MovieListRouter

    var body: some View {
        if #available(iOS 15, *) {
            contents
        }
    }
}

extension MovieListRouterView {
    var contents: some View {
        Text("").invisible()
            .sheet(isPresented: $router.isShowingFilters) { destinationFilters }
    }

    private var destinationFilters: some View {
        NavigationView { }
    }
}
