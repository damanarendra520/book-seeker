//
//  BooksResultsViewController.swift
//  BookSeeker
//
//  Created by Narendra Dama on 12/24/19.
//  Copyright © 2019 CIT. All rights reserved.
//

import UIKit

class BooksResultsViewController: UITableViewController {

    var searchString: String = ""
    var urlString: String = ""
    var detailsNavigationTitle: String = ""
    var webservice: WebServices!
    var bookListViewModel: BookListViewModel!
    var dataSource: TableViewDataSource<BookCell, BookViewModel>!
    var bookViewModel: BookViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //makeNetworkCall()
        updateUI()
    }
    func updateUI() {
        self.title = searchString
        self.webservice = WebServices()
        self.bookListViewModel = BookListViewModel(searchString: searchString, webservice: self.webservice)
        // setting up the bindings
        self.bookListViewModel.bindToBookViewModels = {
            self.updateDataSource()
        }
    }
    func updateDataSource() {
        self.dataSource = TableViewDataSource(cellIdentifier: Cells.bookTableViewCell,
                                              items: self.bookListViewModel.booksViewModels) { cell, book in
            cell.bookName.text      = book.name
            cell.bookPrice.text     = book.price
            cell.bookArtist.text    = book.artistName
                                                self.webservice.retrieveImages(urlString: book.photoUrl) { (image) in
                                                    cell.bookImage.image = image
                                                }
        }
        self.tableView.dataSource = self.dataSource
        self.tableView.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIdentifier.showBookDetails {
            performSegueForShowSourceDetails(segue: segue)
        } else if segue.identifier == SegueIdentifier.showBooks {
            //
        }
    }
    func performSegueForShowSourceDetails(segue: UIStoryboardSegue) {
        guard let indexPath = self.tableView.indexPathForSelectedRow else {
            fatalError("indexPath not found")
        }
        let bookViewModel = self.bookListViewModel.source(at: indexPath.row)
        let bookDetailsVC = segue.destination as? BookSeekerDetailsViewController
        bookDetailsVC!.bookViewModel = bookViewModel
    }
}
