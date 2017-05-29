//
//  MatchLists.m
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/5/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import "MatchLists.h"

@implementation MatchLists
{
    NSMutableArray *matchLists;
    sqlite3 *MatchDB;
}

#pragma mark Get All Match Listing Array
//Get the formated matchname, matchdetails and ID of match for TableView Controller
-(NSMutableArray *) getAllMatchListsByDatabasePath:(NSString *) dbPath ErrorMessage: (NSString **) errorMsg;
{
    matchLists = [NSMutableArray new];
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        [matchLists removeAllObjects];
        NSString *querySQL = [NSString stringWithFormat:@"select ID,matchname,matchdetails,mclass from view_match_list order by mclass,dt COLLATE NOCASE ASC"];
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
                
                NSString *MatchDetails = [NSString new];
                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL )
                {
                    MatchDetails = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement,2)];
                } else {
                    MatchDetails = @"NEW";
                }
                
                NSString *mClass = [NSString new];
                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL)
                {
                    mClass = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                } else {
                    mClass =@"UNKNOWN";
                }
                
                
                MatchLists *myMatch = [MatchLists new];
                [myMatch setMID:[matchID intValue]];
                [myMatch setMatchname:MatchName];
                [myMatch setMatchdetails:MatchDetails];
                [myMatch setMatchclass:mClass];
                
                [matchLists addObject:myMatch];
                
            }
            sqlite3_close(MatchDB);
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error while creating select statement for getAllMatchLists . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }
    return matchLists;
}

#pragma mark Get All Match Listing by Division Array
//Get the formated matchname, matchdetails and ID of match by Division for TableView Controller
-(NSMutableArray *) getAllMatchListsByMatchDivision:(NSString *) mclass  DatabasePath:(NSString *) dbPath ErrorMessage: (NSString **) errorMsg;
{
    matchLists = [NSMutableArray new];
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        [matchLists removeAllObjects];
        NSString *querySQL = [NSString stringWithFormat:@"select ID,matchname,matchdetails,mclass from view_match_list where mclass='%@' order by dt COLLATE NOCASE ASC",mclass];
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
                
                NSString *MatchDetails = [NSString new];
                if ( sqlite3_column_type(statement, 2) != SQLITE_NULL )
                {
                    MatchDetails = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement,2)];
                } else {
                    MatchDetails = @"NEW";
                }
                
                NSString *mClass = [NSString new];
                if ( sqlite3_column_type(statement, 3) != SQLITE_NULL)
                {
                    mClass = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                } else {
                    mClass =@"UNKNOWN";
                }
                
                
                MatchLists *myMatch = [MatchLists new];
                [myMatch setMID:[matchID intValue]];
                [myMatch setMatchname:MatchName];
                [myMatch setMatchdetails:MatchDetails];
                [myMatch setMatchclass:mClass];
                
                [matchLists addObject:myMatch];
                
            }
            sqlite3_close(MatchDB);
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error while creating select statement for getAllMatchLists . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }
    return matchLists;
}

#pragma mark Get All Match Listing by Division Array METHOD
+(NSMutableArray *) getAllMatchListsByMatchDivision:(NSString *) mclass  DatabasePath:(NSString *) dbPath ErrorMessage: (NSString **) errorMsg;
{
    MatchLists *myObj = [MatchLists new];
    return [myObj getAllMatchListsByMatchDivision:mclass DatabasePath:dbPath ErrorMessage:errorMsg];
}

#pragma mark Get Distinct Match Classes Array
//Get the distinct match class of match for TableView Controller
-(NSArray *) getDistinctMatchClassesByDatabasePath:(NSString *) dbPath ErrorMessage: (NSString **) errorMsg;
{
    matchLists = [NSMutableArray new];
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        [matchLists removeAllObjects];
        NSString *querySQL = [NSString stringWithFormat:@"select DISTINCT(mclass) from view_match_list order by mclass COLLATE NOCASE ASC"];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                
                NSString *mClass = [NSString new];
                if ( sqlite3_column_type(statement, 0) != SQLITE_NULL)
                {
                    mClass = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)];
                } else {
                    mClass =@"UNKNOWN";
                }
                
                MatchLists *myMatch = [MatchLists new];
                [myMatch setMatchclass:mClass];
                
                [matchLists addObject:myMatch];
                
            }
            sqlite3_close(MatchDB);
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error while creating select statement for getAllMatchLists . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }
    return matchLists;
}

#pragma mark Get All Match Class Types
//Put all the match class types in a array
-(NSArray *) getAllMatchClassTypesByDatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;
{
    NSArray *myClass = [NSArray new];
    NSMutableArray *myList = [NSMutableArray new];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        [matchLists removeAllObjects];
        NSString *querySQL = [NSString stringWithFormat:@"select mclass from match_class order by mclass COLLATE NOCASE ASC"];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                [myList addObject:[[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)]];
            }
            sqlite3_close(MatchDB);
            myClass = myList;
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error while creating select statement for getAllMatchClassTypesByDatabasePath . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }
    return myList;
}
#pragma mark Insert Match Data
//Create a new match to start recording your courses of fire.
-(BOOL) InsertNewMatchbyName:(NSString *) matchName MatchClassID:(NSString *) MCID Location:(NSString *) location Relay:(NSString *) relay Target:(NSString *) target DateOfMatch:(NSString *) dateofmatch DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg
{
    BOOL bAns = NO;
    NSString *querySQL = [NSString stringWithFormat:@"INSERT INTO match_list (dt,name,location,target,relay,MCID) VALUES ('%@','%@','%@','%@','%@',%@)", dateofmatch,[BurnSoftGeneral FCString:matchName],[BurnSoftGeneral FCString:location],target,relay,MCID];
    bAns = [BurnSoftDatabase runQuery:querySQL DatabasePath:dbPath MessageHandler:errorMsg];
    
    return bAns;
}

#pragma mark Update Match Data
//UPdate match to start recording your courses of fire.
-(BOOL) updateMatchbyID:(NSString *) mid MatchName:(NSString *) matchName MatchClassID:(NSString *) MCID Location:(NSString *) location Relay:(NSString *) relay Target:(NSString *) target DateOfMatch:(NSString *) dateofmatch DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg
{
    BOOL bAns = NO;
    NSString *querySQL = [NSString stringWithFormat:@"UPDATE match_list set dt='%@',name='%@',location='%@',target='%@',relay='%@',MCID=%@ where ID=%@", dateofmatch,[BurnSoftGeneral FCString:matchName],[BurnSoftGeneral FCString:location],target,relay,MCID,mid];
    bAns = [BurnSoftDatabase runQuery:querySQL DatabasePath:dbPath MessageHandler:errorMsg];
    
    return bAns;
}

#pragma mark Get Match Class ID from Name
//Pass the name of the class to get the Match Class ID back
-(NSString *) getMatchClassIDByName:(NSString *) className DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg
{
    NSString *sAns = @"";
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ID from match_class where mclass='%@'", [BurnSoftGeneral FCString:className]];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                sAns = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
            }
            sqlite3_close(MatchDB);
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error with Insert statement for getMatchClassIDByName. '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }

    return sAns;
}

#pragma mark Get Match Class Name from ID
//Pass the id of the class to get the Match Class Name back
-(NSString *) getMatchClassNameByID:(NSString *) cid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg
{
    NSString *sAns = @"";
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT mclass from match_class where ID='%@'", cid];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                sAns = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
            }
            sqlite3_close(MatchDB);
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error with Insert statement for getMatchClassNameByID . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }
    
    return sAns;
}

#pragma mark Delete Match List
//Delete the Match and all the courses of fire and the data relating to that match
-(BOOL) deleteMatchListsByID:(NSString *) mid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg
{
    BOOL bANS = NO;
    NSString *SQLquery = [NSString stringWithFormat:@"delete from match_list_cof_details where MLID=%@",mid];
    if ([BurnSoftDatabase runQuery:SQLquery DatabasePath:dbPath MessageHandler:errorMsg])
    {
        SQLquery = [NSString stringWithFormat:@"delete from match_list_cof where MLID=%@",mid];
         if ([BurnSoftDatabase runQuery:SQLquery DatabasePath:dbPath MessageHandler:errorMsg])
         {
             SQLquery = [NSString stringWithFormat:@"delete from match_list where ID=%@",mid];
              if ([BurnSoftDatabase runQuery:SQLquery DatabasePath:dbPath MessageHandler:errorMsg])
              {
                  bANS = YES;
              }
         }
    }
    return bANS;
}

#pragma Get Match ID by values
//find the match that has all the values peassed
-(NSString *) getMatchIDbyName:(NSString *) matchName MatchClassID:(NSString *) MCID Location:(NSString *) location Relay:(NSString *) relay Target:(NSString *) target DateOfMatch:(NSString *) dateofmatch DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;
{
    NSString *sAns = @"0";
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        [matchLists removeAllObjects];
        NSString *querySQL = [NSString stringWithFormat:@"select id from match_list where name='%@' and location='%@' and target='%@' and relay='%@' and MCID=%@ and dt='%@'",matchName,location,target,relay,MCID,dateofmatch];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                sAns = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
            }
            sqlite3_close(MatchDB);
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error while creating select statement for getMatchIDbyName . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }

    return sAns;
}

#pragma mark Copy Match ANd Details
//copy the match and the course of fires in order and add all zeros for the course of fire.
-(void) copyMatchByMatchID:(NSString *) mid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;
{
    NSString *name = [NSString new];
    NSString *location = [NSString new];
    NSString *target = [NSString new];
    NSString *relay = [NSString new];
    NSString *MCID = [NSString new];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSString *dateOfMatch = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)[components year],(long)[components month],(long)[components day]];
    
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"select name,location,target,relay,MCID from match_list where id=%@",mid];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                name = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
                location = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement,1)];
                target = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement,2)];
                relay = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];
                MCID = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)];
            }
            sqlite3_close(MatchDB);
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error while creating select statement for copyMatchByMatchID . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }
    
    [self InsertNewMatchbyName:name MatchClassID:MCID Location:location Relay:relay Target:target DateOfMatch:dateOfMatch DatabasePath:dbPath ErrorMessage:errorMsg];
    NSString *matchID = [self getMatchIDbyName:name MatchClassID:MCID Location:location Relay:relay Target:target DateOfMatch:dateOfMatch DatabasePath:dbPath ErrorMessage:errorMsg];
    //NSLog(@"match id is %@",matchID);

    MatchListCOF *myObj = [MatchListCOF new];
    
    NSMutableArray *arryCOF = [NSMutableArray new];
    
    if (sqlite3_open([dbPath UTF8String],&MatchDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"select MCOFID from match_list_cof where MLID=%@ order by ID ASC",mid];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                NSString *CourseOfFireID = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
                [arryCOF addObject:CourseOfFireID];
            }
            sqlite3_close(MatchDB);
        } else {
            *errorMsg = [NSString stringWithFormat:@"Error while creating select statement for copyMatchByMatchID . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }
    
    for (int x = 0; x < [arryCOF count]; x++) {
        NSString *CourseOfFireID = [arryCOF objectAtIndex:x];
        NSString *MLCID = [NSString new];
        
        MLCID = [myObj InsertCourseOfFireIDfromListByMatchID:matchID COFID:CourseOfFireID DatabasePath:dbPath ErrorMessage:errorMsg];
        
        NSString *SQLquery = [NSString stringWithFormat:@"INSERT INTO match_list_cof_details(MLCID,MLID,MCOFID,s1,s2,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,total1,total2,endtotal,x_count_1,x_count_2) VALUES(%@,%@,%@,'0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0','0',0,0,0,0,0);",MLCID,matchID,CourseOfFireID];
        [BurnSoftDatabase runQuery:SQLquery DatabasePath:dbPath MessageHandler:errorMsg];
    }
    myObj = nil;
    
}


@end
