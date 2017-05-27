//
//  ManageDivisions.m
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/27/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import "ManageDivisions.h"

@implementation ManageDivisions
{
    NSMutableArray *matchDIV;
    sqlite3 *MatchDB;
}

#pragma mark Get All Division Listing Array
//Get the id and mclass of division for TableView Controller
-(NSMutableArray *) getAllDivsionsByDatabasePath:(NSString *) dbPath ErrorMessage: (NSString **) errorMsg;
{
    matchDIV = [NSMutableArray new];
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        [matchDIV removeAllObjects];
        NSString *querySQL = [NSString stringWithFormat:@"select ID,mclass from match_class order by mclass COLLATE NOCASE ASC"];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                NSString *divID = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
                NSString *DIVName = [NSString new];
                
                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL )
                {
                    DIVName = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement,1)];
                } else {
                    DIVName = @" ";
                }
                
                ManageDivisions *myMatch = [ManageDivisions new];
                [myMatch setDIVID:[divID intValue]];
                [myMatch setDivision_name:DIVName];
                
                [matchDIV addObject:myMatch];
                
            }
            sqlite3_close(MatchDB);
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error while creating select statement for getAllDivsionsByDatabasePath . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }
    return matchDIV;
}

#pragma mark Add Division
//Add a Division to be used in the spinner
+(BOOL) addDivisionName:(NSString *) name DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg
{
    BOOL bAns = NO;
    NSString *SQLQuery = [NSString stringWithFormat:@"INSERT INTO match_class(mclass) VALUES('%@')",[BurnSoftGeneral FCString:name]];
    if ([BurnSoftDatabase runQuery:SQLQuery DatabasePath:dbPath MessageHandler:errorMsg]) {
        bAns = YES;
    }
    return bAns;
}

#pragma mark Update Division
//Update a Division to be used in the spinner
+(BOOL) updateDivisionName:(NSString *) name DivisionID:(NSString *) divid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg
{
    BOOL bAns = NO;
    NSString *SQLQuery = [NSString stringWithFormat:@"UPDATE match_class set mclass='%@' where id=%@",[BurnSoftGeneral FCString:name],divid];
    if ([BurnSoftDatabase runQuery:SQLQuery DatabasePath:dbPath MessageHandler:errorMsg]) {
        bAns = YES;
    }
    return bAns;
}

#pragma mark Delete Division
//Delete a Division
+(BOOL) DeleteDivisionByID:(NSString *) divid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg
{
    BOOL bAns = NO;
    NSString *SQLQuery = [NSString stringWithFormat:@"Delete from match_class where id=%@",divid];
    if ([BurnSoftDatabase runQuery:SQLQuery DatabasePath:dbPath MessageHandler:errorMsg]) {
        bAns = YES;
    }
    return bAns;
}

#pragma mark Get the Division by ID
//return the name of the cDivision based on the ID that is passed
-(NSString *) getDivisionbyID:(NSString *) divid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;
{
    NSString *sAns = @"";
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"select mclass from match_class where ID=%@",divid];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                sAns = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
            }
            sqlite3_close(MatchDB);
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error while creating select statement for getDivisionbyID . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }
    
    return sAns;
}
@end
