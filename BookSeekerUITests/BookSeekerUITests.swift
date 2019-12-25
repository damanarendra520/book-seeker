//
//  BookSeekerUITests.swift
//  BookSeekerUITests
//
//  Created by Teobaldo Mauro de Moura on 26/09/19.
//  Copyright © 2019 CIT. All rights reserved.
//

import XCTest

class BookSeekerUITests: XCTestCase {

    var app: XCUIApplication!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("--UITesting")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    func testSearchBar() {
        app.launch()
        let app = XCUIApplication()
        app.navigationBars["Search"].searchFields["Apple Books"].tap()
        let sKey = app.keys["S"]
        sKey.tap()
        let wKey = app.keys["w"]
        wKey.tap()
        let iKey = app.keys["i"]
        iKey.tap()
        let fKey = app.keys["f"]
        fKey.tap()
        let tKey = app.keys["t"]
        tKey.tap()
        app.buttons["Search"].tap()
    }
    func testSaveTableView() {
        app.launch()
        XCUIApplication().tables.children(matching: .cell).element(boundBy: 0).staticTexts["Swift"].tap()
    }
    func testbookDetails() {
        app.launch()
        let tablesQuery = XCUIApplication().tables
        tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts["Swift"].tap()
        tablesQuery.cells.containing(.staticText, identifier: "The Swift Programming Language (Swift 5.1)")
            .staticTexts["Free"].tap()
    }
}
