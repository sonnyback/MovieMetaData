//
//  ViewController.swift
//  MovieMetaData
//
//  Created by SB on 12/20/19.
//  Copyright © 2019 SB. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var okButton: NSButton!
    @IBOutlet var imdbIdInputField: NSTextField!
    @IBOutlet var textDisplayField: NSTextField! // displays text output of activity
    @IBOutlet var imageView: NSImageView! // for displaying movie image
    lazy var movieDBManager = MovieDBManager()
    lazy var image: NSImage? = NSImage()
    var saveFolderPath: String? { // path of where to save the XML file
        didSet {
            okButton.isEnabled = true // activate ok button once we have a save path
            //print("Saving file to: \(self.saveFolderPath!)")
        }
    }
    var imdbMovieID: String {
        return imdbIdInputField.stringValue
    }
    @IBOutlet var clearButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("Entered viewDidLoad...")
        okButton.isEnabled = false // disabled until user selects save path
        imageView.image = NSImage(named: "search-50")
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
            textDisplayField.stringValue = "IMDB id: \(movieId)" // show the imdb id in the text view
            // process the request on a background thread
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                self?.processRequest(for: movieId)
            }
        }
    }
    
    /*
     * Method that handles clearing the text field
     */
    @IBAction func clearButtonClicked(_ sender: NSButton) {
        print("Entered clearButtonClicked()...")
        if !imdbIdInputField.stringValue.isEmpty {
            imdbIdInputField.stringValue = ""
        }
        textDisplayField.stringValue = ""
        imageView.image = NSImage(named: "search-50")
        okButton.isEnabled = false // deactivate until user selects save path again
    }
    
    /*
     * Method that handles getting the local path for saving the XML
     * file and image file. This must set in order to get the movie
     * details.
     * @param sender: NSButton
     */
    @IBAction func saveButtonClicked(_ sender: NSButton) {
        print("Entered saveButtonClicked()...")
        let openPanel = NSOpenPanel()
        openPanel.canChooseFiles = false
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.title = "Select a folder"

        openPanel.beginSheetModal(for:self.view.window!) { (response) in
            if response.rawValue == NSApplication.ModalResponse.OK.rawValue {
                let selectedPath = openPanel.url!.path
                // do whatever you what with the file path
                print("Folder to save to...\(selectedPath)")
                self.saveFolderPath = selectedPath
                self.textDisplayField.stringValue += "Saving output to: \(selectedPath)"
            }
            openPanel.close()
        }
    }
    
    /*
     * Method that handles the request after the OK button is pressed.
     * It's responsible for making the call to fetch and parse the JSON,
     * update the display text, and make the calls to write the XML and JPG
     * files to the local save directory.
     * @param imdbId: String
     */
    private func processRequest(for imdbId: String) {
        print("Entered processRequest(for: \(imdbId)")
        // make sure there is a path to save the XML file to disk
        if let saveToPath = saveFolderPath {
            
            // retrieve the JSON data from the api and set the movie object
            if var movie = movieDBManager.fetchJSON(for: imdbId) {
                // get the string respresentation of the genres(Ints)
                movie.genre = movie.getGenreStringFrom(array: movie.genreIds)
                
                DispatchQueue.main.async {
                    self.textDisplayField.stringValue += "\n\nTitle: \(movie.title)\n\nRelease Date: \(movie.releaseDate)\n\nGenre: \(movie.genre)\n\nOverview: \(movie.overview)\n"
                }
                
                print("Writing file to: \(saveToPath)")
                
                /******* Write the XML file to the disk! *******/
                DispatchQueue.main.async {
                    if XMLWriter.writeXMLOutputFor(movie: movie, to: saveToPath) {
                        self.textDisplayField.stringValue += "\n\(saveToPath)/\(movie.title).xml written successfully!"
                    } else {
                        self.textDisplayField.stringValue += "Dang! Error trying to save the XML file to the disk."
                    }
                }
                
                // retrieve the movie's poster image
                if let image = retrieveImageFrom(path: URL(string: movieDBManager.imageFetchURL + movie.posterPath)!) {
                    print("We got the image!!!")
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.imageView.image = image
                    }
                    
                    /******* Write the image file to the disk! *******/
                    if save(posterImage: image, to: saveToPath, for: movie.title) {
                        DispatchQueue.main.async {
                            self.textDisplayField.stringValue += "\n\(saveToPath)/\(movie.title).jpg written successfully!"
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.textDisplayField.stringValue += "Dang! Error trying to save the image file to the disk."
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.textDisplayField.stringValue += "Opps! Error trying to retrieve the image file!"
                    }
                    print("Error retrieving image file!")
                }
            } else {
                print("Error: nil was returned instead of a Movie")
                DispatchQueue.main.async {
                    self.textDisplayField.stringValue = "Error! Wanted a movie but got nil! 😤🤬"
                }
            }
        } else {
            print("Yikes! No save path!")
        }
    }
    
    /*
     * Method that retrieves the image from the URL
     * @param path: URL
     * @return NSImage?
     */
    private func retrieveImageFrom(path: URL) -> NSImage? {
        print("Retrieving image from: \(path)")
        return NSImage(contentsOf: path) ?? nil
    }
    
    /*
     * Method that writes the movie's poster/cover image to the local disk.
     * @param posterImage: NSImage - the movie's cover image
     * @param directory: String - directory to save the image to
     * @param title: String -
     */
    private func save(posterImage: NSImage, to directory: String, for title: String) -> Bool {
        print("Entered save(posterImage, to directory: \(directory)")
        var success = true // success/fail indicator
        let jpgFileExtension = ".jpg" // image file extension
        let outputURL = URL(fileURLWithPath: directory)
        let fileName = outputURL.appendingPathComponent(title+jpgFileExtension) // change this to a guard let
        
        // convert the image file to Data for file writing
        let properties = [NSBitmapImageRep.PropertyKey.compressionFactor: 1.0]
        let imageRep = NSBitmapImageRep(data: posterImage.tiffRepresentation!)
        let jpgData = imageRep?.representation(using: .jpeg, properties: properties)
        
        do {
            try jpgData?.write(to: fileName)
        } catch let error {
            print("Error saving image - \(error)")
            success = false
        }
        return success
    }
}
