//
//  ViewController.swift
//  BookSeeker
//
//  Created by Teobaldo Mauro de Moura on 26/09/19.
//  Copyright © 2019 CIT. All rights reserved.
//

import UIKit

class BookSearchController: UIViewController, UISearchBarDelegate {

    @IBOutlet  weak var tableView: UITableView?
    var searchString: String = ""
    var webservice: WebServices!
    var savesListViewModel: SaveListViewModel!
    var dataSource: TableViewDataSource<SaveCell, SaveViewModel>!
    // MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        tableView?.dataSource = self as? UITableViewDataSource
    }
    override func viewDidAppear(_ animated: Bool) {
        searchString = ""
        updateUI()
    }
    // MARK: Setup UI
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.delegate = self as? UISearchControllerDelegate
        searchController.searchBar.delegate = self
        searchController.accessibilityLabel = Constants.searchBarAccessbilityLabel
        searchController.searchBar.placeholder = Constants.searchBarPlaceholder
    }
    func updateUI() {
        self.webservice = WebServices()
        self.savesListViewModel = SaveListViewModel(webservice: self.webservice)
        // setting up the bindings
        self.savesListViewModel.bindToSavesViewModels = {
            self.updateDataSource()
        }
    }
    func updateDataSource() {
        self.dataSource = TableViewDataSource(cellIdentifier: Cells.savesTableViewCell,
                                              items: self.savesListViewModel.savesViewModels) { cell, save in
                                                cell.saveName.text = save.name
        }
        self.tableView!.dataSource = self.dataSource
        self.tableView!.reloadData()
    }
    /**
     This is used to store searched string locally and will display in table view on the main screen
     */
    func storeInUserDefaults(argument searchString: String) {
        let defaults = UserDefaults.standard
        var myarray = defaults.stringArray(forKey: Constants.savedSearchesKey) ?? [String]()
        myarray.append(searchString)
        myarray.reverse()
        defaults.set(myarray, forKey: Constants.savedSearchesKey)
    }
    // This function will be called when user cliecks the search button on the Keyboard
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        storeInUserDefaults(argument: searchBar.text!)
        searchString = searchBar.text!
        performSegue(withIdentifier: SegueIdentifier.showBooks, sender: self)
    }
    // MARK: Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let secondViewController = segue.destination as? BooksResultsViewController
        let defaults = UserDefaults.standard
        let myarray = defaults.stringArray(forKey: Constants.savedSearchesKey) ?? [String]()
        var string: String = ""
        if searchString.isEmpty {
            let index = (tableView?.indexPathForSelectedRow?.row)!
            string = myarray[index]
        } else {
            string = searchString
        }
        secondViewController?.searchString = string
    }
}
