//
//  BurnSoftGeneral.swift
//  BurnSoftGeneral
//
//  Created by burnsoft on 1/31/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import Foundation

/// General string, date and file helpers.
final class BurnSoftGeneral {

    // MARK: Fluff Content String

    /// This will Fluff/Prep the string for inserting value into a database
    /// It will mostly take out things that can conflict, such as the single qoute
    static func FCString(_ value: String) -> String {
        value
            .replacingOccurrences(of: "'", with: "''")
            .replacingOccurrences(of: "`", with: "''")
            .trimmingCharacters(in: .whitespaces)
    }

    // MARK: Fluff Content String to Long

    /// This will convert a string into a long value (its UTF-16 length, as in the original)
    static func FCLong(_ value: String) -> Int {
        (value as NSString).length
    }

    // MARK: Get Value from Long String

    /// This will get the value that is store in a long string
    /// Pass the string, the common seperater, and the ares it should be located at
    ///
    ///     getValueFromLongString("brown,cow,how,two", ",", 2) // "how"
    static func getValueFromLongString(_ value: String, _ separator: String, _ index: Int) -> String {
        value.components(separatedBy: separator)[index]
    }

    // MARK: Count Characters

    /// This will return the number of characters in a string
    static func countCharacters(_ value: String) -> Int {
        (value as NSString).length
    }

    // MARK: Is Numeric

    /// This will return true if the value is a number (or empty), false if it isn't
    static func isNumeric(_ value: String) -> Bool {
        if value.isEmpty { return true }
        let scanner = Scanner(string: value)
        return scanner.scanInt() != nil && scanner.isAtEnd
    }

    // MARK: Format Date

    /// Format date to mm/dd/yyyy
    static func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM'/'dd'/'yyyy"
        return dateFormatter.string(from: date)
    }

    // MARK: Format Date and Time Long By Provided DateTime

    /// Pass a Date and Time Stamp and have it returned in a connected format
    static func formatLongConnectedByDateAndTime(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd_HH_mm_ss"
        return dateFormatter.string(from: date)
    }

    // MARK: Format Date and Time Long By Current DateTime

    /// Get the Current Date and Time Stamp and have it returned in a connected format
    static func formatLongConnectedDateTimeStamp() -> String {
        formatLongConnectedByDateAndTime(Date())
    }

    // MARK: CopyFile

    /// Simplify the copy and replace method with overwrite option
    static func copyFileFromFilePath(_ fromPath: String, toNewPath toPath: String, errorMessage msg: inout String) -> Bool {
        let fileManager = FileManager.default
        var deleteError = ""
        let fileExistsAtDest = fileManager.fileExists(atPath: toPath)
        let fileExistsAtSource = fileManager.fileExists(atPath: fromPath)
        var destDeleteSuccessful = false

        if fileExistsAtSource && fileExistsAtDest {
            destDeleteSuccessful = deleteFileByPath(toPath, errorMessage: &deleteError)
        } else if !fileExistsAtDest && fileExistsAtSource {
            destDeleteSuccessful = true
        } else if !fileExistsAtSource && !fileExistsAtDest {
            msg = "File Does not Exist at Source or Destination!"
        }

        guard destDeleteSuccessful else {
            if msg.isEmpty {
                msg = deleteError
            }
            return false
        }
        do {
            try fileManager.copyItem(atPath: fromPath, toPath: toPath)
            msg = "Copy Successful!"
            return true
        } catch {
            msg = "Error coping file: \(error.localizedDescription)"
            return false
        }
    }

    // MARK: Delete File byPath

    /// Pass the path and file to delete that file
    @discardableResult
    static func deleteFileByPath(_ path: String, errorMessage msg: inout String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
            msg = "Delete Successful!"
            return true
        } catch {
            msg = "Error deleting database: \(error.localizedDescription)"
            return false
        }
    }

    // MARK: Load Files in Path by Extension

    /// Load all the files in the target path that have a certain type of extension
    static func getCertainFilefromPath(_ path: String, byExtension ext: String) -> [String] {
        let dirFiles = (try? FileManager.default.contentsOfDirectory(atPath: path)) ?? []
        return dirFiles.filter { $0.hasSuffix(".\(ext)") }
    }

    // MARK: Load Files in Local Directory by Extension

    /// Load all the files in the Local documents directory by a certain extention
    static func getCertainFilesFromDocumentsByExtension(_ ext: String) -> [String] {
        getCertainFilefromPath(documentsDirectory(), byExtension: ext)
    }

    // MARK: Return Full Path of App Documents with file name

    /// Return Full Path of App Documents with file name attached
    static func returnFullPathwithFileName(_ file: String) -> String {
        (documentsDirectory() as NSString).appendingPathComponent(file)
    }

    /// Path of the app's Documents directory.
    static func documentsDirectory() -> String {
        NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    }

    // MARK: CopyFile 2

    /// Simplify the copy and replace method with overwrite option
    static func copyFileFrom(_ from: String, to: String, errorMessage: inout String) -> Bool {
        let fileManager = FileManager.default
        var deleteError = ""
        let fileExistsInTo = fileManager.fileExists(atPath: to)
        let fileExistsInFrom = fileManager.fileExists(atPath: from)
        var fileClearedInDestination = false

        if fileExistsInTo && fileExistsInFrom {
            fileClearedInDestination = deleteFileByPath(to, errorMessage: &deleteError)
        } else if !fileExistsInFrom && fileExistsInTo {
            fileClearedInDestination = true
        } else if fileExistsInFrom && !fileExistsInTo {
            //added this with the error getting from a new backup check
            fileClearedInDestination = true
        } else {
            errorMessage = "File doesn't exist in source or destination!"
        }

        guard fileClearedInDestination else {
            if errorMessage.isEmpty {
                errorMessage = "Delete Error: \(deleteError)"
            }
            return false
        }
        do {
            try fileManager.copyItem(atPath: from, toPath: to)
            errorMessage = "Backup Successful!"
            return true
        } catch {
            errorMessage = "Error copying file: \(error.localizedDescription)"
            return false
        }
    }

    // MARK: Create a Directory

    /// Create a directory if it doesn't already exist
    static func createDirectoryIfNotExists(_ path: String, errorMessage: inout String) -> Bool {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            return true
        }
        do {
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }

    // MARK: Convert Bool to String

    /// Convert a boolean value to string Yes or No
    static func convertBOOLtoString(_ value: Bool) -> String {
        value ? "Yes" : "No"
    }

    // MARK: Get File Extension From File Path

    /// Get the extension of the file from the full path
    static func getFileExtensionbyPath(_ filePath: String) -> String {
        filePath.components(separatedBy: ".").last ?? ""
    }
}
