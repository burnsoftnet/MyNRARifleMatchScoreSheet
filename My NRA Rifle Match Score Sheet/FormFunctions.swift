//
//  FormFunctions.swift
//  MyEssentialOilRemedies
//
//  Created by burnsoft on 8/23/16.
//  Copyright © 2016 burnsoft. All rights reserved.
//

import UIKit

/// Shared UI helpers: colors, borders, alerts and debug logging.
enum FormFunctions {

    // MARK: Colors

    /// Set the color of the highlight that you want to use
    static func setHighlightColor() -> UIColor { .systemGreen }
    /// Set the color of what you want the text to be
    static func setTextColor() -> UIColor { .white }
    static func setCopyColor() -> UIColor { .systemGreen }
    static func setRestoreColor() -> UIColor { .systemBlue }
    /// Set the color of the edit button
    static func setEditColor() -> UIColor { .systemBlue }
    /// Set the color of the delete button
    static func setDeleteColor() -> UIColor { .systemRed }
    /// Set the color of the Cart button
    static func setCartColor() -> UIColor { .systemGray }

    // MARK: Borders

    /// Creates a border around a Textview
    static func setBordersTextView(_ view: UITextView) {
        setBorder(view.layer, cornerRadius: 2)
    }

    /// Creates a border around a regular text box
    static func setBorderTextBox(_ textField: UITextField) {
        setBorder(textField.layer, cornerRadius: 2)
    }

    /// Creates a border around the label
    static func setBorderLabel(_ label: UILabel) {
        setBorder(label.layer, cornerRadius: 2)
    }

    /// Creates a border around the button
    static func setBorderButton(_ button: UIButton?) {
        guard let button else { return }
        setBorder(button.layer, cornerRadius: 10)
        button.clipsToBounds = true
    }

    private static func setBorder(_ layer: CALayer, cornerRadius: CGFloat) {
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 2.3
        layer.cornerRadius = cornerRadius
    }

    // MARK: Common Alert/Message Handling

    /// Send a Message box from the View controller that you are currently on. It's easier then copying this function all over the place
    static func sendMessage(_ msg: String, title: String, viewController: UIViewController) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }

    // MARK: Alert on Limit

    /// Alert on limit reached and give the option to buy the full verion from the app store.
    static func alertOnLimit(for viewController: UIViewController) {
        let alert = UIAlertController(title: "Limit Reached!",
                                      message: "You Have reached your limit on the Lite Version!\n Please Purchase the Regular Version for Unlimited access!",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Purchase", style: .default) { _ in
            if let appStore = URL(string: "https://itunes.apple.com/us/app/my-nra-rifle-match-score-sheet/id1241521195?ls=1&mt=8") {
                UIApplication.shared.open(appStore)
            }
        })
        alert.addAction(UIAlertAction(title: "No Thanks", style: .default))
        viewController.present(alert, animated: true)
    }

    // MARK: Check For Error in Message via MessageBox

    /// This will check the message to see if something is in it, if not it will not alert via MessageBox
    static func checkForError(_ errorMsg: String, title: String, viewController: UIViewController) {
        guard !errorMsg.isEmpty else { return }
        doBuggermeMessage(errorMsg, fromSubFunction: "CheckForError.\(title)")
        sendMessage(errorMsg, title: "\(title) Error", viewController: viewController)
    }

    // MARK: Check for Error in Message via NSLog

    /// This will check the message to see if something is in it, if not it will not alert via NSLog
    static func checkForErrorLogOnly(_ errorMsg: String, title: String) {
        guard !errorMsg.isEmpty else { return }
        doBuggermeMessage(errorMsg, fromSubFunction: "CheckForError.\(title)")
        NSLog("%@", errorMsg)
    }

    // MARK: NSLog Debug Message

    /// Mostly used for runtime debugging by sending message of information back to the output window.
    /// Only when `MYSettings.buggerMe` is true will it write out message
    static func doBuggermeMessage(_ msg: String, fromSubFunction location: String) {
        if MYSettings.buggerMe {
            NSLog("DEBUG MESSAGE: %@ - %@", location, msg)
        }
    }

    // MARK: Log Error from Location

    /// General Method on catching and displaying errors
    /// - Parameters:
    ///   - location: the location of the function that it came from
    ///   - error: the error that occured
    static func logErrorFromLocation(_ location: String, error: Error) {
        NSLog("Exception Error from %@  - %@", location, error.localizedDescription)
    }
}
