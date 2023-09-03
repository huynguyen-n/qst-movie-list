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
    @State private var isWatchedList = false

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
            ThumbnailImage(imageNamed: movie.thumbnail, size: .list)
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
            _OnMyWatchListLabel(isWachedList: isWatchedList)
                .padding(.top, 24.0)
                .onReceive(movie.publisher(for: \.isWatchedList)) { isWatchedList = $0 }
        }
    }

    private var title: String {
        [movie.title, movie.releaseDate.year].joined(separator: " ")
    }

    private var descriptions: String {
        [movie.duration.durationToString, movie.genre].joined(separator: " - ")
    }
}

struct _OnMyWatchListLabel: View {
    let isWachedList: Bool

    var body: some View {
        if isWachedList {
            Text("on my watch list".uppercased())
                .font(MovieDetailsConstants.fontSubHeadline.weight(.bold))
                .padding(8.0)
                .foregroundColor(.gray)
                .background(Color(.lightGray).brightness(0.3))
                .clipShape(Capsule())
        } else {
            EmptyView()
        }
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
struct MovieCell_Previews: PreviewProvider {
    static var previews: some View {
        MovieCell(movie: Store.mock.makeMockMovie())
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
