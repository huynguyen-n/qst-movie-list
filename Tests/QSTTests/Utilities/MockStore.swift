//
//  MockStore.swift
//  QSTTests
//
//  Created by Huy Nguyen on 03/09/2023.
//

import Foundation
import XCTest
@testable import QST

extension XCTestCase {

    func populate(store: Store) {
        let json = """
        [
            {
                "id": "URJXQKU1",
                "title": "Tenet",
                "descriptions": "Armed with only one word, Tenet, and fighting for the survival of the entire world, a Protagonist journeys through a twilight world of international espionage on a mission that will unfold in something beyond real time.",
                "thumbnail": "Tenet",
                "rating": 7.8,
                "duration": 150,
                "genre": ["Action", "Sci-Fi"],
                "releaseDate": "2020-09-03",
                "trailerURL": "https://www.youtube.com/watch?v=LdOM0x0XDMo",
            },
            {
                "id": "PPG6P5DN",
                "title": "Spider-Man: Into the Spider-Verse",
                "descriptions": "Teen Miles Morales becomes the Spider-Man of his universe, and must join with five spider-powered individuals from other dimensions to stop a threat for all realities.",
                "thumbnail": "Spider Man",
                "rating": 8.4,
                "duration": 117,
                "genre": ["Action", "Animation", "Adventure"],
                "releaseDate": "2018-12-14",
                "trailerURL": "https://www.youtube.com/watch?v=tg52up16eq0",
            },
            {
                "id": "AMDFXPNJ",
                "title": "Knives Out",
                "descriptions": "A detective investigates the death of a patriarch of an eccentric, combative family.",
                "thumbnail": "Knives Out",
                "rating": 7.9,
                "duration": 130,
                "genre": ["Comedy", "Crime", "Drama"],
                "releaseDate": "2019-11-27",
                "trailerURL": "https://www.youtube.com/watch?v=qGqiHJTsRkQ",
            },
            {
                "id": "WUAP6A7F",
                "title": "Guardians of the Galaxy",
                "descriptions": "A group of intergalactic criminals must pull together to stop a fanatical warrior with plans to purge the universe.",
                "thumbnail": "Guardians of the Galaxy",
                "rating": 8.0,
                "duration": 121,
                "genre": ["Action", "Adventure", "Comedy"],
                "releaseDate": "2014-08-01",
                "trailerURL": "https://www.youtube.com/watch?v=d96cjJhvlMA",
            },
            {
                "id": "HS78ELH2",
                "title": "Avengers: Age of Ultron",
                "descriptions": "When Tony Stark and Bruce Banner try to jump-start a dormant peacekeeping program called Ultron, things go horribly wrong and it's up to Earth's mightiest heroes to stop the villainous Ultron from enacting his terrible plan.",
                "thumbnail": "Avengers",
                "rating": 7.3,
                "duration": 151,
                "genre": ["Action", "Adventure", "Sci-Fi"],
                "releaseDate": "2015-05-01",
                "trailerURL": "https://www.youtube.com/watch?v=tmeOjFno6Do",
            }
        ]
        """
        do {
            let movies = try decodeJSON(data: json.data(using: .utf8)!)
            movies?
                .compactMap { $0 }
                .forEach { store.storeMovie($0) }
        } catch let error {
            XCTFail("Can not load JSON from movies.json with: \(error.localizedDescription)" )
        }
    }
}

