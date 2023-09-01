//
//  MovieCell.swift
//  Movie List Demo iOS
//
//  Created by Huy Nguyen on 30/08/2023.
//

import SwiftUI
import QST

struct MovieCell: View {

    let movie: MovieEntity

    var body: some View {
        VStack(alignment: .leading) {
            content
            Divider()
        }
        .listRowSeparator(.hidden)
    }

    @ViewBuilder
    private var content: some View {
        HStack(spacing: 8) {
            Image(movie.thumbnail)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 96)
                .cornerRadius(4)
                .shadow(radius: 8.0)
            text.dynamicTypeSize(...DynamicTypeSize.xxxLarge)
        }
        .padding(.bottom)
    }

    @ViewBuilder
    private var text: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(MovieCellConstants.fontTitle.weight(.bold))
            Text(descriptions)
                .font(MovieCellConstants.fontInfo.weight(.thin))
        }
    }

    private var title: String {
        [movie.title, movie.releaseDate.year].joined(separator: " ")
    }

    private var descriptions: String {
        [movie.duration.durationToString, movie.genre].joined(separator: " - ")
    }
}

private extension Date {
    var year: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return "(\(formatter.string(from: self)))"
    }
}

#if DEBUG
@available(iOS 15, *)
struct MovieCell_Previews: PreviewProvider {
    static var mockMovieEntity: MovieEntity {
        let context = try! Store.preview.container.viewContext
        let entity = MovieEntity(context: context)
        entity.title = "Tenet"
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyymmdd"
        if let date = formatter.date(from: "20230203") {
            entity.releaseDate = date
        }
        entity.duration = 157
        entity.genre = "Action, Animation, Adventure"
        return entity
    }

    static var previews: some View {
        MovieCell(movie: mockMovieEntity)
            .injecting(MovieListEnvironment(store: .mock))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
#endif


struct MovieCellConstants {
#if os(iOS)
    static let fontTitle = Font.headline.monospacedDigit()
    static let fontInfo = Font.caption.monospacedDigit()
#endif
}
