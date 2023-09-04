//
//  MovieContextMenu.swift
//  QSTUI
//
//  Created by Huy Nguyen on 03/09/2023.
//

import SwiftUI
import QST

struct MovieContextMenu: View {

    @EnvironmentObject private var environment: MovieListEnvironment
    @Environment(\.router) private var router

    var body: some View {
        Menu {
            Section {
                MovieListSortByMenu()
            }
            Section {
                if !environment.store.isArchive {
                    Button(role: .destructive, action: environment.store.removeAll) {
                        Label("Remove Movies", systemImage: "trash")
                    }
                }
            }
        } label: {
            Image(systemName: "ellipsis.circle")
        }
    }
}

private struct MovieListSortByMenu: View {
    @EnvironmentObject private var environment: MovieListEnvironment

    var body: some View {
        Menu(content: {
            Picker("Sort By", selection: $environment.listOptions.sortBy) {
                ForEach(MovieListOptions.SortBy.allCases, id: \.self) {
                    Text($0.rawValue).tag($0)
                }
            }
            Picker("Ordering", selection: $environment.listOptions.order) {
                Text("Descending").tag(MovieListOptions.Ordering.descending)
                Text("Ascending").tag(MovieListOptions.Ordering.ascending)
            }
        }, label: {
            Label("Sort By", systemImage: "arrow.up.arrow.down")
        })
    }
}

struct MovieContextMenu_Previews: PreviewProvider {
    static var previews: some View {
        MovieContextMenu()
    }
}
