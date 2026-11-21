//
//  iOSUISettings.swift
//  iOSUITests
//
//  Created by burnsoft on 12/24/20.
//  Copyright © 2020 burnsoft. All rights reserved.
//

import XCTest

final class iOSUISettings: XCTestCase {

    private let divisionName = "Unit Test"
    private let cofName = "COF Unit Test"

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    @MainActor
    func testAddInformation() throws {
        let app = XCUIApplication()
        app.launch()
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Settings"].tap()
        app.textFields["1234567"].tap()

        // NRA number
        for key in ["5", "6", "9", "8", "3", "4", "5", "7", "6"] {
            app.keys[key].tap()
        }

        // Expiration
        app.textFields["MM/YYYY or LIFE"].tap()
        for key in ["1", "7", "/", "7", "2", "0", "5", "0"] {
            app.keys[key].tap()
        }

        // Tap the background to dismiss the keyboard
        General.screenContentElement(app).tap()
        tabBar.buttons["Match Lists"].tap()
    }

    @MainActor
    func testAddiTunesBackup() throws {
        let app = XCUIApplication()
        app.launch()
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Settings"].tap()
        app.staticTexts["  Use iTunes File Sharing for Backup & Restore  "].tap()
        app.staticTexts["  Run Backup  "].tap()
        app.alerts["Success!"].scrollViews.otherElements.buttons["OK"].tap()
        app.navigationBars["Settings"].buttons["Settings"].tap()
        tabBar.buttons["Match Lists"].tap()
    }

    @MainActor
    func testAddDivision() throws {
        let app = XCUIApplication()
        app.launch()
        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Settings"].tap()
        app.staticTexts["  Add, Edit or Delete Divisions  "].tap()
        let manageDivisionsNavigationBar = app.navigationBars["Manage Divisions"]
        manageDivisionsNavigationBar.buttons["Add"].tap()
        let elementsQuery = app.alerts["Divisions"].scrollViews.otherElements

        General.sendTextToKeyBoard(app, divisionName)

        elementsQuery.buttons["ADD"].tap()
        manageDivisionsNavigationBar.buttons["Settings"].tap()
        tabBar.buttons["Match Lists"].tap()
    }

    @MainActor
    func testAddCourseOfFire() throws {
        let app = XCUIApplication()
        app.launch()

        let tabBar = app.tabBars["Tab Bar"]
        tabBar.buttons["Settings"].tap()
        app.staticTexts["  Add, Edit or Delete Course of Fire  "].tap()

        let manageCourseOfFireNavigationBar = app.navigationBars["Manage Course of Fire"]
        manageCourseOfFireNavigationBar.buttons["Add"].tap()
        General.sendTextToKeyBoard(app, cofName)

        app.alerts["Course of Fire"].scrollViews.otherElements.buttons["ADD"].press(forDuration: 0.6)
        manageCourseOfFireNavigationBar.buttons["Settings"].tap()
        tabBar.buttons["Match Lists"].tap()
    }
}
