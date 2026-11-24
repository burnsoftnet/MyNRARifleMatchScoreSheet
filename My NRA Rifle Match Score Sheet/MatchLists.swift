//
//  MatchLists.swift
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/5/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

import Foundation

/// A match (`view_match_list` row).
final class MatchLists {

    var mid: Int32 = 0
    var matchName = ""
    var matchDetails = ""
    var matchClass = ""

    private static let listColumns = "select ID,matchname,matchdetails,mclass from view_match_list"

    /// Shared row reader for the match list queries.
    private static func readMatches(_ sql: String, databasePath: String, errorMsg: inout String) -> [MatchLists] {
        var results: [MatchLists] = []
        BurnSoftDatabase.query(sql,
                               databasePath: databasePath,
                               errorPrefix: "Error while creating select statement for getAllMatchLists .",
                               errorMsg: &errorMsg) { statement in
            let match = MatchLists()
            match.mid = BurnSoftDatabase.columnString(statement, 0).intValue
            match.matchName = BurnSoftDatabase.columnText(statement, 1) ?? " "
            match.matchDetails = BurnSoftDatabase.columnText(statement, 2) ?? "NEW"
            match.matchClass = BurnSoftDatabase.columnText(statement, 3) ?? "UNKNOWN"
            results.append(match)
        }
        return results
    }

    // MARK: Get All Match Listing Array

    /// Get the formated matchname, matchdetails and ID of match for TableView Controller
    static func getAllMatchLists(databasePath: String, errorMsg: inout String) -> [MatchLists] {
        readMatches("\(listColumns) order by mclass,dt COLLATE NOCASE ASC", databasePath: databasePath, errorMsg: &errorMsg)
    }

    // MARK: Get All Match Listing by Division Array

    /// Get the formated matchname, matchdetails and ID of match by Division for TableView Controller
    static func getAllMatchLists(byMatchDivision mclass: String, databasePath: String, errorMsg: inout String) -> [MatchLists] {
        readMatches("\(listColumns) where mclass='\(mclass)' order by dt COLLATE NOCASE ASC", databasePath: databasePath, errorMsg: &errorMsg)
    }

    // MARK: Get Distinct Match Classes Array

    /// Get the distinct match class of match for TableView Controller
    static func getDistinctMatchClasses(databasePath: String, errorMsg: inout String) -> [String] {
        var results: [String] = []
        BurnSoftDatabase.query("select DISTINCT(mclass) from view_match_list order by mclass COLLATE NOCASE ASC",
                               databasePath: databasePath,
                               errorPrefix: "Error while creating select statement for getAllMatchLists .",
                               errorMsg: &errorMsg) { statement in
            results.append(BurnSoftDatabase.columnText(statement, 0) ?? "UNKNOWN")
        }
        return results
    }

    // MARK: Get All Match Class Types

    /// Put all the match class types in a array
    static func getAllMatchClassTypes(databasePath: String, errorMsg: inout String) -> [String] {
        var results: [String] = []
        BurnSoftDatabase.query("select mclass from match_class order by mclass COLLATE NOCASE ASC",
                               databasePath: databasePath,
                               errorPrefix: "Error while creating select statement for getAllMatchClassTypesByDatabasePath .",
                               errorMsg: &errorMsg) { statement in
            results.append(BurnSoftDatabase.columnString(statement, 0))
        }
        return results
    }

    // MARK: Insert Match Data

    /// Create a new match to start recording your courses of fire.
    @discardableResult
    static func insertNewMatch(name matchName: String, matchClassID mcid: String, location: String, relay: String, target: String, dateOfMatch: String, databasePath: String, errorMsg: inout String) -> Bool {
        let sql = "INSERT INTO match_list (dt,name,location,target,relay,MCID) VALUES ('\(dateOfMatch)','\(BurnSoftGeneral.FCString(matchName))','\(BurnSoftGeneral.FCString(location))','\(target)','\(relay)',\(mcid))"
        return BurnSoftDatabase.runQuery(sql, databasePath: databasePath, message: &errorMsg)
    }

    // MARK: Update Match Data

    /// Update match to start recording your courses of fire.
    static func updateMatch(byID mid: String, name matchName: String, matchClassID mcid: String, location: String, relay: String, target: String, dateOfMatch: String, databasePath: String, errorMsg: inout String) -> Bool {
        let sql = "UPDATE match_list set dt='\(dateOfMatch)',name='\(BurnSoftGeneral.FCString(matchName))',location='\(BurnSoftGeneral.FCString(location))',target='\(target)',relay='\(relay)',MCID=\(mcid) where ID=\(mid)"
        return BurnSoftDatabase.runQuery(sql, databasePath: databasePath, message: &errorMsg)
    }

    // MARK: Get Match Class ID from Name

    /// Pass the name of the class to get the Match Class ID back
    static func getMatchClassID(byName className: String, databasePath: String, errorMsg: inout String) -> String {
        var answer = ""
        BurnSoftDatabase.query("SELECT ID from match_class where mclass='\(BurnSoftGeneral.FCString(className))'",
                               databasePath: databasePath,
                               errorPrefix: "Error with Insert statement for getMatchClassIDByName.",
                               errorMsg: &errorMsg) { statement in
            answer = BurnSoftDatabase.columnString(statement, 0)
        }
        return answer
    }

    // MARK: Get Match Class Name from ID

    /// Pass the id of the class to get the Match Class Name back
    static func getMatchClassName(byID cid: String, databasePath: String, errorMsg: inout String) -> String {
        var answer = ""
        BurnSoftDatabase.query("SELECT mclass from match_class where ID='\(cid)'",
                               databasePath: databasePath,
                               errorPrefix: "Error with Insert statement for getMatchClassNameByID .",
                               errorMsg: &errorMsg) { statement in
            answer = BurnSoftDatabase.columnString(statement, 0)
        }
        return answer
    }

    // MARK: Delete Match List

    /// Delete the Match and all the courses of fire and the data relating to that match
    static func deleteMatchLists(byID mid: String, databasePath: String, errorMsg: inout String) -> Bool {
        BurnSoftDatabase.runQuery("delete from match_list_cof_details where MLID=\(mid)", databasePath: databasePath, message: &errorMsg)
            && BurnSoftDatabase.runQuery("delete from match_list_cof where MLID=\(mid)", databasePath: databasePath, message: &errorMsg)
            && BurnSoftDatabase.runQuery("delete from match_list where ID=\(mid)", databasePath: databasePath, message: &errorMsg)
    }

    // MARK: Get Match ID by values

    /// find the match that has all the values passed
    private static func getMatchID(name matchName: String, matchClassID mcid: String, location: String, relay: String, target: String, dateOfMatch: String, databasePath: String, errorMsg: inout String) -> String {
        var answer = "0"
        BurnSoftDatabase.query("select id from match_list where name='\(matchName)' and location='\(location)' and target='\(target)' and relay='\(relay)' and MCID=\(mcid) and dt='\(dateOfMatch)'",
                               databasePath: databasePath,
                               errorPrefix: "Error while creating select statement for getMatchIDbyName .",
                               errorMsg: &errorMsg) { statement in
            answer = BurnSoftDatabase.columnString(statement, 0)
        }
        return answer
    }

    // MARK: Copy Match And Details

    /// copy the match and the course of fires in order and add all zeros for the course of fire.
    static func copyMatch(byMatchID mid: String, databasePath: String, errorMsg: inout String) {
        var name = ""
        var location = ""
        var target = ""
        var relay = ""
        var mcid = ""
        let components = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        let dateOfMatch = "\(components.year ?? 0)-\(components.month ?? 0)-\(components.day ?? 0)"

        BurnSoftDatabase.query("select name,location,target,relay,MCID from match_list where id=\(mid)",
                               databasePath: databasePath,
                               errorPrefix: "Error while creating select statement for copyMatchByMatchID .",
                               errorMsg: &errorMsg) { statement in
            name = BurnSoftDatabase.columnString(statement, 0)
            location = BurnSoftDatabase.columnString(statement, 1)
            target = BurnSoftDatabase.columnString(statement, 2)
            relay = BurnSoftDatabase.columnString(statement, 3)
            mcid = BurnSoftDatabase.columnString(statement, 4)
        }

        insertNewMatch(name: name, matchClassID: mcid, location: location, relay: relay, target: target, dateOfMatch: dateOfMatch, databasePath: databasePath, errorMsg: &errorMsg)
        let matchID = getMatchID(name: name, matchClassID: mcid, location: location, relay: relay, target: target, dateOfMatch: dateOfMatch, databasePath: databasePath, errorMsg: &errorMsg)

        var courseOfFireIDs: [String] = []
        BurnSoftDatabase.query("select MCOFID from match_list_cof where MLID=\(mid) order by ID ASC",
                               databasePath: databasePath,
                               errorPrefix: "Error while creating select statement for copyMatchByMatchID .",
                               errorMsg: &errorMsg) { statement in
            courseOfFireIDs.append(BurnSoftDatabase.columnString(statement, 0))
        }

        for courseOfFireID in courseOfFireIDs {
            let mlcid = MatchListCOF.insertCourseOfFireIDfromList(byMatchID: matchID, cofID: courseOfFireID, databasePath: databasePath, errorMsg: &errorMsg)
            let sql = "INSERT INTO match_list_cof_details(MLCID,MLID,MCOFID,s1,s2,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,total1,total2,endtotal,x_count_1,x_count_2) VALUES(\(mlcid),\(matchID),\(courseOfFireID),'0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0,0,0,0,0);"
            BurnSoftDatabase.runQuery(sql, databasePath: databasePath, message: &errorMsg)
        }
    }
}
