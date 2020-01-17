//
//  Root.swift
//  MovieMetaData
//
//  Created by SB on 12/31/19.
//  Copyright © 2019 SB. All rights reserved.
//

import Foundation

struct Root: Codable {
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case results = "movie_results"
    }
}
