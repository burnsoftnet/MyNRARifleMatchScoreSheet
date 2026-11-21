//
//  Settings.swift
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/5/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import UIKit

/// Settings tab: NRA membership info, versions, and backup/restore.
@objc(Settings)
final class Settings: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var txtNRANumber: UITextField!
    @IBOutlet weak var txtNRAExpiration: UITextField!
    @IBOutlet weak var lblAppVersion: UILabel!
    @IBOutlet weak var lblDBVersion: UILabel!
    @IBOutlet weak var btniTunesBackup: UIButton!
    @IBOutlet weak var btnManageDivision: UIButton!
    @IBOutlet weak var btnManageCOF: UIButton!
    @IBOutlet weak var btnBackuptoiCloud: UIButton!
    @IBOutlet weak var btnRestoreFromiCloud: UIButton!

    private var dbPath = ""

    // MARK: On Form Load

    /// When form first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        loadVersioning()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapReceived(_:)))
        tapGestureRecognizer.delegate = self
        view.addGestureRecognizer(tapGestureRecognizer)
    }

    // MARK: When Tap is Received

    /// when somewhere else on the form is clicked to retire the keyboard
    @objc private func tapReceived(_ tapGestureRecognizer: UITapGestureRecognizer) {
        txtNRANumber.resignFirstResponder()
        txtNRAExpiration.resignFirstResponder()
    }

    // MARK: Form Loads Again

    /// When the view reloads itself
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }

    // MARK: Reload Data

    /// Reload the settings and information as if the form first load.
    private func reloadData() {
        loadSettings()
        loadVersioning()
    }

    // MARK: Load Settings

    /// Load the Database Path and the saved NRA details
    private func loadSettings() {
        DatabaseManagement.startiCloudSync()
        dbPath = BurnSoftDatabase.getDatabasePath(MYSettings.dbName)

        FormFunctions.setBorderButton(btnManageCOF)
        FormFunctions.setBorderButton(btniTunesBackup)
        FormFunctions.setBorderButton(btnManageDivision)
        FormFunctions.setBorderButton(btnBackuptoiCloud)
        FormFunctions.setBorderButton(btnRestoreFromiCloud)

        txtNRANumber.text = getNRASetting(column: "setting_value", defaultValue: "0")
        txtNRAExpiration.text = getNRASetting(column: "setting_value2", defaultValue: "")
    }

    // MARK: Load Version

    /// Get the version of the App and the Database to view in the label boxes
    private func loadVersioning() {
        var errorMsg = ""
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
        let appBuild = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? ""

        lblAppVersion.text = "\(appVersion).\(appBuild)"
        lblDBVersion.text = BurnSoftDatabase.getCurrentDatabaseVersionfromTable("DB_Version", databasePath: dbPath, errorMsg: &errorMsg)
    }

    // MARK: Get NRA Number / Expiration

    /// Get the NRA number (`setting_value`) or expiration (`setting_value2`) from the user settings table to display on the UI.
    /// "N/A" is shown as an empty field.
    private func getNRASetting(column: String, defaultValue: String) -> String {
        var answer = defaultValue
        var errorMsg = ""
        BurnSoftDatabase.query("select \(column) from user_settings where setting='NRA#'",
                               databasePath: dbPath,
                               errorPrefix: "Error while creating select statement for getNRASetting .",
                               errorMsg: &errorMsg) { statement in
            if let value = BurnSoftDatabase.columnText(statement, 0) {
                answer = value == "N/A" ? "" : value
            }
        }
        return answer
    }

    // MARK: Update NRA Number Function

    /// Update the NRA Number that was entered in the txt field in the database.
    private func updateNRANumber() {
        var errorMsg = ""
        let sql = "update user_settings set setting_value='\(txtNRANumber.text ?? "")',setting_value2='\(txtNRAExpiration.text ?? "")' where setting='NRA#'"
        BurnSoftDatabase.runQuery(sql, databasePath: dbPath, message: &errorMsg)
    }

    // MARK: Action to Update Settings

    /// Action to update the NRANumber
    @IBAction func updateSettings(_ sender: Any) {
        updateNRANumber()
    }

    // MARK: Backup to iCloud Button

    /// Action to start the backup to iCloud Drive
    @IBAction func btnBackuptoiCloud(_ sender: Any) {
        var msg = ""
        if DatabaseManagement.backupDatabaseToiCloud(byDBName: MYSettings.dbName, localDatabasePath: dbPath, errorMessage: &msg) {
            FormFunctions.sendMessage("Databae Backup was successful!", title: "Success!", viewController: self)
        } else {
            FormFunctions.sendMessage(msg, title: "ERROR!", viewController: self)
        }
        DatabaseManagement.startiCloudSync()
    }

    // MARK: Restore from iCloud Button

    /// Action to start the restore from iCloud Drive
    @IBAction func btnRestoreFromiCloud(_ sender: Any) {
        DatabaseManagement.startiCloudSync()
        var msg = ""
        if DatabaseManagement.restoreDatabaseFromiCloud(byDBName: MYSettings.dbName, localDatabasePath: dbPath, errorMessage: &msg) {
            FormFunctions.sendMessage("Databae Restore was successful!", title: "Success!", viewController: self)
        } else {
            FormFunctions.sendMessage(msg, title: "ERROR!", viewController: self)
        }
    }
}
