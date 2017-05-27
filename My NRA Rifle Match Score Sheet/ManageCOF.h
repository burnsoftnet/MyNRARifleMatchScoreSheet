//
//  ManageCOF.h
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/27/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "BurnSoftDatabase.h"
#import "BurnSoftGeneral.h"

@interface ManageCOF : NSObject

@property (assign) int COFID;
@property (strong,nonatomic) NSString *cof_name;

#pragma mark Get All Match Listing Array
//Get the formated matchname, matchdetails and ID of match for TableView Controller
-(NSMutableArray *) getAllCourseOfFireByDatabasePath:(NSString *) dbPath ErrorMessage: (NSString **) errorMsg;

#pragma mark Add Course of Fire
//Add a Course of Fire to be used in the spinner
+(BOOL) addCOFName:(NSString *) cof DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark Update Course of Fire
//Update a Course of Fire to be used in the spinner
+(BOOL) updateCOFName:(NSString *) cof CourseOfFireID:(NSString *) cofid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark Delete Course of Fire
//Delete a Course of Fire to be used in the spinner
+(BOOL) DeleteCOFByID:(NSString *) cofid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark Get the Course of Fire by ID
//return the name of the course of fire based on the ID that is passed
-(NSString *) getCourseOfFirebyID:(NSString *) cofid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

@end
