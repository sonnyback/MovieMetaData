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
    lazy var movieDBManager = MovieDBManager()
    lazy var image: NSImage? = NSImage()
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
        // get the imdb id from the user input...this drives everything
        let movieId = imdbIdInputField.stringValue
        
        // TODO: change this to a guard let
        if movieId.isEmpty {
            print("Opps! You didn't enter an IMDB ID!")
            textDisplayField.stringValue = "Opps! You didn't enter an IMDB ID! Try again..."
        } else {
            textDisplayField.stringValue = "IMDB id: \(movieId)"
            // TODO: call this on a background thread
            // retrieve the JSON data from the api and set the movie object
            if var movie = movieDBManager.fetchJSON(for: movieId) {
                // get the string respresentation of the genres(Ints)
                movie.genre = movie.getGenreStringFrom(array: movie.genreIds)
                // retrieve the movie's poster image
                if let image = retrieveImageFrom(path: URL(string: movieDBManager.imageFetchURL + movie.posterPath)!) {
                    print("We got the image!!!")
                    imageView.image = image
                }
                textDisplayField.stringValue += "\n\nTitle: \(movie.title)\n\nRelease Date: \(movie.releaseDate)\n\nGenre: \(movie.genre)\n\nOverview: \(movie.overview)\n"
                XMLWriter.writeXMLOutputFor(movie: movie)
            } else {
                print("Error: nil was returned instead of a Movie")
                textDisplayField.stringValue = "Error! Wanted a movie but got nil! 😤🤬"
            }
        }
    }
    
    @IBAction func clearButtonClicked(_ sender: NSButton) {
        print("Entered clearButtonClicked()...")
        if !imdbIdInputField.stringValue.isEmpty {
            imdbIdInputField.stringValue = ""
        }
        textDisplayField.stringValue = ""
        imageView.image = nil
    }
    
    private func retrieveImageFrom(path: URL) -> NSImage? {
        return NSImage(contentsOf: path) ?? nil
    }
}

