//
//  Root.swift
//  MovieMetaData
//
//  Created by SB on 12/31/19.
//  Copyright © 2019 SB. All rights reserved.
//

import Foundation

struct Root: Codable {
    let movieResults: [Movie]
    let episodeResults: [Episode]
    
    enum CodingKeys: String, CodingKey {
        case movieResults = "movie_results"
        case episodeResults = "tv_episode_results"
    }
}
