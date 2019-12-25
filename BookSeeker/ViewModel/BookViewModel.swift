//
//  BookViewModel.swift
//  BookSeeker
//
//  Created by Narendra Dama on 12/24/19.
//  Copyright © 2019 CIT. All rights reserved.
//

import Foundation

class BookListViewModel: NSObject {
    @objc dynamic var booksViewModels: [BookViewModel] = [BookViewModel]()
    private var webservice: WebServices
    private var token: NSKeyValueObservation?
    private var searchString: String = ""
    var bindToBookViewModels :(() -> Void) = {}
    init(searchString: String, webservice: WebServices) {
        self.webservice = webservice
        self.searchString = searchString
        super.init()
        token = self.observe(\.booksViewModels) {_, _ in
            self.bindToBookViewModels()
        }
        // call populate Books
        populateBooks()
    }
    func populateBooks() {
        self.webservice.loadBooks(searchString: searchString) { [unowned self] sources in
            self.booksViewModels = sources.compactMap(BookViewModel.init)
        }
    }
    func source(at index: Int) -> BookViewModel {
        return self.booksViewModels[index]
    }
}

class BookViewModel: NSObject {
    var name: String
    var photoUrl: String
    var censorName: String
    var artistName: String
    var currency: String
    var price: String
    var details: String
    var bookDescription: String
    var userRating: Double
    init(book: Book) {
        self.name               =   book.name
        self.photoUrl           =   book.photoUrl
        self.censorName         =   book.censorName
        self.artistName         =   book.artistName
        self.currency           =   book.currency
        self.price              =   book.price
        self.details            =   book.details
        self.bookDescription    =   book.publisherDescription
        self.userRating         =   book.userRating
    }
}
