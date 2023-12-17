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
#define FULLVERSIONNAME "My Rifle Match Score Sheet"
//extern BOOL * const BUGGERME;   //Enable the Debug Functions for additional information during run time.
#ifndef NDEBUG
static BOOL BUGGERME = YES;
#else
static BOOL BUGGERME = NO;
#endif

static int LITE_LIMIT = 10;

@interface MYSettings : NSObject
+(BOOL) IsLiteVersion;

@end
