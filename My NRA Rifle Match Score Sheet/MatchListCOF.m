//
//  MatchListCOF.m
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/7/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import "MatchListCOF.h"

@implementation MatchListCOF
{
    NSMutableArray *matchLists;
    sqlite3 *MatchDB;
}

#pragma mark Get All Match Course of Fire Listing Array
//Get the cof, scoredetails  and ID of match for TableView Controller
-(NSMutableArray *) getAllMatchListCOFByMatchID:(NSString *) MID DatabasePath:(NSString *) dbPath ErrorMessage: (NSString **) errorMsg;
{
    matchLists = [NSMutableArray new];
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        [matchLists removeAllObjects];
        NSString *querySQL = [NSString stringWithFormat:@"select ID,cof,scoredetails from view_match_list_cof_details where MLID=%@ order by id COLLATE NOCASE ASC",MID];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *matchID = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
                NSString *MatchName = [NSString new];
                
                if ( sqlite3_column_type(statement, 1) != SQLITE_NULL )
                {
                    MatchName = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement,1)];
                } else {
                    MatchName = @" ";
                }
                NSString *ScoreDetails = [NSString new];
                
                if ( sqlite3_column_type(statement,2) != SQLITE_NULL)
                {
                    ScoreDetails = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                } else {
                    ScoreDetails = @"";
                }
                
                MatchListCOF *myMatch = [MatchListCOF new];
                [myMatch setCOFID:[matchID intValue]];
                [myMatch setCof_name:MatchName];
                [myMatch setScoredetails:ScoreDetails];
                
                [matchLists addObject:myMatch];
                
            }
            sqlite3_close(MatchDB);
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error while creating select statement for getAllMatchListCOFByDatabasePath . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }
    return matchLists;
}

#pragma mark Get All Match Course of Fire Types
//Put all the match Course of Fire types in a array
-(NSArray *) getAllMatchCourseOfFireTypesByDatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;
{
    NSArray *myClass = [NSArray new];
    NSMutableArray *myList = [NSMutableArray new];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        [matchLists removeAllObjects];
        NSString *querySQL = [NSString stringWithFormat:@"select cof from match_cof order by cof COLLATE NOCASE ASC"];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                [myList addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)]];
            }
            sqlite3_close(MatchDB);
            myClass = myList;
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error while creating select statement for getAllMatchCourseOfFireTypesByDatabasePath . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }
    return myList;
}

#pragma mark Get the Match Course of Fire ID by Name
//pass the name and get the ID of the Course of Fire ( match_cof )
-(NSString *) getCourseOfFireIDByName:(NSString *) cof DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;
{
    NSString *sAns = [NSString new];
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"select id from match_cof where cof='%@'",cof];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                sAns=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
            }
            sqlite3_close(MatchDB);
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error while creating select statement for getCourseOfFireIDByName . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }

    return sAns;
}

#pragma mark Get match_list_cof ID
// pass the MatchID and Course of Fire ID to get the match_list_cof.ID
-(NSString *) getCourseOfFireIDfromListByMatchID:(NSString *) mid COFID:(NSString *) cofid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg
{
    NSString *sAns = [NSString new];
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"select id from match_list_cof where MLID=%@ and MCOFID=%@",mid,cofid];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                sAns=[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
            }
            sqlite3_close(MatchDB);
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error while creating select statement for getCourseOfFireIDfromListByMatchID . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }
    
    return sAns;
}

#pragma mark Insert match_list_cof ID
// pass the MatchID and Course of Fire ID to get the match_list_cof.ID
-(NSString *) InsertCourseOfFireIDfromListByMatchID:(NSString *) mid COFID:(NSString *) cofid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg
{
    NSString *sAns = @"";
    NSString *SQLquery = [NSString stringWithFormat:@"insert into match_list_cof (MLID,MCOFID) VALUES(%@,%@)",mid,cofid];
    if ([BurnSoftDatabase runQuery:SQLquery DatabasePath:dbPath MessageHandler:errorMsg])
    {
        sAns = [self getCourseOfFireIDfromListByMatchID:mid COFID:cofid DatabasePath:dbPath ErrorMessage:errorMsg];
    }
    return sAns;
}

#pragma mark  Delete Course Of Fire
//Delete the selected details from the match_list_cof then the match_list_cof_details
-(BOOL) deleteCMatchourseOfFire:(NSString *) mcofid MatchID:(NSString *)mid MatchListCOF:(NSString *) cofid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg
{
    BOOL bANS = NO;
    NSString *mlcofid = [self getCourseOfFireIDfromListByMatchID:mid COFID:cofid DatabasePath:dbPath ErrorMessage:errorMsg];
    NSString *SQLquery = [NSString stringWithFormat:@"delete from match_list_cof where MLID=%@ and MCOFID=%@",mid,mlcofid];
    if ([BurnSoftDatabase runQuery:SQLquery DatabasePath:dbPath MessageHandler:errorMsg])
    {
        SQLquery = [NSString stringWithFormat:@"delete from match_list_cof_details where MLCID=%@",mcofid];
        if ([BurnSoftDatabase runQuery:SQLquery DatabasePath:dbPath MessageHandler:errorMsg])
        {
            bANS = YES;
        }
    }
    
    return  bANS;
    
}
@end
