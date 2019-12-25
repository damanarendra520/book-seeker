//
//  BookSeekerTests.swift
//  BookSeekerTests
//
//  Created by Teobaldo Mauro de Moura on 26/09/19.
//  Copyright © 2019 CIT. All rights reserved.
//

import XCTest
@testable import BookSeeker

class BookSeekerTests: XCTestCase {

    var bookSearchController: BookSearchController!
    var dataSource: TableViewDataSource<UITableViewCell, Any>!
    let mockApiService = MockApiService()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.bookSearchController = storyboard.instantiateViewController(withIdentifier: "BookSearchController")
            as? BookSearchController
        self.bookSearchController.loadView()
        self.bookSearchController.viewDidLoad()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    func testHasTableView() {
        XCTAssertNotNil(bookSearchController?.tableView, "Controller should have a tableview")
    }
    func testSaveViewModel() {
        let save = Save(name: "Saving from Unit testing")
        let saveViewModel = SaveViewModel(save: save!)
        XCTAssertEqual(save?.name, saveViewModel.name)
    }
    func testSaveListViewModel() {
        bookSearchController.viewDidLoad()
        bookSearchController.viewDidAppear(false)
        bookSearchController.updateUI()
        bookSearchController.updateDataSource()
        bookSearchController.tableView?.reloadData()
        let save1 = Save.init(name: "test1")
        let save2 = Save.init(name: "test2")
        let savelistmodel1 = SaveViewModel(save: save1!)
        let savelistmodel2 = SaveViewModel(save: save2!)
        var savesViewModels: [SaveViewModel] = [SaveViewModel]()
        savesViewModels.append(savelistmodel1)
        savesViewModels.append(savelistmodel2)
        let webservice = WebServices()
        bookSearchController.savesListViewModel = SaveListViewModel(webservice: webservice)
        dataSource = TableViewDataSource(cellIdentifier: Cells.savesTableViewCell, items:
                                savesViewModels, configureCell: {_, _ in })
        bookSearchController.tableView?.dataSource = dataSource
        WebServices().loadSaves { (data, _) in
            print(data.count)
        }
        print(bookSearchController.savesListViewModel as Any)
    }
    func testFetchSaves() {
        let saves = SaveListViewModel(webservice: mockApiService)
        saves.populateSaves()
        XCTAssert(mockApiService.loadSavesCalled)
    }
}
class BooksResultsTests: XCTestCase {
    var booksResultsViewController: BooksResultsViewController!
     let mockApiService = MockApiService()
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        self.booksResultsViewController =
            storyboard.instantiateViewController(withIdentifier: "BooksResultsViewController")
            as? BooksResultsViewController
        self.booksResultsViewController.loadView()
        self.booksResultsViewController.viewDidLoad()
    }
    func testBooksViewModel() {
        booksResultsViewController.searchString = "Swift Programming"
        booksResultsViewController.webservice.loadBooks(searchString: "") { abc in
            print(abc)
        }
        print(booksResultsViewController.bookListViewModel.booksViewModels)
    }
    func testFetchBooks() {
        let books = BookListViewModel(searchString: "Swift", webservice: mockApiService)
        books.populateBooks()
        XCTAssert(mockApiService.loadBookCalled)
    }
    func testValidCallToiBookGetsHTTPStatusCode200() {
      let url = URL(string: "https://itunes.apple.com/search?term=swift&entity=ibook")
      let promise = expectation(description: "Status code: 200")
        let dataTask = URLSession.shared.dataTask(with: url!) { _, response, error in
        if let error = error {
          XCTFail("Error: \(error.localizedDescription)")
          return
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
          if statusCode == 200 {
            promise.fulfill()
          } else {
            XCTFail("Status code: \(statusCode)")
          }
        }
      }
      dataTask.resume()
      wait(for: [promise], timeout: 10)
    }
}
// MARK: Mock APi service
class MockApiService: WebServices {
    var loadSavesCalled = false
    var loadBookCalled = false
    override func loadSaves(completion: @escaping ([Save], Error) -> Void) {
        loadSavesCalled = true
    }
    override func loadBooks(searchString: String, completion: @escaping ([Book]) -> Void) {
        loadBookCalled = true
    }
}
