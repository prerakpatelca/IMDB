//
//  ImageStore.swift
//  IMDB
//
//  Created by Brian Minaji on 2020-11-03.
//  Copyright © 2020 Mohawk College. All rights reserved.
//

import UIKit

// This class is created to download the image to the file system to reuse it later
class ImageStore {
    let cache = NSCache<NSString,UIImage>()
    
    // this function store an image to the file system
    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: key as NSString)
        
        // Create full url for image to store it in the file system
        let url = imageURL(forKey: key)
        // Turning image into JPEG data
        if let data = image.jpegData(compressionQuality: 0.5) {
            // Write it to full URL
            // Chances of failing to store an image is very low so we don't have catch
            try? data.write(to: url)
        }
    }
    
    // this function returns image from the disk if it exists in the file system
    // it accepts the key to the find that key in the file system
    func image(forKey key: String) -> UIImage? {
        
        // if the image is stored in the cache then it will return that existing image
        if let existingImage = cache.object(forKey: key as NSString) {
            return existingImage
        }
        
        // creating the URL to the image using the key
        let url = imageURL(forKey: key)
        // using the URL created above to find that photo key into the file system
        guard let imageFromDisk = UIImage(contentsOfFile: url.path) else {
            // returning nil if the image is not found in the file system
            return nil
        }
        
        // storing the image into cache found from the file system
        cache.setObject(imageFromDisk, forKey: key as NSString)
        // returning image
        return imageFromDisk
    }
    
    // this function is used to delete the image from the file system
    func deleteImage(forKey key: String) {
        // remove the image from the cache using the photo key
        cache.removeObject(forKey: key as NSString)
        
        // creating the URL to the image in the file system
        let url = imageURL(forKey: key)
        // trying to remove item from the file system and having do catch around it if the image does not exist
        do {
            // removing photo from the file system
            try FileManager.default.removeItem(at: url)
        } catch {
            // logging out to the console if the photo is not found into the file system
            print("Error removing the image from disk: \(error)")
        }
    }
    
    // this function creates image URL for the
    func imageURL(forKey key: String) -> URL {
        
        // get the reference to the directory using file manager
        let documentDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentDirectories.first!
        
        // returning the documentdirectory with the passed photo key
        return documentDirectory.appendingPathComponent(key)
    }
}
