//
//  Movie_List_Demo_iOSApp.swift
//  Movie List Demo iOS
//
//  Created by Huy Nguyen on 29/08/2023.
//

import SwiftUI
import QSTUI

@main
struct Movie_List_Demo_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationView {
                MovieView(store: .mock)
            }
            .accentColor(.black)
        }
    }
}
