//
//  Episode.swift
//  MovieMetaData
//
//  Created by Sonny Back on 1/22/20.
//  Copyright © 2020 Sonny Back. All rights reserved.
//

import Foundation

/*
* Struct for representing a TV Episode object based on the JSON data returned
* from themoviedb.org api.
*/

struct Episode: Codable {
    
    var id: Int // id assigned by themoviedb.org's api
    var name: String
    var overview: String // episode description/overview
    var episodeNumber: String
    var seasonNumber: String
    var airDate: String
    
    // needed for parsing the JSON with snakecase values
    private enum CodingKeys: String, CodingKey {
        //case results = "movie_results"
        case episodeNumber = "episode_number"
        case airDate = "air_date"
        case seasonNumber = "season_number"
        case id
        case name, overview
    }
}
