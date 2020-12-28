//
//  DetailViewController.swift
//  IMDb
//
//  Created by Prerak Patel on 2020-12-08.
//  Copyright © 2020 Mohawk College. All rights reserved.
//

import UIKit

// class extending UIViewController
class DetailViewController: UIViewController {
    
    // Closure property if the movie is set then change the navigationItem title to the movie title
    var movie: Movie! {
        didSet {
            navigationItem.title = movie.Title
        }
    }

    // setting apikey for the OMDB API
    private let apiKey = "22707b2a"
    
    // Outlet for the movie title text field
    @IBOutlet var titleTextField: UITextField!
    // Outlet for the movie year label
    @IBOutlet var yearLabel: UILabel!
    // Outlet for the movie imdbID label
    @IBOutlet var imdbIDLabel: UILabel!
    // Outlet for the movie plot textView
    @IBOutlet var plotTextView: UITextView!
    
    // overriding view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // checking if the movie title is "placeholder"
        if movie.Title == "Placeholder" {
            // setting navigation item title to "New Movie"
            navigationItem.title = "New Movie"
        } else {
            // setting variables to the values from the movie
            // setting title text to movie title text
            titleTextField.text = movie.Title
            // setting year text to movie year text
            yearLabel.text = movie.Year
            // setting imdbID text to movie imdbID text
            imdbIDLabel.text = movie.imdbID
            // setting plot text to movie plot text
            plotTextView.text = movie.Plot
        }
    }
    
    // action method for the search button pressed
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        // check if the title text field text exists
        if let input = titleTextField.text {
            // changing the space value to "%20"
            let updatedSpaces = input.replacingOccurrences(of: " ", with: "%20")
            // creating url for the api call using input and the apikey
            let url = URL(string: "https://www.omdbapi.com/?t=\(updatedSpaces)&apikey=\(apiKey)")

            // creating a session task with the url
            let task = URLSession.shared.dataTask(with: url!) {
                data, response, error in
                
                // declaring the data received as jsonData
                if let jsonData = data {
                    OperationQueue.main.addOperation {
                        do {
                            // declaring the instance for the JSON decoder
                            let decoder = JSONDecoder()
                            // decoding the jsonData using Movie class value
                            let decodedMovie = try decoder.decode(Movie.self, from: jsonData)
                            // declaring title label text to decoded movie title
                            self.titleTextField.text = decodedMovie.Title
                            // declaring year label text to decoded movie year
                            self.yearLabel.text = decodedMovie.Year
                            // declaring imdbID label text to decoded imdbID text
                            self.imdbIDLabel.text = decodedMovie.imdbID
                            // declaring plot label text to decoded movie plot text
                            self.plotTextView.text = decodedMovie.Plot
                            // declaring poster string text to decoded movie poster text
                            self.movie.Poster = decodedMovie.Poster
                            // declaring movie title value to decoded movie title
                            self.movie.Title = decodedMovie.Title
                        } catch {
                            // if there are no results found for the url
                            // then empty all the labels and declare year label to "Not Found"
                            self.titleTextField.text = ""
                            self.yearLabel.text = "Not Found"
                            self.imdbIDLabel.text = ""
                            self.plotTextView.text = ""
                            
                            // if the url is not found then reinitializing movie data
                            self.movie.Title = "Placeholder"
                            self.movie.Year = ""
                            self.movie.imdbID = ""
                            self.movie.Plot = ""
                            self.movie.Poster = ""
                            self.navigationItem.title = "New Movie"
                        }
                    }
                } else {
                    // logging if there is no data found for the URL
                    print("No data")
                }
            }
            task.resume()
        }
    }
    
    // overriding view will disapper function to store the values for year,imdbID and plot to movie
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // check if the yearLabel is not empty and "Not Found" then store the values
        if yearLabel.text != "" && yearLabel.text != "Not Found" {
            // storing year label text to movie Year
            movie.Year = yearLabel.text!
            // storing imdbID label text to movie imdbID
            movie.imdbID = imdbIDLabel.text!
            // storing plot label text to movie plot
            movie.Plot = plotTextView.text!
        }
    }
    
    // Function triggers when the user wants the keyboard to disapper
    @IBAction func makeKeyboardDisappear(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

