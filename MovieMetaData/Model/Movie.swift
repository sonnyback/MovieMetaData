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
    var genre = "" // concatenated String version of the genres
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
    
    private enum Genres: String {
        case adventure = "Adventure"
        case fantasy = "Fantasy"
        case animation = "Animation"
        case drama = "Drama"
        case horror = "Horror"
        case action = "Action"
        case comedy = "Comedy"
        case history = "History"
        case western = "Western"
        case thriller = "Thriller"
        case crime = "Crime"
        case documentary = "Documentary"
        case scifi = "Science Fiction"
        case mystery = "Mystery"
        case music = "Music"
        case romance = "Romance"
        case family = "Family"
        case war = "War"
        case tv = "TV Movie"
    }
    
    func getGenreStringFrom(array: [Int]) -> String {
        //print("Entered getGenreStringFrom(array: \(array)...")
        
        var genreString = "" // genre string representation to be returned
        let separator = ", " // separator between multiple genres
        
        if array.isEmpty {
            print("Error: genre array is empty!")
        } else {
            for i in 0..<array.count {
                
                genreString += convertIntToString(for: array[i])
                
                // add separator between genres, except for last one
                if i != array.count - 1 {
                    genreString += separator
                }
            }
        }
        
        return genreString
    }
    
    private func convertIntToString(for genreId: Int) -> String {
        
        switch genreId {
            case 12: return Genres.adventure.rawValue
            case 14: return Genres.fantasy.rawValue
            case 16: return Genres.animation.rawValue
            case 18: return Genres.drama.rawValue
            case 27: return Genres.horror.rawValue
            case 28: return Genres.action.rawValue
            case 35: return Genres.comedy.rawValue
            case 36: return Genres.history.rawValue
            case 37: return Genres.western.rawValue
            case 53: return Genres.thriller.rawValue
            case 80: return Genres.crime.rawValue
            case 99: return Genres.documentary.rawValue
            case 878: return Genres.scifi.rawValue
            case 9648: return Genres.mystery.rawValue
            case 10402: return Genres.music.rawValue
            case 10749: return Genres.romance.rawValue
            case 10751: return Genres.family.rawValue
            case 10752: return Genres.war.rawValue
            case 10770: return Genres.tv.rawValue
            default: return "Unknown genre for \(genreId)"
        }
    }
    
    
//    init(imdbID: String) {
//        self.imdbID = imdbID
//    }
}
