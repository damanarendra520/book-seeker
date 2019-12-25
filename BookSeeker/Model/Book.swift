//
//  Book.swift
//  BookSeeker
//
//  Created by Narendra Dama on 12/24/19.
//  Copyright © 2019 CIT. All rights reserved.
//

import Foundation

struct Book: Codable {
    var name: String
    var photoUrl: String
    var censorName: String
    var artistName: String
    var currency: String
    var price: String
    var details: String
    var publisherDescription: String
    var userRating: Double
    init?(dictionary: JSONDictionary) {
        guard let name = dictionary["trackName"] as? String,
                let photoUrl = dictionary["artworkUrl100"] as? String,
                let censorName = dictionary["trackCensoredName"] as? String,
                let artistName = dictionary["artistName"] as? String,
                let currency = dictionary["currency"] as? String,
                let price = dictionary["formattedPrice"] as? String,
                let details = dictionary["trackViewUrl"] as? String,
                let description = dictionary["description"] as? String,
                let userRating = dictionary["averageUserRating"] as? Double else {
                    return nil
        }
        self.name                   = name
        self.photoUrl               = photoUrl
        self.censorName             = censorName
        self.artistName             = artistName
        self.currency               = currency
        self.price                  = price
        self.details                = details
        self.publisherDescription   = description
        self.userRating             = userRating
    }
    init(viewModel: BookViewModel) {
        self.name                   = viewModel.name
        self.photoUrl               = viewModel.photoUrl
        self.censorName             = viewModel.censorName
        self.artistName             = viewModel.artistName
        self.currency               = viewModel.currency
        self.price                  = viewModel.price
        self.details                = viewModel.details
        self.publisherDescription   = viewModel.bookDescription
        self.userRating             = viewModel.userRating
    }
}
