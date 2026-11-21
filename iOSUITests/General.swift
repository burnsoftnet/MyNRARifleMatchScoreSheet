//
//  General.swift
//  iOSUITests
//
//  Created by burnsoft on 12/24/20.
//  Copyright © 2020 burnsoft. All rights reserved.
//

import XCTest

/// Shared helpers for the UI tests.
@MainActor
enum General {

    /// Pass a string to be taken apart character by character to send to the software based keyboard.
    /// - Parameters:
    ///   - app: iOS app instance
    ///   - value: the string that you want to take apart to send to keyboard
    static func sendTextToKeyBoard(_ app: XCUIApplication, _ value: String) {
        for character in value {
            let key = character == " " ? "space" : String(character)
            app.keys[key].tap()
        }
    }

    /// The element `depth` levels of single "Other" children below the first window,
    /// i.e. the content view of the current screen as recorded by Xcode.
    static func screenContentElement(_ app: XCUIApplication, depth: Int = 9) -> XCUIElement {
        var element = app.children(matching: .window).element(boundBy: 0)
        for _ in 0..<depth {
            element = element.children(matching: .other).element
        }
        return element
    }
}
