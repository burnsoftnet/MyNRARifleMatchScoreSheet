//
//  MatchListCOF.h
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/7/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "BurnSoftDatabase.h"
#import "BurnSoftGeneral.h"

@interface MatchListCOF : NSObject

@property (assign) int COFID;
@property (strong,nonatomic) NSString *cof_name;
@property (strong,nonatomic) NSString *scoredetails;

#pragma mark Get All Match Course of Fire Listing Array
//Get the cof, scoredetails  and ID of match for TableView Controller
-(NSMutableArray *) getAllMatchListCOFByMatchID:(NSString *) MID DatabasePath:(NSString *) dbPath ErrorMessage: (NSString **) errorMsg;

#pragma mark Get All Match Course of Fire Types
//Put all the match Course of Fire types in a array
-(NSArray *) getAllMatchCourseOfFireTypesByDatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark Get the Match Course of Fire ID by Name
//pass the name and get the ID of the Course of Fire ( match_cof )
-(NSString *) getCourseOfFireIDByName:(NSString *) cof DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark Get match_list_cof ID
// pass the MatchID and Course of Fire ID to get the match_list_cof.ID
-(NSString *) getCourseOfFireIDfromListByMatchID:(NSString *) mid COFID:(NSString *) cofid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark Insert match_list_cof ID
// pass the MatchID and Course of Fire ID to get the match_list_cof.ID
-(NSString *) InsertCourseOfFireIDfromListByMatchID:(NSString *) mid COFID:(NSString *) cofid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark  Delete Course Of Fire
//Delete the selected details from the match_list_cof then the match_list_cof_details
-(BOOL) deleteCMatchourseOfFire:(NSString *) mcofid MatchID:(NSString *)mid MatchListCOF:(NSString *) cofid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;


@end
