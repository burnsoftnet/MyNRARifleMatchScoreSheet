//
//  ManageCOF.swift
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/27/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import Foundation

/// A Course of Fire type (`match_cof` row).
final class ManageCOF {

    var cofID: Int32 = 0
    var cofName = ""

    // MARK: Get All Course of Fire Listing Array

    /// Get the ID and name of every course of fire for the TableView Controller
    static func getAllCourseOfFire(databasePath: String, errorMsg: inout String) -> [ManageCOF] {
        var results: [ManageCOF] = []
        BurnSoftDatabase.query("select ID,cof from match_cof order by cof COLLATE NOCASE ASC",
                               databasePath: databasePath,
                               errorPrefix: "Error while creating select statement for getAllCourseOfFireByDatabasePath .",
                               errorMsg: &errorMsg) { statement in
            let cof = ManageCOF()
            cof.cofID = BurnSoftDatabase.columnString(statement, 0).intValue
            cof.cofName = BurnSoftDatabase.columnText(statement, 1) ?? " "
            results.append(cof)
        }
        return results
    }

    // MARK: Add Course of Fire

    /// Add a Course of Fire to be used in the spinner
    static func addCOFName(_ cof: String, databasePath: String, errorMsg: inout String) -> Bool {
        BurnSoftDatabase.runQuery("INSERT INTO match_cof(cof) VALUES('\(BurnSoftGeneral.FCString(cof))')", databasePath: databasePath, message: &errorMsg)
    }

    // MARK: Update Course of Fire

    /// Update a Course of Fire to be used in the spinner
    static func updateCOFName(_ cof: String, courseOfFireID cofID: String, databasePath: String, errorMsg: inout String) -> Bool {
        BurnSoftDatabase.runQuery("UPDATE match_cof set cof='\(BurnSoftGeneral.FCString(cof))' where id=\(cofID)", databasePath: databasePath, message: &errorMsg)
    }

    // MARK: Delete Course of Fire

    /// Delete a Course of Fire to be used in the spinner
    static func deleteCOF(byID cofID: String, databasePath: String, errorMsg: inout String) -> Bool {
        BurnSoftDatabase.runQuery("Delete from match_cof where id=\(cofID)", databasePath: databasePath, message: &errorMsg)
    }

    // MARK: Get the Course of Fire by ID

    /// return the name of the course of fire based on the ID that is passed
    static func getCourseOfFire(byID cofID: String, databasePath: String, errorMsg: inout String) -> String {
        var answer = ""
        BurnSoftDatabase.query("select cof from match_cof where ID=\(cofID)",
                               databasePath: databasePath,
                               errorPrefix: "Error while creating select statement for getCourseOfFirebyID .",
                               errorMsg: &errorMsg) { statement in
            answer = BurnSoftDatabase.columnString(statement, 0)
        }
        return answer
    }
}
