//  I, Prerak Patel, student number 000825410, certify that this material is my original work. No other person's work has been used without due acknowledgement and I have not made my work available to anyone else.
//  MoviesViewController.swift
//  IMDb
//
//  Created by Prerak Patel on 2020-12-08.
//  Copyright © 2020 Mohawk College. All rights reserved.
//

import UIKit

// classing extening UICollectionViewController
class MoviesViewController: UICollectionViewController {
    
    // Creating movies array
    var movies = [Movie]()
    
    // declaring the session with the config
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config)
    }()
    
    // declaring an instance of imageStore Class
    let imageStore = ImageStore()
    
    // overriding view will appear to refresh the collection view data every time the user accesses MoviesViewController
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // reloading collection data
        collectionView.reloadSections(IndexSet(integer: 0))
    }
    
    // overriding numberOfItemsInSection to return total number of movies
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    // overriding cellforItemAt to inflate data into each collection view
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // retrieving reusable cells, here MovieCell is extending UICollectionViewCell
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        
        // getting the movies data for each movie using indexPath.row
        let movie = movies[indexPath.row]
        
        // checking if the movie.Title is empty, "Placeholder" or "N/A" then we display movie_reel image on the MoviesViewController
        if movie.Title == "" || movie.Title == "Placeholder" || movie.Title == "N/A" {
            // setting movie_reel image
            cell.imageView?.image = UIImage.init(named: "movie_reel")
        } else {
            // setting photoKey to imdbID
            let imageKey = movie.imdbID
            
            // checking for the poster of the movie is not "N/A"
            if movie.Poster != "N/A" {
                // retrieving image from the imageStore using the imageKey
                if let image = imageStore.image(forKey: imageKey) {
                    // setting image to the collection view cell image
                    cell.imageView.image = image
                } else {
                    
                    // creating and URL request to convert the string movie poster to URL request
                    let request = URLRequest(url: URL(string: movie.Poster!)!)
                    // creating a session dataTask using request
                    let task = session.dataTask(with: request) {
                        (data, response, error) in
                        // processing an image using processImageRequest method
                        let result = self.processImageRequest(data: data, error: error)
                        
                        // converting result into image
                        if case let .success(image) = result {
                            // if the result is conveted successfully to an image then download the image to the file system using imageStore setImage method by passing imageKey
                            self.imageStore.setImage(image, forKey: imageKey)
                            // as we are changing collection view cell image we have to run that in main thread as it is changing the UI
                            OperationQueue.main.addOperation {
                                cell.imageView.image = image
                            }
                        }
                    }
                    task.resume()
                }
            } else {
                // if the movie poster is not declared then setting the poster image to the default movie_reel image
                cell.imageView?.image = UIImage.init(named: "movie_reel")
            }
        }
        // returning cell to display that cell into collection view cell
        return cell
    }
    
    // action method if the user clicks on add bar button item
    @IBAction func newMovie(_ sender: UIBarButtonItem) {
        // creating a new movie instance
        let movie = Movie()
        // appending movie to movies array
        movies.append(movie)
        // adding new collection view cell at the very end by subsctracting 1 from the end 
        let indexPath = IndexPath(row: movies.count - 1, section: 0)
        // insert items into collection view
        collectionView.insertItems(at: [indexPath])
    }
    
    // overriding prepare function for the segue to send movie details to DetailViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // retrieving selectedIndex from the collection view
        if let selectedIndex = collectionView.indexPathsForSelectedItems?.first {
            // retrieving movie from the movies arrays
            let movie = movies[selectedIndex.row]
            let detailViewController = segue.destination as! DetailViewController
            // setting the value of movie in detailViewController to movie
            detailViewController.movie = movie
        }
    }
    
    // this function is used to process image request
    private func processImageRequest(data: Data?, error: Error?) -> Result<UIImage, Error> {
        // converting the string image to UIImage
        guard let imageData = data, let image = UIImage(data: imageData) else {
            // Couldn't create an image
            if data == nil {
                return .failure(error!)
            } else {
                return .failure("Image Creation Error" as! Error)
            }
        }
        // returning the UIImage if it is successully converted
        return .success(image)
    }
}
