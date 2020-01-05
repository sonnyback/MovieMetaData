//
//  XMLWriter.swift
//  MovieMetaData
//
//  Created by Sonny Back on 1/3/20.
//  Copyright © 2020 Sonny Back. All rights reserved.
//

import Foundation

struct XMLWriter {
    
    // constants for the tags
    static let tags = "Tags"
    static let tag = "Tag"
    static let fifty = "50"
    static let targets = "Targets"
    static let targetTypeValue = "TargetTypeValue"
    static let simpleTag = "Simple"
    static let nameTag = "Name"
    static let stringTag = "String"
    static let title = "TITLE"
    static let directorTag = "DIRECTOR"
    static let dateReleasedTag = "DATE_RELEASED"
    static let genreTag = "GENRE"
    static let descriptionTag = "DESCRIPTION"
    static let ratingTag = "RATING"
    
    static func writeXMLOutputFor(movie: Movie) {
        print("Entered XMLWriter.writeXMLOutputFor: \(movie.title)")
        
        /* static tags that are reused through the xml */
//        let simpleElement = XMLElement(name: simpleTag)
//        var nameElement = XMLElement(name: nameTag)
//        var stringElement = XMLElement(name: stringTag)
        
        // root element
        let rootElement = XMLElement(name: tags)
        let xml = XMLDocument(rootElement: rootElement)
        xml.characterEncoding = "UTF-8"
        
        // sub root element
        let tagElement = XMLElement(name: tag)
        rootElement.addChild(tagElement)
        
        // targets element
        let targetsElement = XMLElement(name: targets)
        let targetsTypeValueElement = XMLElement(name: targetTypeValue, stringValue: fifty)
        //rootElement.addChild(targetsElement)
        //targetsElement.addChild(targetsTypeValueElement)
        targetsElement.addChild(targetsTypeValueElement)
        tagElement.addChild(targetsElement)
        
        /** Start populating movie data  * */
        
        // Title
        let movieTitle = !movie.title.isEmpty ? movie.title : ""
        let simpleElementTitle = XMLElement(name: simpleTag)
        let nameElementTitle = XMLElement(name: nameTag, stringValue: title)
        let stringElementTitle = XMLElement(name: stringTag, stringValue: movieTitle)
        simpleElementTitle.addChild(nameElementTitle)
        simpleElementTitle.addChild(stringElementTitle)
        tagElement.addChild(simpleElementTitle)
        
//        nameElement.stringValue = title
//        stringElement.stringValue = movieTitle
//        simpleElement.addChild(nameElement)
//        simpleElement.addChild(stringElement)
//        tagElement.addChild(simpleElement)
        
        // Release Date
        let movieReleaseDate = !movie.releaseDate.isEmpty ? movie.releaseDate : ""
        let simpleElementReleaseDate = XMLElement(name: simpleTag)
        let nameElementReleaseDate = XMLElement(name: nameTag, stringValue: dateReleasedTag)
        let stringElementReleaseDate = XMLElement(name: stringTag, stringValue: movieReleaseDate)
        simpleElementReleaseDate.addChild(nameElementReleaseDate)
        simpleElementReleaseDate.addChild(stringElementReleaseDate)
        tagElement.addChild(simpleElementReleaseDate)
        
        // Genres
        //let genres = !movie.genreIds.isEmpty ? movie.genreIds : []
        let genre = !movie.genre.isEmpty ? movie.genre : ""
        let simpleElementGenres = XMLElement(name: simpleTag)
        let nameElementGenres = XMLElement(name: nameTag, stringValue: genreTag)
        let stringElementGenres = XMLElement(name: stringTag, stringValue: genre)
        simpleElementGenres.addChild(nameElementGenres)
        simpleElementGenres.addChild(stringElementGenres)
        tagElement.addChild(simpleElementGenres)
        
        // Description (Overview)
        let description = !movie.overview.isEmpty ? movie.overview : ""
        let simpleElementDescription = XMLElement(name: simpleTag)
        let nameElementDescription = XMLElement(name: nameTag, stringValue: descriptionTag)
        let stringElementDescription = XMLElement(name: stringTag, stringValue: description)
        simpleElementDescription.addChild(nameElementDescription)
        simpleElementDescription.addChild(stringElementDescription)
        tagElement.addChild(simpleElementDescription)
        
        
        print("XML: \(xml.xmlString)")
    }
}
