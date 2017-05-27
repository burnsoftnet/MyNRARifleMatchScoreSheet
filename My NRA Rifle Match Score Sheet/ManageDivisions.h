//
//  ManageDivisions.h
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/27/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "BurnSoftDatabase.h"
#import "BurnSoftGeneral.h"

@interface ManageDivisions : NSObject

@property (assign) int DIVID;
@property (strong,nonatomic) NSString *division_name;

#pragma mark Get All Division Listing Array
//Get the id and mclass of division for TableView Controller
-(NSMutableArray *) getAllDivsionsByDatabasePath:(NSString *) dbPath ErrorMessage: (NSString **) errorMsg;

#pragma mark Add Division
//Add a Division to be used in the spinner
+(BOOL) addDivisionName:(NSString *) name DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark Update Division
//Update a Division to be used in the spinner
+(BOOL) updateDivisionName:(NSString *) name DivisionID:(NSString *) divid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark Delete Division
//Delete a Division
+(BOOL) DeleteDivisionByID:(NSString *) divid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;

#pragma mark Get the Division by ID
//return the name of the cDivision based on the ID that is passed
-(NSString *) getDivisionbyID:(NSString *) divid DatabasePath:(NSString *) dbPath ErrorMessage:(NSString **) errorMsg;
@end
