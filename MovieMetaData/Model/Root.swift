//
//  Root.swift
//  MovieMetaData
//
//  Created by Sonny Back on 12/31/19.
//  Copyright © 2019 Sonny Back. All rights reserved.
//

import Foundation

struct Root: Codable {
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case results = "movie_results"
    }
}
