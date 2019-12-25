//
//  Constants.swift
//  BookSeeker
//
//  Created by Narendra Dama on 12/24/19.
//  Copyright © 2019 CIT. All rights reserved.
//

import Foundation
import UIKit
struct Constants {
    static let searchBarAccessbilityLabel = "searchBar"
    static let savedSearchesKey = "SavedSearches"
    static let searchBarPlaceholder = "Apple Books"
}
struct Cells {
    static let bookTableViewCell = "bookCell"
    static let savesTableViewCell = "recentSearches"
}
struct SegueIdentifier {
    static let showBooks = "booksSegue"
    static let showBookDetails = "bookDetails"
}
struct ApiUrl {
    static let api = "https://itunes.apple.com"
}
