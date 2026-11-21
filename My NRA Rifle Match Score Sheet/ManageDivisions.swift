//
//  ManageDivisions.swift
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/27/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import Foundation

/// A match Division (`match_class` row).
final class ManageDivisions {

    var divID: Int32 = 0
    var divisionName = ""

    // MARK: Get All Division Listing Array

    /// Get the id and mclass of division for TableView Controller
    static func getAllDivisions(databasePath: String, errorMsg: inout String) -> [ManageDivisions] {
        var results: [ManageDivisions] = []
        BurnSoftDatabase.query("select ID,mclass from match_class order by mclass COLLATE NOCASE ASC",
                               databasePath: databasePath,
                               errorPrefix: "Error while creating select statement for getAllDivsionsByDatabasePath .",
                               errorMsg: &errorMsg) { statement in
            let division = ManageDivisions()
            division.divID = BurnSoftDatabase.columnString(statement, 0).intValue
            division.divisionName = BurnSoftDatabase.columnText(statement, 1) ?? " "
            results.append(division)
        }
        return results
    }

    // MARK: Add Division

    /// Add a Division to be used in the spinner
    static func addDivisionName(_ name: String, databasePath: String, errorMsg: inout String) -> Bool {
        BurnSoftDatabase.runQuery("INSERT INTO match_class(mclass) VALUES('\(BurnSoftGeneral.FCString(name))')", databasePath: databasePath, message: &errorMsg)
    }

    // MARK: Update Division

    /// Update a Division to be used in the spinner
    static func updateDivisionName(_ name: String, divisionID divID: String, databasePath: String, errorMsg: inout String) -> Bool {
        BurnSoftDatabase.runQuery("UPDATE match_class set mclass='\(BurnSoftGeneral.FCString(name))' where id=\(divID)", databasePath: databasePath, message: &errorMsg)
    }

    // MARK: Delete Division

    /// Delete a Division
    static func deleteDivision(byID divID: String, databasePath: String, errorMsg: inout String) -> Bool {
        BurnSoftDatabase.runQuery("Delete from match_class where id=\(divID)", databasePath: databasePath, message: &errorMsg)
    }

    // MARK: Get the Division by ID

    /// return the name of the Division based on the ID that is passed
    static func getDivision(byID divID: String, databasePath: String, errorMsg: inout String) -> String {
        var answer = ""
        BurnSoftDatabase.query("select mclass from match_class where ID=\(divID)",
                               databasePath: databasePath,
                               errorPrefix: "Error while creating select statement for getDivisionbyID .",
                               errorMsg: &errorMsg) { statement in
            answer = BurnSoftDatabase.columnString(statement, 0)
        }
        return answer
    }
}
