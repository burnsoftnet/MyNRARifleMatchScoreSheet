//
//  BurnSoftDatabase.swift
//  BurnSoftDatabase
//
//  Created by burnsoft on 6/9/16.
//  Copyright © 2016 burnsoft. All rights reserved.
//

import Foundation
import SQLite3

/// General SQLite helpers shared by the data classes.
final class BurnSoftDatabase {

    // MARK: Error Handling

    /// Translate Errors from SQLITE integer to English
    static func dbErrorsIDtoEnglish(_ ret: Int32) -> String {
        let description: String
        switch ret {
        case SQLITE_ERROR: description = "SQL error or missing database"
        case SQLITE_INTERNAL: description = "Internal logic error in SQLite"
        case SQLITE_PERM: description = "Access permission denied"
        case SQLITE_ABORT: description = "Callback routine requested an abort"
        case SQLITE_BUSY: description = "The database file is locked"
        case SQLITE_LOCKED: description = "A table in the database is locked"
        case SQLITE_NOMEM: description = "A malloc() failed"
        case SQLITE_READONLY: description = "Attempt to write a readonly database"
        case SQLITE_INTERRUPT: description = "Operation terminated by sqlite3_interrupt()"
        case SQLITE_IOERR: description = "Some kind of disk I/O error occurred"
        case SQLITE_CORRUPT: description = "The database disk image is malformed"
        case SQLITE_NOTFOUND: description = "Unknown opcode in sqlite3_file_control()"
        case SQLITE_FULL: description = "Insertion failed because database is full"
        case SQLITE_CANTOPEN: description = "Unable to open the database file"
        case SQLITE_PROTOCOL: description = "Database lock protocol error"
        case SQLITE_EMPTY: description = "Database is empty"
        case SQLITE_SCHEMA: description = "The database schema changed"
        case SQLITE_TOOBIG: description = "String or BLOB exceeds size limit"
        case SQLITE_CONSTRAINT: description = "Abort due to constraint violation"
        case SQLITE_MISMATCH: description = "Data type mismatch"
        case SQLITE_MISUSE: description = "Library used incorrectly"
        case SQLITE_NOLFS: description = "Uses OS features not supported on host"
        case SQLITE_AUTH: description = "Authorization denied"
        case SQLITE_FORMAT: description = "Auxiliary database format error"
        case SQLITE_RANGE: description = "2nd parameter to sqlite3_bind out of range"
        case SQLITE_NOTADB: description = "File opened that is not a database file"
        case SQLITE_NOTICE: description = "Notifications from sqlite3_log()"
        case SQLITE_WARNING: description = "Warnings from sqlite3_log()"
        case SQLITE_ROW: description = "sqlite3_step() has another row ready"
        case SQLITE_DONE: description = "sqlite3_step() has finished executing "
        default: return "UNKNOWN Error Number: \(ret)"
        }
        return "\(description), ERROR #: \(ret)"
    }

    /// Current error message of an open connection.
    static func errorMessage(_ db: OpaquePointer?) -> String {
        guard let cString = sqlite3_errmsg(db) else { return "" }
        return String(cString: cString)
    }

    // MARK: Row Helpers

    /// Read a text column, returning `nil` when the value is SQL NULL.
    static func columnText(_ statement: OpaquePointer?, _ column: Int32) -> String? {
        guard sqlite3_column_type(statement, column) != SQLITE_NULL,
              let text = sqlite3_column_text(statement, column) else { return nil }
        return String(cString: text)
    }

    /// Read a text column, returning an empty string when the value is SQL NULL.
    static func columnString(_ statement: OpaquePointer?, _ column: Int32) -> String {
        columnText(statement, column) ?? ""
    }

    /// Open the database, prepare `sql`, and call `row` for every result row.
    /// Returns `false` and sets `errorMsg` to "`errorPrefix` '<sqlite error>'" when the statement can't be prepared.
    /// A database that can't be opened is ignored silently, which matches the original data classes.
    @discardableResult
    static func query(_ sql: String, databasePath: String, errorPrefix: String, errorMsg: inout String, row: (OpaquePointer?) -> Void) -> Bool {
        var db: OpaquePointer?
        guard sqlite3_open(databasePath, &db) == SQLITE_OK else {
            sqlite3_close(db)
            return false
        }
        defer { sqlite3_close(db) }

        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            errorMsg = "\(errorPrefix) '\(errorMessage(db))'"
            sqlite3_finalize(statement)
            return false
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            row(statement)
        }
        sqlite3_finalize(statement)
        return true
    }

    // MARK: Get Database Path

    /// Pass the Database Name to find the Path of the database
    static func getDatabasePath(_ dbName: String) -> String {
        BurnSoftGeneral.returnFullPathwithFileName(dbName)
    }

    // MARK: Copy DB if Needed

    /// Pass the name of the database to see if we need to copy the database from the application directory to the documents directory
    static func copyDbIfNeeded(_ dbName: String, message: inout String) {
        let dbInAppPath = (Bundle.main.resourcePath ?? "") + "/" + dbName
        let dbInDocsPath = getDatabasePath(dbName)

        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: dbInDocsPath) {
            do {
                try fileManager.copyItem(atPath: dbInAppPath, toPath: dbInDocsPath)
            } catch {
                message = "Error coping database: \(error.localizedDescription)."
            }
        }
    }

    // MARK: Restore Factory Database

    /// Restore the Factory Database by deleting the database in the user docs and copying it back over.
    static func restoreFactoryDB(_ dbName: String, message: inout String) {
        let dbInDocsPath = getDatabasePath(dbName)
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: dbInDocsPath) {
            do {
                try fileManager.removeItem(atPath: dbInDocsPath)
                copyDbIfNeeded(dbName, message: &message)
            } catch {
                message = "Error deleting database: \(error.localizedDescription)"
            }
        }
    }

    // MARK: Check Database

    /// Pass the Database name to see if the database is in the path that we need it to be in
    static func checkDB(_ dbName: String, message: inout String) {
        let dbPath = getDatabasePath(dbName)
        if FileManager.default.fileExists(atPath: dbPath) {
            message = "Database found!"
        } else {
            message = "Database is missing from Path! \(dbPath)"
        }
    }

    // MARK: Execute Statements

    /// Pass a SQL statement, and the database path to execute a statement, if it passes ok, then it will return true
    @discardableResult
    static func runQuery(_ sql: String, databasePath: String, message: inout String) -> Bool {
        var db: OpaquePointer?
        defer { sqlite3_close(db) }
        guard sqlite3_open(databasePath, &db) == SQLITE_OK else {
            message = "error while opening database!"
            return false
        }
        guard sqlite3_exec(db, sql, nil, nil, nil) == SQLITE_OK else {
            message = "Error while executing query: \(errorMessage(db))"
            return false
        }
        return true
    }

    // MARK: See if Data Exists

    /// Pass a SQL statement and the database path to see if any rows are returned from that statement, if there is something it will return true
    static func dataExistsbyQuery(_ sql: String, databasePath: String, message: inout String) -> Bool {
        var db: OpaquePointer?
        defer { sqlite3_close(db) }
        guard sqlite3_open(databasePath, &db) == SQLITE_OK else {
            message = "Error while attempting to connection! \(errorMessage(db))"
            return false
        }

        var statement: OpaquePointer?
        defer { sqlite3_finalize(statement) }
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            message = "Error in statement! \(errorMessage(db))"
            return false
        }
        if sqlite3_step(statement) == SQLITE_ERROR {
            message = "Error while counting rows: \(errorMessage(db))."
            return false
        }
        // Mirrors the original: the first column of the first row decides whether data exists.
        let rows = sqlite3_column_int(statement, 0)
        if rows > 0 {
            message = "Found \(rows) rows"
            return true
        }
        message = "No rows found!"
        return false
    }

    // MARK: Get Data from Database

    /// Pass the Name/Value that you are looking for, the column name that it would be in, the Column that that Would Contain an ID that you want, the name of the table, and the database path to get the ID value,  Used to Look up ID of a value in the table to be referenced in your code.
    static func getLastOneEntryIDbyName(_ name: String, lookForColumnName searchColumn: String, getIDFromColumn getFromColumn: String, inTable tableName: String, databasePath: String, message: inout String) -> Int32 {
        var answer: Int32 = 0
        let sql = "SELECT \(getFromColumn) from \(tableName) where lower(\(searchColumn))='\(name.lowercased())' order by \(getFromColumn) desc limit 1"
        executeScalar(sql, databasePath: databasePath, message: &message) { statement in
            answer = sqlite3_column_int(statement, 0)
        }
        return answer
    }

    // MARK: Get Current Database Version

    /// Get the current Database Version, usualy used for letting the application/user/tech support know if the two version match up
    static func getCurrentDatabaseVersionfromTable(_ table: String, databasePath: String, errorMsg: inout String) -> String {
        var answer = "0"
        executeScalar("select version from \(table) order by id desc limit 1", databasePath: databasePath, message: &errorMsg) { statement in
            answer = columnString(statement, 0)
        }
        return answer
    }

    // MARK: Version Exists

    /// This will check to see if a previous version exists of the hotfix, if it exists it will skip updating the database.
    static func versionExists(_ currentVersion: String, versionTable table: String, databasePath: String, errorMsg: inout String) -> Bool {
        var answer = false
        executeScalar("select * from \(table) where version=\(currentVersion)", databasePath: databasePath, message: &errorMsg) { _ in
            answer = true
        }
        return answer
    }

    // MARK: Get Number of Rows in Table

    /// Get the Total Number of Rows in the selected Table.
    static func getTotalNumberofRowsInTable(_ table: String, databasePath: String, errorMsg: inout String) -> Int32 {
        var answer: Int32 = 0
        executeScalar("select count(*) as mytotal from \(table)", databasePath: databasePath, message: &errorMsg) { statement in
            answer = sqlite3_column_int(statement, 0)
        }
        return answer
    }

    /// Shared body of the lookup helpers above, using their original error wording.
    private static func executeScalar(_ sql: String, databasePath: String, message: inout String, row: (OpaquePointer?) -> Void) {
        var db: OpaquePointer?
        defer { sqlite3_close(db) }
        guard sqlite3_open(databasePath, &db) == SQLITE_OK else {
            message = "Error occured while attempting to connect to database! \(errorMessage(db))"
            return
        }
        var statement: OpaquePointer?
        defer { sqlite3_finalize(statement) }
        guard sqlite3_prepare_v2(db, sql, -1, &statement, nil) == SQLITE_OK else {
            message = "Error while executing statement! \(errorMessage(db))"
            return
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            row(statement)
        }
    }
}
