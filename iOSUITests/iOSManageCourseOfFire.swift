//
//  iOSManageCourseOfFire.swift
//  iOSUITests
//
//  Created by burnsoft on 12/24/20.
//  Copyright © 2020 burnsoft. All rights reserved.
//

import XCTest

final class iOSManageCourseOfFire: XCTestCase {

    private let matchName = "Unit Test Match"
    private let matchOnDate = "2020-12-24"

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    @MainActor
    func testAdd() throws {
        let app = XCUIApplication()
        app.launch()

        app.navigationBars["Match Lists"].buttons["Add"].tap()
        app.textFields["Monthly / CMP / etc."].tap()

        General.sendTextToKeyBoard(app, matchName)

        app.textFields["Service Rifle/ F-Class etc."].tap()
        app.pickerWheels["Any"].swipeUp()

        let doneButton = app.toolbars["Toolbar"].buttons["Done"]
        doneButton.tap()
        app.textFields["Date of Match"].tap()
        doneButton.tap()
        app.textFields["Some Place, Some State"].tap()

        app.keys["K"].tap()
        app.keys["y"].tap()

        let relayAndTargetFields = General.screenContentElement(app).children(matching: .textField).matching(identifier: "1, 2, 3, etc")
        let key1 = app.keys["1"]

        relayAndTargetFields.element(boundBy: 0).tap()
        key1.tap()
        key1.tap()

        relayAndTargetFields.element(boundBy: 1).tap()
        key1.tap()
        key1.tap()

        app.staticTexts["  Apply  "].tap()
    }

    @MainActor
    func testAddCOF() throws {
        let app = XCUIApplication()
        app.launch()

        app.tables.staticTexts["Unit Test Match on 2020-12-24"].tap()
        app.navigationBars["Course of Fire"].buttons["Add"].tap()

        let scrollViewsQuery = app.scrollViews
        let courseOfFireElementsQuery = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Course of Fire:")
        let textFields = courseOfFireElementsQuery.children(matching: .textField)
        textFields.element(boundBy: 0).tap()

        app.pickerWheels["100 Yards Rapid Fire (Standing to Prone)"].swipeUp()
        app.toolbars["Toolbar"].buttons["Done"].tap()

        let key9 = app.keys["9"]
        let key1 = app.keys["1"]
        let key0 = app.keys["0"]
        let courseOfFireElement = courseOfFireElementsQuery.element

        /// Tap the text field at `index`, then type the score
        func enter(_ index: Int, _ keys: XCUIElement...) {
            textFields.element(boundBy: index).tap()
            keys.forEach { $0.tap() }
        }

        // Order matches the original recording.
        enter(1, key9)
        enter(2, key9)
        enter(3, key1, key0)
        enter(5, key9)
        enter(4, key9)
        enter(6, key9)
        enter(8, key9)
        enter(7, key9)
        enter(9, key9)
        enter(10, key9)
        enter(11, key1, key0)
        enter(12, key1, key0)

        courseOfFireElement.swipeUp()
        enter(13, key1, key0)
        enter(14, key1, key0)
        for index in 15...22 {
            enter(index, key9)
        }

        courseOfFireElement.swipeUp()

        let elementsQuery = scrollViewsQuery.otherElements
        elementsQuery.staticTexts["93"].press(forDuration: 1.1)
        elementsQuery.staticTexts["92"].press(forDuration: 0.6)
        elementsQuery.staticTexts["185"].press(forDuration: 0.6)
        app.scrollViews.otherElements.staticTexts["  Apply  "].tap()
    }

    @MainActor
    func testAddCOFMathTest() throws {
        let app = XCUIApplication()
        app.launch()

        app.tables.staticTexts["Unit Test Match on 2020-12-24"].tap()
        app.navigationBars["Course of Fire"].buttons["Add"].tap()

        let scrollViewsQuery = app.scrollViews
        let courseOfFireElementsQuery = scrollViewsQuery.otherElements.containing(.staticText, identifier: "Course of Fire:")
        let textFields = courseOfFireElementsQuery.children(matching: .textField)
        textFields.element(boundBy: 0).tap()

        app.pickerWheels["100 Yards Rapid Fire (Standing to Prone)"].swipeUp()
        app.toolbars["Toolbar"].buttons["Done"].tap()

        let key1 = app.keys["1"]
        let key0 = app.keys["0"]
        let courseOfFireElement = courseOfFireElementsQuery.element

        // Score a 10 in every sighter and record field
        for index in 1..<23 {
            textFields.element(boundBy: index).tap()
            key1.tap()
            key0.tap()
            if index == 12 {
                courseOfFireElement.swipeUp()
            }
        }

        courseOfFireElement.tap()
        courseOfFireElement.swipeUp()

        //TODO: Verify the string totals (100 / 100) and course total (200) here.
        app.scrollViews.otherElements.staticTexts["  Apply  "].tap()
    }

    @MainActor
    func testDeleteMatch() throws {
        let app = XCUIApplication()
        app.launch()

        let selectedMatchToDelete = app.tables.staticTexts["\(matchName) on \(matchOnDate)"]
        selectedMatchToDelete.swipeLeft()
        //TODO: Get Delete button working.
    }
}
