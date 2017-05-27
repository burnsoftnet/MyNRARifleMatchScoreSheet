//
//  Settings.m
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/5/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import "Settings.h"

@interface Settings ()

@end

@implementation Settings
{
    NSString *dbPathString;
}
#pragma mark On Form Load
//When form first loads
-(void)viewDidLoad
{
    [super viewDidLoad];
    [self LoadSettings];
    [self loadVersioning];
}

#pragma mark Form Loads Again
// When the view reloads itself
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadData];
}

#pragma mark Reload Data
// Reload the settings and information as if the form first load.
-(void) reloadData
{
    [self LoadSettings];
    [self loadVersioning];
}

#pragma mark Load Settings
// Load the Database Path
-(void) LoadSettings;
{
    BurnSoftDatabase *myObj = [BurnSoftDatabase new];
    dbPathString = [myObj getDatabasePath:@MYDBNAME];
    
    [FormFunctions setBorderButton:self.btnManageCOF];
    [FormFunctions setBorderButton:self.btniTunesBackup];
    [FormFunctions setBorderButton:self.btnManageDivision];
    
    myObj = nil;
}

#pragma mark Load Version
// Get the version of the App and the Database to view in the label boxes
-(void) loadVersioning
{
    BurnSoftDatabase *myObj = [BurnSoftDatabase new];
    NSString *errorMsg;
    
    NSString * appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    self.lblAppVersion.text = [NSString stringWithFormat:@"%@.%@", appVersionString, appBuildString];
    self.lblDBVersion.text = [myObj getCurrentDatabaseVersionfromTable:@"DB_Version" DatabasePath:dbPathString ErrorMessage:&errorMsg];
    
    myObj = nil;
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
