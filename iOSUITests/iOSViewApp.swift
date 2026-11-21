//
//  iOSViewApp.swift
//  iOSUITests
//
//  Created by burnsoft on 12/24/20.
//  Copyright © 2020 burnsoft. All rights reserved.
//

import XCTest

final class iOSViewApp: XCTestCase {

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    @MainActor
    func testViewCourseOfFire() throws {
        let app = XCUIApplication()
        app.launch()

        let tablesQuery = app.tables
        tablesQuery.staticTexts["Monthly F-Class Match on 2016-10-15"].tap()
        tablesQuery.staticTexts["300 Yards Rapid Fire (Standing to Prone)"].tap()

        let courseOfFireButton = app.navigationBars["Details"].buttons["Course of Fire"]
        courseOfFireButton.tap()
        tablesQuery.cells.containing(.staticText, identifier: "String 1: 81 String 2: 85 Total: 166.0").staticTexts["500 Yards Slow Fire ( prone )"].tap()
        courseOfFireButton.tap()
        tablesQuery.cells.containing(.staticText, identifier: "String 1: 59 String 2: 74 Total: 133.0").staticTexts["500 Yards Slow Fire ( prone )"].tap()
        courseOfFireButton.tap()
        app.tabBars["Tab Bar"].buttons["Match Lists"].tap()
    }

    @MainActor
    func testSettings() throws {
        let app = XCUIApplication()
        app.launch()

        app.tabBars["Tab Bar"].buttons["Settings"].tap()

        app.staticTexts["  Use iTunes File Sharing for Backup & Restore  "].tap()
        app.navigationBars["Settings"].buttons["Settings"].tap()
        app.staticTexts["  Add, Edit or Delete Divisions  "].tap()
        app.tables.cells.containing(.staticText, identifier: "F-Open").element.tap()
        app.alerts["Division"].scrollViews.otherElements.buttons["Cancel"].tap()
        app.navigationBars["Manage Divisions"].buttons["Settings"].tap()
        app.staticTexts["  Add, Edit or Delete Course of Fire  "].tap()
        app.tables.staticTexts["100 Yard Rapid Fire (standing to sitting)"].tap()
        app.alerts["Course of Fire"].scrollViews.otherElements.buttons["Cancel"].press(forDuration: 0.5)
        app.navigationBars["Manage Course of Fire"].buttons["Settings"].tap()

        let staticText = app.staticTexts["1.4.2"]
        staticText.press(forDuration: 0.8)
        staticText.tap()
    }
}
