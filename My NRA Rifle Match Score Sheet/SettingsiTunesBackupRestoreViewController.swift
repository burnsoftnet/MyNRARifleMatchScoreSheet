//
//  SettingsiTunesBackupRestoreViewController.swift
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/26/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import UIKit

/// Local (iTunes/Finder file sharing) backups of the database in the Documents folder.
@objc(SettingsiTunesBackupRestoreViewController)
final class SettingsiTunesBackupRestoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var btnBackUpDatabaseForiTunes: UIButton!

    private var dbPath = ""
    private var filePaths: [String] = []

    // MARK: On Form Load

    /// When form first loads
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSettings()
        loadFileListings()

        //Read backup files
        myTableView.delegate = self
        myTableView.dataSource = self
    }

    /// reload the data on the form
    private func reloadData() {
        loadSettings()
        loadFileListings()
        myTableView.reloadData()
    }

    // MARK: Load File Data

    /// Load the backup files in the docs directory
    private func loadFileListings() {
        filePaths = BurnSoftGeneral.getCertainFilesFromDocumentsByExtension("bak")
    }

    // MARK: Load Settings

    /// Load the Database Path
    private func loadSettings() {
        dbPath = BurnSoftDatabase.getDatabasePath(MYSettings.dbName)
        FormFunctions.setBorderButton(btnBackUpDatabaseForiTunes)
    }

    // MARK: Backup Database for iTunes

    /// This will make a copy of the database for iTunes to to retrived or in case you need to restore.
    /// This will make a backup file mnrmss_backup_datetime.bak
    @IBAction func btnBackUpDatabaseForiTunes(_ sender: Any) {
        let location = "SettingsiTunesBackupRestoreViewController.btnBackUpDatabaseForiTunes"
        let newDBName = BurnSoftGeneral.returnFullPathwithFileName("mnrmss_backup_\(BurnSoftGeneral.formatLongConnectedDateTimeStamp()).bak")

        FormFunctions.doBuggermeMessage("DatabasePath: \(dbPath)", fromSubFunction: location)
        FormFunctions.doBuggermeMessage("New Database Name: \(newDBName)", fromSubFunction: location)

        do {
            try FileManager.default.copyItem(atPath: dbPath, toPath: newDBName)
            FormFunctions.sendMessage("Backup Successful!", title: "Success!", viewController: self)
        } catch {
            FormFunctions.sendMessage("Error backuping database: \(error.localizedDescription)", title: "Backup Error", viewController: self)
        }
        reloadData()
    }

    // MARK: Delete File by Name

    /// Delete a file in the local documents for the app.
    private func deleteFile(named file: String) -> Bool {
        var msg = ""
        return BurnSoftGeneral.deleteFileByPath(BurnSoftGeneral.returnFullPathwithFileName(file), errorMessage: &msg)
    }

    // MARK: Restore Database for iTunes by File Name

    /// Restore selected database and rename it to the main database name.
    private func restoreDatabaseForiTunes(byFileName file: String) {
        do {
            try FileManager.default.copyItem(atPath: BurnSoftGeneral.returnFullPathwithFileName(file), toPath: dbPath)
            FormFunctions.sendMessage("Restore Successful!", title: "Success!", viewController: self)
        } catch {
            FormFunctions.sendMessage("Error restoring database: \(error.localizedDescription)", title: "Restore Error", viewController: self)
        }
    }

    // MARK: Table

    /// Set the ability to swipe left to edit or delete
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    /// Display the number of sections in the table
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    /// Count of all the rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        filePaths.count
    }

    /// populate the table with data from the array
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        cell.textLabel?.text = filePaths[indexPath.row]
        return cell
    }

    // MARK: Table Handlers on Swipe

    /// trailing swipe action configuration for table row: Delete and Restore
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let fileName = tableView.cellForRow(at: indexPath)?.textLabel?.text ?? ""

        let restoreAction = UIContextualAction(style: .destructive, title: "Restore") { [unowned self] _, _, _ in
            if deleteFile(named: MYSettings.dbName) {
                restoreDatabaseForiTunes(byFileName: fileName)
            } else {
                FormFunctions.sendMessage("Unable to delete Main Database before copy", title: "Restore Error", viewController: self)
            }
            reloadData()
        }
        restoreAction.backgroundColor = FormFunctions.setRestoreColor()

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [unowned self] _, _, _ in
            if deleteFile(named: fileName) {
                FormFunctions.sendMessage("\(fileName) backup file was deleted!", title: "Backup Deleted", viewController: self)
            } else {
                FormFunctions.sendMessage("Unable to delete backup file: \(fileName)!", title: "Backup Deleted Error", viewController: self)
            }
            reloadData()
        }
        deleteAction.backgroundColor = FormFunctions.setDeleteColor()

        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction, restoreAction])
        swipeActions.performsFirstActionWithFullSwipe = false
        return swipeActions
    }
}
