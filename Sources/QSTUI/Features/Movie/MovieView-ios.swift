//
//  MovieView-ios.swift
//  Movie List Demo iOS
//
//  Created by Huy Nguyen on 30/08/2023.
//

import SwiftUI
import CoreData
import QST
import Combine

public struct MovieView: View {
    @StateObject private var environment: MovieListEnvironment // Never reloads

    init(environment: MovieListEnvironment) {
        _environment = StateObject(wrappedValue: environment)
    }

    public var body: some View {
        contents
    }

    private var contents: some View {
        MovieListView()
            .navigationTitle(environment.title)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
//                    trailingNavigationBarItems
                }
            }
            .injecting(environment)
    }

//    @ViewBuilder private var trailingNavigationBarItems: some View {
//        Button(action: { environment.router.isShowingShareStore = true }) {
//            Label("Share", systemImage: "square.and.arrow.up")
//        }
//        Button(action: { environment.router.isShowingFilters = true }) {
//            Image(systemName: "line.horizontal.3.decrease.circle")
//        }
//        ContextMenu()
//    }
}
