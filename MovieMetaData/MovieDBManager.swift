//
//  MovieDBManager.swift
//  MovieMetaData
//
//  Created by Sonny Back on 12/20/19.
//  Copyright © 2019 Sonny Back. All rights reserved.
//

import Foundation

struct MovieDBManager {
    
    let twoHundredResponseCode = 200 // success response code
    let apiKeyValue = "d5997ccfb530f271969a6246aa32254c" // my assigned moviedb.org api key
    let movieDBURL = "https://api.themoviedb.org/3/find/" // moviedb.org api url
    let imageFetchURL = "https://image.tmdb.org/t/p/original" // url for fetching movie images
    let apiKeyString = "?api_key="
    let languageSource = "&language=en-US&external_source=imdb_id"
    //var url: URL? = nil
    //var imdbMovieId: String // missing piece of url that is required for fetching data for movie
    var movie: Movie?
    
//    init(movie: Movie) {
//        //self.imdbMovieId = imdbMovieId
//        self.movie = movie
//    }
    
    /**
     * Method that handles creating the specific URL for each movie request.
     * @param imdbId: String
     *  @return urlString: String
     */
    func createURL(for imdbId: String) -> String {
        print("Entered createURL() for movieId: \(imdbId)")
        //return movieDBURL + imdbMovieId + apiKeyString + apiKeyValue + languageSource
        let urlString = movieDBURL + imdbId + apiKeyString + apiKeyValue + languageSource
        print("urlString: \(urlString)")
        return urlString
    }
    
    func fetchMovieDataFor(imdbId: String) {
        print("Entered fetchMovieDataFor(imdbId)...")
        
        guard let url = URL(string: createURL(for: imdbId)) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print("Error getting the URL:", error)
                return
            }
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let root = try decoder.decode(Root.self, from: data)
                print("Movie: \(root)")
            } catch let jsonError {
                print("JSON error: ", jsonError)
            }
        }.resume()
    }
    
//    func fetchMovies(for imdbId: String) {
//
//        let url = URL(string: createURL(for: imdbId))
//        let request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
//
//        let task = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
//            if let data = dataOrNil {
//                if let responseDictionary = try!  JSONSerialization.jsonObject(with: data, options: [])
//                    as? NSDictionary {
//                    print("Response: \(responseDictionary)")
//                }
//            }
//        })
//        task.resume()
//    }
    
    mutating func fetchJSON(for imdbId: String) -> Movie? {
        
        // url for the petition data in json
        let urlString = createURL(for: imdbId)
        
        // create the url from the urlString and try to fetch the data
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                print("We got the data...\(data)")
                return parse(json: data)
                //return // data fetch and parsing was successfull so we can exit
            }
        }
        // if we make it here, there was an error so return nil
        return nil
    }
    
    private mutating func parse(json: Data) -> Movie? {
        print("Entered parse(json)...")
        let decoder = JSONDecoder()
        var movies: [Movie]
        
        // parse the json data into the Petitions struct object
        if let jsonData = try? decoder.decode(Root.self, from: json) {
            movies = jsonData.results
            //print("JSON parsed! \(jsonData)")
            print("Movies returned: \(movies.count)")
            //self.movie = movies.first ?? nil
            if let movie = movies.first {
                print("Movie: \(movie)")
                return movie
            }
        } else {
            print("Error parsing the JSON!")
        }
        // if we get here something went wrong so return nil
        return nil
    }

    
//    func fetchMovies(from urlString: String) {
//        print("Entered fetchMovies()...")
//        let url = URL(string: urlString)
//        let request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringCacheData, timeoutInterval: 10)
//        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: .main)
//
//        let task = session.dataTask(with: request, completionHandler: { (dataOrNil, response, error) in
//            if let data = dataOrNil {
//                if let responseDictionary = try!  JSONSerialization.jsonObject(with: data, options: [])
//                    as? NSDictionary {
//                    print("Response: \(responseDictionary)")
//                }
//            }
//        })
//        task.resume()
//    }
//
//    func fetchData(completion: @escaping ([String:Any]?, Error?) -> Void) {
//        if let url = URL(string: createURL()) {
//            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//                guard let data = data else { return }
//                do {
//                    if let array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]{
//                        completion(array, nil)
//                        print("Success!")
//                    }
//                } catch {
//                    print(error)
//                    completion(nil, error)
//                }
//            }
//            task.resume()
//        }
//    }
    
//    func sendRequest(for url: String) {
//        print("Entered sendRequest()...")
//
//        if let url = URL(string: url) {
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                if let data = data {
//                    do {
//                        let res = try JSONDecoder().decode(Response.self, from: data)
//                        print(res)
//                    }
//                }
//            }
//        }
//    }
    
}
