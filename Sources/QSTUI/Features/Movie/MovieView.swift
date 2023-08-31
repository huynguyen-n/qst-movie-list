//
//  MovieView.swift
//  Movie List Demo iOS
//
//  Created by Huy Nguyen on 30/08/2023.
//

import QST

extension MovieView {
    public init(store: Store = .shared) {
        self.init(environment: .init(store: store))
    }
}
