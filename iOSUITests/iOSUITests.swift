//
//  iOSUITests.swift
//  iOSUITests
//
//  Created by burnsoft on 12/24/20.
//  Copyright © 2020 burnsoft. All rights reserved.
//

import XCTest

final class iOSUITests: XCTestCase {

    override func setUpWithError() throws {
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
    }

    @MainActor
    func testRunApp() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
    }

    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
