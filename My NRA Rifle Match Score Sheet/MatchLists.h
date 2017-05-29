//
//  MatchLists.h
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/5/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "BurnSoftDatabase.h"
#import "BurnSoftGeneral.h"
#import "MatchListCOF.h"

@interface MatchLists : NSObject

@property (assign) int MID;
@property (strong,nonatomic) NSString *matchname;
@property (strong,nonatomic) NSString *matchdetails;
@property (strong,nonatomic) NSString *matchclass;
@property (strong,nonatomic) NSMutableDictionary *classDict;

#pragma mark Get All Match Listing Array
//Get the formated matchname, matchdetails and ID of match for TableView Controller
-(NSMutableArray *) getAllMatchListsByDatabasePath:(NSString *) dbPath ErrorMessage: (NSString **) errorMsg;

#pragma mark Get All Match Listing by Division Array
//Get the formated matchname, matchdetails and ID of match by Division for TableView Controller
-(NSMutableArray *) getAllMatchListsByMatchDivision:(NSString *) mclass  DatabasePath:(NSString *) dbPath ErrorMessage: (NSString **) errorMsg;

#pragma mark Get All Match Listing by Division Array METHOD
+(NSMutableArray *) getAllMatchListsByMatchDivision:(NSString *) mclass  DatabasePath:(NSString *) dbPath ErrorMessage: (NSString **) errorMsg;

#pragma mark Get Distinct Match Classes Array
//Get the distinct match class of match for TableView Controller
-(NSArray *) getDistinctMatchClassesByDatabasePath:(NSString *) dbPath ErrorMessage: (NSString **) errorMsg;

#pragma mark Get All Match Class Types
//Put all the match class types in a array
-(NSArray *) getAllMatchClassTypesByDatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark Insert Match Data
//Create a new match to start recording your courses of fire.
-(BOOL) InsertNewMatchbyName:(NSString *) matchName MatchClassID:(NSString *) MCID Location:(NSString *) location Relay:(NSString *) relay Target:(NSString *) target DateOfMatch:(NSString *) dateofmatch DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark Update Match Data
//UPdate match to start recording your courses of fire.
-(BOOL) updateMatchbyID:(NSString *) mid MatchName:(NSString *) matchName MatchClassID:(NSString *) MCID Location:(NSString *) location Relay:(NSString *) relay Target:(NSString *) target DateOfMatch:(NSString *) dateofmatch DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark Get Match Class ID from Name
//Pass the name of the class to get the Match Class ID back
-(NSString *) getMatchClassIDByName:(NSString *) className DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark Get Match Class Name from ID
//Pass the id of the class to get the Match Class Name back
-(NSString *) getMatchClassNameByID:(NSString *) cid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark Delete Match List
//Delete the Match and all the courses of fire and the data relating to that match
-(BOOL) deleteMatchListsByID:(NSString *) mid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark Copy Match ANd Details
//copy the match and the course of fires in order and add all zeros for the course of fire.
-(void) copyMatchByMatchID:(NSString *) mid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;
@end
