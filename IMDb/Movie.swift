//
//  Movie.swift
//  IMDb
//
//  Created by Prerak Patel on 2020-12-08.
//  Copyright © 2020 Mohawk College. All rights reserved.
//

import Foundation

class Movie: Codable {
    
    // Movie Title name
    var Title: String
    // Movie Year release
    var Year: String
    // Plot of the Movie
    var Plot: String?
    // Poster URL string of the Movie
    var Poster: String?
    // imdbID of the Movie
    var imdbID: String
    
    // Initializer to give raw data when new movie object is created
    init() {
        Title = "Placeholder"
        Year = ""
        Plot = ""
        Poster = ""
        imdbID = ""
    }
}
