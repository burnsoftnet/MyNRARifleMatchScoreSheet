//
//  MatchListCOF.swift
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/7/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import Foundation

/// A Course of Fire entered for a match (`view_match_list_cof_details` row).
final class MatchListCOF {

    var cofID: Int32 = 0
    var cofName = ""
    var scoreDetails = ""

    // MARK: Get All Match Course of Fire Listing Array

    /// Get the cof, scoredetails  and ID of match for TableView Controller
    static func getAllMatchListCOF(byMatchID mid: String, databasePath: String, errorMsg: inout String) -> [MatchListCOF] {
        var results: [MatchListCOF] = []
        BurnSoftDatabase.query("select ID,cof,scoredetails from view_match_list_cof_details where MLID=\(mid) order by id COLLATE NOCASE ASC",
                               databasePath: databasePath,
                               errorPrefix: "Error while creating select statement for getAllMatchListCOFByDatabasePath .",
                               errorMsg: &errorMsg) { statement in
            let cof = MatchListCOF()
            cof.cofID = BurnSoftDatabase.columnString(statement, 0).intValue
            cof.cofName = BurnSoftDatabase.columnText(statement, 1) ?? " "
            cof.scoreDetails = BurnSoftDatabase.columnString(statement, 2)
            results.append(cof)
        }
        return results
    }

    // MARK: Get All Match Course of Fire Types

    /// Put all the match Course of Fire types in a array
    static func getAllMatchCourseOfFireTypes(databasePath: String, errorMsg: inout String) -> [String] {
        var results: [String] = []
        BurnSoftDatabase.query("select cof from match_cof order by cof COLLATE NOCASE ASC",
                               databasePath: databasePath,
                               errorPrefix: "Error while creating select statement for getAllMatchCourseOfFireTypesByDatabasePath .",
                               errorMsg: &errorMsg) { statement in
            results.append(BurnSoftDatabase.columnString(statement, 0))
        }
        return results
    }

    // MARK: Get the Match Course of Fire ID by Name

    /// pass the name and get the ID of the Course of Fire ( match_cof )
    static func getCourseOfFireID(byName cof: String, databasePath: String, errorMsg: inout String) -> String {
        var answer = ""
        BurnSoftDatabase.query("select id from match_cof where cof='\(cof)'",
                               databasePath: databasePath,
                               errorPrefix: "Error while creating select statement for getCourseOfFireIDByName .",
                               errorMsg: &errorMsg) { statement in
            answer = BurnSoftDatabase.columnString(statement, 0)
        }
        return answer
    }

    // MARK: Get match_list_cof ID

    /// pass the MatchID and Course of Fire ID to get the match_list_cof.ID
    static func getCourseOfFireIDfromList(byMatchID mid: String, cofID: String, databasePath: String, errorMsg: inout String) -> String {
        var answer = ""
        BurnSoftDatabase.query("select id from match_list_cof where MLID=\(mid) and MCOFID=\(cofID)",
                               databasePath: databasePath,
                               errorPrefix: "Error while creating select statement for getCourseOfFireIDfromListByMatchID .",
                               errorMsg: &errorMsg) { statement in
            answer = BurnSoftDatabase.columnString(statement, 0)
        }
        return answer
    }

    // MARK: Insert match_list_cof ID

    /// Insert the MatchID and Course of Fire ID into match_list_cof and return the new match_list_cof.ID
    static func insertCourseOfFireIDfromList(byMatchID mid: String, cofID: String, databasePath: String, errorMsg: inout String) -> String {
        guard BurnSoftDatabase.runQuery("insert into match_list_cof (MLID,MCOFID) VALUES(\(mid),\(cofID))", databasePath: databasePath, message: &errorMsg) else {
            return ""
        }
        return getCourseOfFireIDfromList(byMatchID: mid, cofID: cofID, databasePath: databasePath, errorMsg: &errorMsg)
    }

    // MARK: Delete Course Of Fire

    /// Delete the selected details from the match_list_cof then the match_list_cof_details
    static func deleteMatchCourseOfFire(_ mcofID: String, matchID mid: String, matchListCOF cofID: String, databasePath: String, errorMsg: inout String) -> Bool {
        let mlcofID = getCourseOfFireIDfromList(byMatchID: mid, cofID: cofID, databasePath: databasePath, errorMsg: &errorMsg)
        guard BurnSoftDatabase.runQuery("delete from match_list_cof where MLID=\(mid) and MCOFID=\(mlcofID)", databasePath: databasePath, message: &errorMsg) else {
            return false
        }
        return BurnSoftDatabase.runQuery("delete from match_list_cof_details where ID=\(mcofID)", databasePath: databasePath, message: &errorMsg)
    }
}
