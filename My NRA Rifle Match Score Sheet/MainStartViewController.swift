//
//  MainStartViewController.swift
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/6/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import UIKit

/// Root tab bar controller; prepares the database on launch.
@objc(MainStartViewController)
final class MainStartViewController: UITabBarController {

    /// Main Application Startup
    override func viewDidLoad() {
        super.viewDidLoad()

        //Database Functions copy the database from the applications directory is it doesn't exists in the App documents folder.
        var errorMsg = ""
        BurnSoftDatabase.copyDbIfNeeded(MYSettings.dbName, message: &errorMsg)
        FormFunctions.doBuggermeMessage("Error Occured: \(errorMsg)", fromSubFunction: "MainStartViewController.viewDidLoad")

        //Check the database version to see if it needs to be upgraded.
        DBUpgrade().checkDBVersionAgainstExpectedVersion()

        //Start iCloud sync for backups
        DatabaseManagement.startiCloudSync()
    }
}
