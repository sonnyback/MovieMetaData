//
//  Movie.swift
//  MovieMetaData
//
//  Created by Sonny Back on 12/24/19.
//  Copyright © 2019 Sonny Back. All rights reserved.
//

import Foundation

struct Movie: Codable {
    
    //var imdbID = ""
    var id: Int
    var title: String
    var overview: String
    var genreIds: [Int] // array of ints - each genre is represented with an int
    var releaseDate: String
    var posterPath: String
//    let rating = ""
    
    private enum CodingKeys: String, CodingKey {
        //case results = "movie_results"
        case genreIds = "genre_ids"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case id
        case title, overview
    }
    
//    init(imdbID: String) {
//        self.imdbID = imdbID
//    }
}
