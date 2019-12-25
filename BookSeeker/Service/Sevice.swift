//
//  Sevice.swift
//  BookSeeker
//
//  Created by Narendra Dama on 12/24/19.
//  Copyright © 2019 CIT. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage
import Alamofire

typealias JSONDictionary = [String: Any]
class WebServices {
    let imageCache = NSCache<AnyObject, AnyObject>()
    // MARK: Get boooks
    // We hit the itunes.apple.com to the books information 
    func loadBooks(searchString: String, completion :@escaping ([Book]) -> Void) {
        let stringReplace = searchString.replacingOccurrences(of: " ", with: "+")
        let urlString = "\(ApiUrl.api)/search?term=\(stringReplace)&entity=ibook"
        let articlesBySourceURL = URL(string: urlString)!
        URLSession.shared.dataTask(with: articlesBySourceURL) { data, _, _ in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let booksDictionary = json as? JSONDictionary
                    let dictionaries = booksDictionary!["results"] as? [JSONDictionary]
                    let books = dictionaries!.compactMap(Book.init)
                    DispatchQueue.main.async {
                        completion(books)
                    }
                } catch let parsingError {
                    print("Error ", parsingError)
                }
            }
        }.resume()
    }
    // MARK: Get local saves
    // local searches are saved in NSUserDefaults. We call this function to retreive searches saved locally.
    func loadSaves(completion :@escaping ([Save], Error?) -> Void) {
        let defaults = UserDefaults.standard
        guard let savedSearchString = defaults.stringArray(forKey: Constants.savedSearchesKey) else {return}
        let savedSearches = savedSearchString.compactMap(Save.init)
        DispatchQueue.main.async {
            completion(savedSearches, Error.self as? Error)
        }
    }
    // MARK: Get stored images
    // Images are saves in local cache, if we cannot find locally we request images through alamofire image request.
    func retrieveImages(urlString: String, completion :@escaping (UIImage) -> Void) {
        // Alamofire is used to retreive the images, and also stored in cache.
        let replaced = urlString.replacingOccurrences(of: "100x100bb.jpg", with: "400x400bb.jpg")
        if let imageFromCache = self.imageCache.object(forKey: replaced as AnyObject) as? UIImage {
            DispatchQueue.main.async {
                completion(imageFromCache)
            }
        } else {
            AF.request(replaced).responseImage { (data) in
                do {
                    let str = try data.result.get()
                    let imageToCache  = str
                    self.imageCache.setObject(imageToCache, forKey: replaced as AnyObject)
                    DispatchQueue.main.async {
                        completion(imageToCache)
                    }
                } catch {
                    print("The file could not be loaded")
                }
            }
        }
    }
}
