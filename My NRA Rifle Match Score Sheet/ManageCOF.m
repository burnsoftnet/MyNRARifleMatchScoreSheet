//
//  ManageCOF.m
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/27/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import "ManageCOF.h"

@implementation ManageCOF
{
    NSMutableArray *matchCOF;
    sqlite3 *MatchDB;
}

#pragma mark Get All Match Listing Array
//Get the formated matchname, matchdetails and ID of match for TableView Controller
-(NSMutableArray *) getAllCourseOfFireByDatabasePath:(NSString *) dbPath ErrorMessage: (NSString **) errorMsg;
{
    matchCOF = [NSMutableArray new];
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        [matchCOF removeAllObjects];
        NSString *querySQL = [NSString stringWithFormat:@"select ID,cof from match_cof order by cof COLLATE NOCASE ASC"];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                NSString *cofID = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
                NSString *COFName = [NSString new];
                
                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL )
                {
                    COFName = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement,1)];
                } else {
                    COFName = @" ";
                }
                
                ManageCOF *myMatch = [ManageCOF new];
                [myMatch setCOFID:[cofID intValue]];
                [myMatch setCof_name:COFName];
                
                [matchCOF addObject:myMatch];
                
            }
            sqlite3_close(MatchDB);
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error while creating select statement for getAllCourseOfFireByDatabasePath . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }
    return matchCOF;
}

#pragma mark Add Course of Fire
//Add a Course of Fire to be used in the spinner
+(BOOL) addCOFName:(NSString *) cof DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg
{
    BOOL bAns = NO;
    NSString *SQLQuery = [NSString stringWithFormat:@"INSERT INTO match_cof(cof) VALUES('%@')",[BurnSoftGeneral FCString:cof]];
    if ([BurnSoftDatabase runQuery:SQLQuery DatabasePath:dbPath MessageHandler:errorMsg]) {
        bAns = YES;
    }
    return bAns;
}

#pragma mark Update Course of Fire
//Update a Course of Fire to be used in the spinner
+(BOOL) updateCOFName:(NSString *) cof CourseOfFireID:(NSString *) cofid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg
{
    BOOL bAns = NO;
    NSString *SQLQuery = [NSString stringWithFormat:@"UPDATE match_cof set cof='%@' where id=%@",[BurnSoftGeneral FCString:cof],cofid];
    if ([BurnSoftDatabase runQuery:SQLQuery DatabasePath:dbPath MessageHandler:errorMsg]) {
        bAns = YES;
    }
    return bAns;
}

#pragma mark Delete Course of Fire
//Delete a Course of Fire to be used in the spinner
+(BOOL) DeleteCOFByID:(NSString *) cofid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg
{
    BOOL bAns = NO;
    NSString *SQLQuery = [NSString stringWithFormat:@"Delete from match_cof where id=%@",cofid];
    if ([BurnSoftDatabase runQuery:SQLQuery DatabasePath:dbPath MessageHandler:errorMsg]) {
        bAns = YES;
    }
    return bAns;
}
#pragma mark Get the Course of Fire by ID
//return the name of the course of fire based on the ID that is passed
-(NSString *) getCourseOfFirebyID:(NSString *) cofid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;
{
    NSString *sAns = @"";
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"select cof from match_cof where ID=%@",cofid];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                sAns = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
            }
            sqlite3_close(MatchDB);
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error while creating select statement for getCourseOfFirebyID . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }

    return sAns;
}
@end
