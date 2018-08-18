//
//  DBUpgrade.m
//  MyEssentialOilRemedies
//
//  Created by burnsoft on 12/30/16.
//  Copyright © 2016 burnsoft. All rights reserved.
//

#import "DBUpgrade.h"

@implementation DBUpgrade
{
    NSString *dbPathString;
}

#pragma mark Check if DB needs upgrading
//NOTE: Checks the expected version of the app to see if the database needs to be upgraded by looking at it's version
//USEDBY: MainStartViewController.m
-(void) checkDBVersionAgainstExpectedVersion
{
    BurnSoftDatabase *myObj = [BurnSoftDatabase new];
    FormFunctions *myObjFF = [FormFunctions new];
    NSString *errorMsg;
    dbPathString = [myObj getDatabasePath:@MYDBNAME];
    double dbVersion = [[myObj getCurrentDatabaseVersionfromTable:@"DB_Version" DatabasePath:dbPathString ErrorMessage:&errorMsg] doubleValue];

    if ([@MYDBVERSION doubleValue] > dbVersion) {
        [myObjFF doBuggermeMessage:@"DEBUG: DBVersion is less than expected!!!" FromSubFunction:@"DBUpgrade"];
        if ([@MYDBVERSION doubleValue] == 1.1) {
            [self dbupgrade11];
        } else if ([@MYDBVERSION doubleValue] == 1.2) {
            [self dbupgrade12];
        }
    } else {
        [myObjFF doBuggermeMessage:@"DEBUG: DBVersion is equal to or greater than expected." FromSubFunction:@"DBUpgrade"];
    }
    
    myObj = nil;
    myObjFF = nil;
    dbVersion = 0;
    
}
#pragma mark DB Upgrade Version 1.1
//NOTE: PRIVATE - Update Database to version 1.1
//USEDBY: checkDBVersionAgainstExpectedVersion
-(void) dbupgrade11
{
    BurnSoftDatabase *myObj = [BurnSoftDatabase new];
    FormFunctions *myObjFF = [FormFunctions new];
    dbPathString = [myObj getDatabasePath:@MYDBNAME];
    double newDBVersion = 0;
    NSString *msg;
    NSString *sqlstmt = [NSString new];
    newDBVersion = 1.1;
    
    if (![myObj VersionExists:[NSString stringWithFormat:@"%f",newDBVersion] VersionTable:@"DB_Version" DatabasePath:dbPathString ErrorMessage:&msg])
    {
        // Send to doBuggermeMessage if enabled, that the database upgrade is begining
        msg = [NSString stringWithFormat:@"DEBUG: Start DBVersion Upgrade to version %.01f", newDBVersion];
        [myObjFF doBuggermeMessage:msg FromSubFunction:@"DBUpgrade"];
        
        //-------------START UPGRADE PROCESS-----------------//
        
        // Add Table to save NRA Number.
        sqlstmt=@"CREATE TABLE user_settings (id integer PRIMARY KEY, setting STRING(255),setting_value STRING(255));";
        [myObj runQuery:sqlstmt DatabasePath:dbPathString MessageHandler:&msg];
        [myObjFF checkForErrorLogOnly:msg MyTitle:[NSString stringWithFormat:@"DB Version %.01f",newDBVersion]];
        
        // Insert Setting Value for starting point.
        sqlstmt=@"INSERT INTO user_settings (setting,setting_value) VALUES('NRA#','N/A');";
        [myObj runQuery:sqlstmt DatabasePath:dbPathString MessageHandler:&msg];
        [myObjFF checkForErrorLogOnly:msg MyTitle:[NSString stringWithFormat:@"DB Version %.01f",newDBVersion]];
        
        //Add X Total for Course of Fire.
        sqlstmt=@"ALTER TABLE match_list_cof_details ADD COLUMN xtotal INTEGER;";
        [myObj runQuery:sqlstmt DatabasePath:dbPathString MessageHandler:&msg];
        [myObjFF checkForErrorLogOnly:msg MyTitle:[NSString stringWithFormat:@"DB Version %.01f",newDBVersion]];
        
        // Zero out the xTotal.
        sqlstmt=@"UPDATE match_list_cof_details set xtotal=0;";
        [myObj runQuery:sqlstmt DatabasePath:dbPathString MessageHandler:&msg];
        [myObjFF checkForErrorLogOnly:msg MyTitle:[NSString stringWithFormat:@"DB Version %.01f",newDBVersion]];
        
        // Drop View Before Create
        sqlstmt=@"DROP VIEW view_match_list;";
        [myObj runQuery:sqlstmt DatabasePath:dbPathString MessageHandler:&msg];
        [myObjFF checkForErrorLogOnly:msg MyTitle:[NSString stringWithFormat:@"DB Version %.01f",newDBVersion]];
        
        // Create View
        sqlstmt=@"CREATE VIEW view_match_list as Select ml.*, mc.mclass, ml.name || ' on ' || ml.dt as matchname, 'Location:' || ml.location || ' Relay:' || ml.relay || ' Target:' || ml.target || ' Total: ' || (select sum(endtotal) from match_list_cof_details where mlid=ml.id) || '.' || (select sum(xtotal) from match_list_cof_details where mlid=ml.id) as matchdetails  from match_list ml inner join match_class mc on mc.id=ml.MCID;";
        [myObj runQuery:sqlstmt DatabasePath:dbPathString MessageHandler:&msg];
        [myObjFF checkForErrorLogOnly:msg MyTitle:[NSString stringWithFormat:@"DB Version %.01f",newDBVersion]];
        
        // Drop View Before Create
        sqlstmt=@"DROP VIEW view_match_list_cof_details;";
        [myObj runQuery:sqlstmt DatabasePath:dbPathString MessageHandler:&msg];
        [myObjFF checkForErrorLogOnly:msg MyTitle:[NSString stringWithFormat:@"DB Version %.01f",newDBVersion]];
        
        // Create View
        sqlstmt=@"CREATE VIEW view_match_list_cof_details as select mlcd.*,mc.cof,'String 1: ' || mlcd.total1 || ' String 2: ' || mlcd.total2 || ' Total: ' || mlcd.endtotal || '.' || mlcd.xtotal as scoredetails from match_list_cof mlc inner join match_cof mc on mc.ID = mlc.MCOFID inner join match_list_cof_details mlcd on mlcd.MLCID=mlc.ID;";
        [myObj runQuery:sqlstmt DatabasePath:dbPathString MessageHandler:&msg];
        [myObjFF checkForErrorLogOnly:msg MyTitle:[NSString stringWithFormat:@"DB Version %.01f",newDBVersion]];
        
        
        //-------------END UPGRADE PROCESS-----------------//
        
        //Update Database to current Version
        sqlstmt=[NSString stringWithFormat:@"INSERT INTO DB_Version (version) VALUES('%.01f')", newDBVersion];
        [myObj runQuery:sqlstmt DatabasePath:dbPathString MessageHandler:&msg];
        [myObjFF checkForErrorLogOnly:msg MyTitle:[NSString stringWithFormat:@"DB Version %.01f",newDBVersion]];
        
        // Send to doBuggermeMessage if enabled that the database was upgraded
        msg = [NSString stringWithFormat:@"DEBUG: End DBVersion Upgrade to version %.01f", newDBVersion];
        [myObjFF doBuggermeMessage:msg FromSubFunction:@"DBUpgrade"];
    } else {
        msg = [NSString stringWithFormat:@"DEBUG: Database has already had %.01f patch applied!",newDBVersion];
        [myObjFF doBuggermeMessage:msg FromSubFunction:@"DBUpgrade"];
    }
    
}
//ALTER TABLE "user_settings" ADD "setting_value2" STRING(255);

#pragma mark DB Upgrade Version 1.2
//NOTE: PRIVATE - Update Database to version x.x
//USEDBY: checkDBVersionAgainstExpectedVersion
-(void) dbupgrade12
{
    BurnSoftDatabase *myObj = [BurnSoftDatabase new];
    FormFunctions *myObjFF = [FormFunctions new];
    dbPathString = [myObj getDatabasePath:@MYDBNAME];
    double newDBVersion = 0;
    NSString *msg;
    NSString *sqlstmt = [NSString new];
    newDBVersion = 1.2;
    if (![myObj VersionExists:[NSString stringWithFormat:@"%f",newDBVersion] VersionTable:@"DB_Version" DatabasePath:dbPathString ErrorMessage:&msg])
    {
        // Send to doBuggermeMessage if enabled, that the database upgrade is begining
        msg = [NSString stringWithFormat:@"DEBUG: Start DBVersion Upgrade to version %.01f", newDBVersion];
        [myObjFF doBuggermeMessage:msg FromSubFunction:@"DBUpgrade"];
        
        //-------------START UPGRADE PROCESS-----------------//
        
        sqlstmt=@"ALTER TABLE user_settings ADD setting_value2 STRING(255);";
        [myObj runQuery:sqlstmt DatabasePath:dbPathString MessageHandler:&msg];
        [myObjFF checkForErrorLogOnly:msg MyTitle:[NSString stringWithFormat:@"DB Version %.01f",newDBVersion]];
        
        //-------------END UPGRADE PROCESS-----------------//
        //Update Database to current Version
        sqlstmt=[NSString stringWithFormat:@"INSERT INTO DB_Version (version) VALUES('%.01f')", newDBVersion];
        [myObj runQuery:sqlstmt DatabasePath:dbPathString MessageHandler:&msg];
        [myObjFF checkForErrorLogOnly:msg MyTitle:[NSString stringWithFormat:@"DB Version %.01f",newDBVersion]];
        
        // Send to doBuggermeMessage if enabled that the database was upgraded
        msg = [NSString stringWithFormat:@"DEBUG: End DBVersion Upgrade to version %.01f", newDBVersion];
        [myObjFF doBuggermeMessage:msg FromSubFunction:@"DBUpgrade"];
    } else {
        msg = [NSString stringWithFormat:@"DEBUG: Database has already had %.01f patch applied!",newDBVersion];
        [myObjFF doBuggermeMessage:msg FromSubFunction:@"DBUpgrade"];
    }
}
/*
#pragma mark DB Upgrade Version x.x
//NOTE: PRIVATE - Update Database to version x.x
//USEDBY: checkDBVersionAgainstExpectedVersion
-(void) dbupgradexx
{
    BurnSoftDatabase *myObj = [BurnSoftDatabase new];
    FormFunctions *myObjFF = [FormFunctions new];
    dbPathString = [myObj getDatabasePath:@MYDBNAME];
    double newDBVersion = 0;
    NSString *msg;
    NSString *sqlstmt = [NSString new];
    newDBVersion = 0.0;
    if (![myObj VersionExists:[NSString stringWithFormat:@"%f",newDBVersion] VersionTable:@"DB_Version" DatabasePath:dbPathString ErrorMessage:&msg])
    {
        // Send to doBuggermeMessage if enabled, that the database upgrade is begining
        msg = [NSString stringWithFormat:@"DEBUG: Start DBVersion Upgrade to version %.01f", newDBVersion];
        [myObjFF doBuggermeMessage:msg FromSubFunction:@"DBUpgrade"];
        
         //-------------START UPGRADE PROCESS-----------------//
        
        sqlstmt=@"";
        [myObj runQuery:sqlstmt DatabasePath:dbPathString MessageHandler:&msg];
        [myObjFF checkForErrorLogOnly:msg MyTitle:[NSString stringWithFormat:@"DB Version %.01f",newDBVersion]];
        
        //-------------END UPGRADE PROCESS-----------------//
 
         //Update Database to current Version
         sqlstmt=[NSString stringWithFormat:@"INSERT INTO DB_Version (version) VALUES('%.01f')", newDBVersion];
         [myObj runQuery:sqlstmt DatabasePath:dbPathString MessageHandler:&msg];
         [myObjFF checkForErrorLogOnly:msg MyTitle:[NSString stringWithFormat:@"DB Version %.01f",newDBVersion]];
        
        // Send to doBuggermeMessage if enabled that the database was upgraded
        msg = [NSString stringWithFormat:@"DEBUG: End DBVersion Upgrade to version %.01f", newDBVersion];
        [myObjFF doBuggermeMessage:msg FromSubFunction:@"DBUpgrade"];
    } else {
        msg = [NSString stringWithFormat:@"DEBUG: Database has already had %.01f patch applied!",newDBVersion];
        [myObjFF doBuggermeMessage:msg FromSubFunction:@"DBUpgrade"];
    }
}
 */
@end
