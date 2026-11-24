//
//  DBUpgrade.swift
//  MyEssentialOilRemedies
//
//  Created by burnsoft on 12/30/16.
//  Copyright © 2016 burnsoft. All rights reserved.
//

import Foundation

/// Applies schema patches when the bundled database is older than the app expects.
final class DBUpgrade {

    private let dbPath = BurnSoftDatabase.getDatabasePath(MYSettings.dbName)

    // MARK: Check if DB needs upgrading

    /// Checks the expected version of the app to see if the database needs to be upgraded by looking at it's version
    /// USEDBY: MainStartViewController
    func checkDBVersionAgainstExpectedVersion() {
        var errorMsg = ""
        let dbVersion = BurnSoftDatabase.getCurrentDatabaseVersionfromTable("DB_Version", databasePath: dbPath, errorMsg: &errorMsg).doubleValue

        guard MYSettings.dbVersion > dbVersion else {
            FormFunctions.doBuggermeMessage("DEBUG: DBVersion is equal to or greater than expected.", fromSubFunction: "DBUpgrade")
            return
        }
        FormFunctions.doBuggermeMessage("DEBUG: DBVersion is less than expected!!!", fromSubFunction: "DBUpgrade")
        // Only the patch matching the app's expected version is applied, as in the original.
        if MYSettings.dbVersion == 1.1 {
            dbUpgrade11()
        } else if MYSettings.dbVersion == 1.2 {
            dbUpgrade12()
        }
    }

    // MARK: DB Upgrade Version 1.1

    /// Update Database to version 1.1
    private func dbUpgrade11() {
        applyUpgrade(version: 1.1, statements: [
            // Add Table to save NRA Number.
            "CREATE TABLE user_settings (id integer PRIMARY KEY, setting STRING(255),setting_value STRING(255));",
            // Insert Setting Value for starting point.
            "INSERT INTO user_settings (setting,setting_value) VALUES('NRA#','N/A');",
            //Add X Total for Course of Fire.
            "ALTER TABLE match_list_cof_details ADD COLUMN xtotal INTEGER;",
            // Zero out the xTotal.
            "UPDATE match_list_cof_details set xtotal=0;",
            // Drop View Before Create
            "DROP VIEW view_match_list;",
            // Create View
            "CREATE VIEW view_match_list as Select ml.*, mc.mclass, ml.name || ' on ' || ml.dt as matchname, 'Location:' || ml.location || ' Relay:' || ml.relay || ' Target:' || ml.target || ' Total: ' || (select sum(endtotal) from match_list_cof_details where mlid=ml.id) || '.' || (select sum(xtotal) from match_list_cof_details where mlid=ml.id) as matchdetails  from match_list ml inner join match_class mc on mc.id=ml.MCID;",
            // Drop View Before Create
            "DROP VIEW view_match_list_cof_details;",
            // Create View
            "CREATE VIEW view_match_list_cof_details as select mlcd.*,mc.cof,'String 1: ' || mlcd.total1 || ' String 2: ' || mlcd.total2 || ' Total: ' || mlcd.endtotal || '.' || mlcd.xtotal as scoredetails from match_list_cof mlc inner join match_cof mc on mc.ID = mlc.MCOFID inner join match_list_cof_details mlcd on mlcd.MLCID=mlc.ID;",
        ])
    }

    // MARK: DB Upgrade Version 1.2

    /// Update Database to version 1.2
    private func dbUpgrade12() {
        applyUpgrade(version: 1.2, statements: [
            "ALTER TABLE user_settings ADD setting_value2 STRING(255);",
        ])
    }

    /// Run the patch statements unless the version was already recorded, then record the new version.
    private func applyUpgrade(version newDBVersion: Double, statements: [String]) {
        var msg = ""
        let title = String(format: "DB Version %.01f", newDBVersion)

        guard !BurnSoftDatabase.versionExists(String(format: "%f", newDBVersion), versionTable: "DB_Version", databasePath: dbPath, errorMsg: &msg) else {
            FormFunctions.doBuggermeMessage(String(format: "DEBUG: Database has already had %.01f patch applied!", newDBVersion), fromSubFunction: "DBUpgrade")
            return
        }
        // Send to doBuggermeMessage if enabled, that the database upgrade is begining
        FormFunctions.doBuggermeMessage(String(format: "DEBUG: Start DBVersion Upgrade to version %.01f", newDBVersion), fromSubFunction: "DBUpgrade")

        //-------------START UPGRADE PROCESS-----------------//
        for sql in statements {
            BurnSoftDatabase.runQuery(sql, databasePath: dbPath, message: &msg)
            FormFunctions.checkForErrorLogOnly(msg, title: title)
        }
        //-------------END UPGRADE PROCESS-----------------//

        //Update Database to current Version
        BurnSoftDatabase.runQuery(String(format: "INSERT INTO DB_Version (version) VALUES('%.01f')", newDBVersion), databasePath: dbPath, message: &msg)
        FormFunctions.checkForErrorLogOnly(msg, title: title)

        // Send to doBuggermeMessage if enabled that the database was upgraded
        FormFunctions.doBuggermeMessage(String(format: "DEBUG: End DBVersion Upgrade to version %.01f", newDBVersion), fromSubFunction: "DBUpgrade")
    }
}
