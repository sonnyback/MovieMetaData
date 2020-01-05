//
//  ViewController.swift
//  MovieMetaData
//
//  Created by Sonny Back on 12/20/19.
//  Copyright © 2019 Sonny Back. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var imdbIdInputField: NSTextField!
    @IBOutlet var textDisplayField: NSTextField! // displays text output of activity
    @IBOutlet var imageView: NSImageView! // for displaying movie image
    //lazy var movie = Movie(imdbID: imdbMovieID)
    //lazy var movieDBManager = MovieDBManager(imdbMovieId: movie.imdbID)
    //lazy var movieDBManager = MovieDBManager(movie: movie)
    lazy var movieDBManager = MovieDBManager()
    var imdbMovieID: String {
        return imdbIdInputField.stringValue
    }
    
    @IBOutlet var clearButton: NSButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Entered viewDidLoad...")
        //print("MovieDB url: \(movieDBManager.movieDBURL)")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction private func okButtonClicked(_ sender: NSButton) {
        print("Entered okButtonClicked()...")
        
        let movieId = imdbIdInputField.stringValue
        //var movie: Movie
        
        if movieId.isEmpty {
            print("Opps! You didn't enter an IMDB ID!")
            textDisplayField.stringValue = "Opps! You didn't enter an IMDB ID! Try again..."
        } else {
            textDisplayField.stringValue = "IMDB id: \(movieId)"
            if var movie = movieDBManager.fetchJSON(for: movieId) {
                // get the string respresentation of the genres(Ints)
                movie.genre = movie.getGenreStringFrom(array: movie.genreIds)
                textDisplayField.stringValue += "\n\nTitle: \(movie.title)\n\nRelease Date: \(movie.releaseDate)\n\nGenre: \(movie.genre)\n\nOverview: \(movie.overview)\n"
                XMLWriter.writeXMLOutputFor(movie: movie)
            } else {
                print("Error: nil was returned instead of a Movie")
                textDisplayField.stringValue = "Error: nil was returned instead of a Movie"
            }
        }
    }
    
    @IBAction func clearButtonClicked(_ sender: NSButton) {
        print("Entered clearButtonClicked()...")
        if !imdbIdInputField.stringValue.isEmpty {
            imdbIdInputField.stringValue = ""
        }
        textDisplayField.stringValue = ""
    }
}

