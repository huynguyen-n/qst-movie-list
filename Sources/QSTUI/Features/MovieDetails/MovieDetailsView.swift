//
//  MovieDetailsView.swift
//  QSTUI
//
//  Created by Huy Nguyen on 01/09/2023.
//

import SwiftUI
import QST

struct MovieDetailsView: View {

    let movie: MovieEntity

    var body: some View {
        contents
            .navigationBarTitle("", displayMode: .inline)
    }

    private var contents: some View {
        VStack {
            _Header(movie: movie)
            shortDescription
            _Details(movie: movie)
        }
        .padding()
    }

    private var shortDescription: some View {
        Group {
            VStack(alignment: .leading) {
                Text("Short descriptions")
                    .font(MovieDetailsConstants.fontTitle2.weight(.bold))
                    .padding(.bottom)
                Text(movie.descriptions)
                    .font(MovieDetailsConstants.fontBody.weight(.regular))
                    .foregroundColor(Color(.lightGray))
                    .padding(.bottom)
                Divider()
                    .padding(.bottom)
            }
            .frame(maxWidth: .infinity)
        }
    }
}


struct _Header: View {

    let movie: MovieEntity

    var body: some View {
        HStack(alignment: .top) {
            ThumbnailImage(imageNamed: movie.thumbnail, size: .details)
            VStack(alignment: .leading) {
                titleRatingText
                _HeaderButtons(movie: movie)
            }
        }
        .padding(.bottom)
        Divider()
            .padding(.bottom)
    }

    private var titleRatingText: some View {
        HStack {
            Text(movie.title)
                .fixedSize(horizontal: false, vertical: true)
                .font(MovieDetailsConstants.fontTitle2.weight(.bold))
            Spacer()
            Text(rating)
                .font(MovieDetailsConstants.fontTitle2.weight(.bold))
        }
    }

    private var rating: AttributedString {
        var rate = AttributedString("\(movie.rating)")
        rate.font = MovieDetailsConstants.fontTitle.weight(.bold)
        var total = AttributedString("/10")
        total.font = MovieDetailsConstants.fontTitle2.weight(.light)
        total.foregroundColor = .lightGray
        return rate + total
    }
}

struct _HeaderButtons: View {
    let movie: MovieEntity
    @State private var isWachedList: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 24.0) {
            addedToWatchListButton
            watchTrailerButton
        }
    }

    private var addedToWatchListButton: some View {
        Button {
            Store.mock.toggleWatchedList(for: movie)
        } label: {
            Text((isWachedList ? "remove from watchlist" : "+ add to watch list").uppercased())
                .fixedSize(horizontal: true, vertical: false)
                .font(MovieDetailsConstants.fontSubHeadline.weight(.bold))
                .padding(12.0)
                .onReceive(movie.publisher(for: \.isWatchedList)) { isWachedList = $0 }
        }
        .foregroundColor(.gray)
        .background(Color(.lightGray).brightness(0.2))
        .clipShape(Capsule())
    }

    private var watchTrailerButton: some View {
        Button {
            print("watch trailer")
        } label: {
            Text("watch trailler".uppercased())
                .font(MovieDetailsConstants.fontSubHeadline.weight(.bold))
                .padding(8.0)
        }
        .foregroundColor(.black)
        .overlay(Capsule().stroke(lineWidth: 1.5))
    }
}

struct _Details: View {

    let movie: MovieEntity

    private enum Details: CaseIterable {
        case genre, releasedDate

        var value: String {
            switch self {
            case .genre: return "Genre"
            case .releasedDate: return "Release date"
            }
        }
    }

    private var detailsValues: [[Details: String]] {
        [
            [.genre: movie.genre,],
            [.releasedDate: movie.releaseDate.formatted()]
        ]
    }

    var body: some View {
        VStack(alignment: .leading) {
            Text("Details")
                .font(MovieDetailsConstants.fontTitle2.weight(.bold))
                .padding(.bottom)
            VStack(alignment: .trailing) {
                ForEach(detailsValues, id:\.self) { item in
                    HStack {
                        Text(item.keys.first?.value ?? "")
                            .font(MovieDetailsConstants.fontBody.weight(.regular))
                            .frame(maxWidth: 120, alignment: .trailing)
                        Text(item.values.first ?? "")
                            .font(MovieDetailsConstants.fontBody.weight(.regular))
                            .foregroundColor(Color(.lightGray))
                        Spacer()
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

#if DEBUG
struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movie: Store.mock.makeMockMovie())
    }
}
#endif

struct MovieDetailsConstants {
#if os(iOS)
    static let fontTitle2 = Font.title2.monospacedDigit()
    static let fontTitle = Font.title.monospacedDigit()
    static let fontSubHeadline = Font.subheadline.monospacedDigit()
    static let fontBody = Font.body.monospacedDigit()
#endif
}
