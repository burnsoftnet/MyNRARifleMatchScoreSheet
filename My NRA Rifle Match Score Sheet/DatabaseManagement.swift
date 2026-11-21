//
//  DatabaseManagement.swift
//  MyEssentialOilRemedies
//
//  Created by burnsoft on 1/30/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import Foundation

/// Backup and restore of the database through the iCloud container.
final class DatabaseManagement {

    // MARK: Remove iCloud Conflicts

    /// Every device that backups the database to the iCloud container is given a version status which will cause conflicts when attempting to restore the database on another device.  This function will remove any of the conflict version allowing the latest greatest version to exist for restore.
    static func removeConflictVersionsiniCloud(by url: URL) {
        let location = "DatabaseManagement.removeConflictVersionsiniCloudbyURL"
        loadFileListings()

        do {
            try NSFileVersion.removeOtherVersionsOfItem(at: url)
            FormFunctions.doBuggermeMessage("older versions were removed!", fromSubFunction: location)
        } catch {
            FormFunctions.doBuggermeMessage("Problems removing older versions!", fromSubFunction: location)
            FormFunctions.doBuggermeMessage(error.localizedDescription, fromSubFunction: location)
        }

        for fileVersion in NSFileVersion.unresolvedConflictVersionsOfItem(at: url) ?? [] {
            fileVersion.isResolved = true
        }
    }

    // MARK: Load File Listings

    /// List all the extra file versions in the iCloud container and delete them
    private static func loadFileListings() {
        let documentsDirectory = "\(iCloudContainerPath())/Documents"
        var deleteError = ""
        for fileName in BurnSoftGeneral.getCertainFilefromPath(documentsDirectory, byExtension: "zip") {
            FormFunctions.doBuggermeMessage(fileName, fromSubFunction: "DatabaseManagement.loadFileListings")
            if fileName != "MNRSS.zip" {
                BurnSoftGeneral.deleteFileByPath("\(documentsDirectory)/\(fileName)", errorMessage: &deleteError)
            }
        }
    }

    /// Path of the default iCloud ubiquity container, or "" when iCloud isn't available.
    private static func iCloudContainerPath() -> String {
        FileManager.default.url(forUbiquityContainerIdentifier: nil)?.path ?? ""
    }

    // MARK: Get iCloud Backup Name in String format

    /// Get the iCloud backup file name and path
    static func getiCloudDatabaseBackup(byDBName dbName: String, replaceExtensionTo newExt: String) -> String {
        "\(iCloudContainerPath())/Documents/\(dbName.replacingOccurrences(of: "db", with: newExt))"
    }

    // MARK: Get iCloud Backup Name in URL format

    /// Get the iCloud backup file name and path
    static func getiCloudDatabaseBackupURL(byDBName dbName: String, replaceExtensionTo newExt: String) -> URL {
        URL(fileURLWithPath: getiCloudDatabaseBackup(byDBName: dbName, replaceExtensionTo: newExt))
    }

    // MARK: Backup Database to iCloud

    /// Backup the database to the iCloud container
    static func backupDatabaseToiCloud(byDBName dbName: String, localDatabasePath dbPath: String, errorMessage msg: inout String) -> Bool {
        let newExt = "zip"
        var deleteError = ""
        var copyError = ""
        var success = false

        // The local copy is made by swapping "db" for "zip" in the whole path, as the original did.
        let backupFile = dbPath.replacingOccurrences(of: "db", with: newExt)
        let newDBName = getiCloudDatabaseBackup(byDBName: dbName, replaceExtensionTo: newExt)

        if BurnSoftGeneral.copyFileFrom(dbPath, to: backupFile, errorMessage: &deleteError) {
            if BurnSoftGeneral.copyFileFrom(backupFile, to: newDBName, errorMessage: &copyError) {
                msg = "Backup Successful!"
                success = true
            } else {
                msg = "Error backuping database: \(copyError)"
            }
        } else {
            msg = deleteError
        }

        removeConflictVersionsiniCloud(by: URL(fileURLWithPath: newDBName))
        BurnSoftGeneral.deleteFileByPath(backupFile, errorMessage: &deleteError)
        return success
    }

    // MARK: Restore Database from iCloud

    /// Restore the database from the iCloud Drive
    static func restoreDatabaseFromiCloud(byDBName dbName: String, localDatabasePath dbPath: String, errorMessage msg: inout String) -> Bool {
        let newExt = "zip"
        var deleteError = ""
        var copyError = ""

        let newDBName = getiCloudDatabaseBackup(byDBName: dbName, replaceExtensionTo: newExt)
        let backupFile = dbPath.replacingOccurrences(of: "db", with: newExt)

        removeConflictVersionsiniCloud(by: URL(fileURLWithPath: newDBName))
        BurnSoftGeneral.deleteFileByPath(backupFile, errorMessage: &deleteError)

        guard BurnSoftGeneral.copyFileFrom(newDBName, to: backupFile, errorMessage: &deleteError) else {
            msg = deleteError
            return false
        }
        guard BurnSoftGeneral.copyFileFrom(backupFile, to: dbPath, errorMessage: &copyError) else {
            msg = "Error backuping database: \(copyError)"
            return false
        }
        msg = "Backup Successful!"
        return true
    }

    // MARK: Start iCloud sync

    /// Start the sync process from the iCloud container. This needs to be ran from the application at start and before the restore is going to be initiated to make sure the latest version is download from the cloud.
    static func startiCloudSync() {
        let backupURL = getiCloudDatabaseBackupURL(byDBName: MYSettings.dbName, replaceExtensionTo: "zip")

        //Remove any conflicting versions and maybe initialize icloud sync
        removeConflictVersionsiniCloud(by: backupURL)

        do {
            try FileManager.default.startDownloadingUbiquitousItem(at: backupURL)
            FormFunctions.doBuggermeMessage("sync started!", fromSubFunction: "DatabaseManagement.StartiCloudSync")
        } catch {
            FormFunctions.doBuggermeMessage("sync FAILED!", fromSubFunction: "DatabaseManagement.StartiCloudSync")
        }
    }
}
