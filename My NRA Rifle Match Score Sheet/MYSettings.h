//
//  MYSettings.h
//  MyEssentialOilRemedies
//
//  Created by burnsoft on 6/23/16.
//  Copyright © 2016 burnsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MYDBNAME "MNRSS.db"       //Database Name
#define MYDBVERSION 1.2        //Expected Database Version for the current version of this app
//extern BOOL * const BUGGERME;   //Enable the Debug Functions for additional information during run time.
static BOOL BUGGERME = NO;
#warning set islist to YES for Lite Version
static BOOL ISLITE = NO;
static int LITE_LIMIT = 10;

@interface MYSettings : NSObject


@end
