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
    sqlite3 *MatchDB;
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
    [DatabaseManagement startiCloudSync];
    BurnSoftDatabase *myObj = [BurnSoftDatabase new];
    dbPathString = [myObj getDatabasePath:@MYDBNAME];
    
    [FormFunctions setBorderButton:self.btnManageCOF];
    [FormFunctions setBorderButton:self.btniTunesBackup];
    [FormFunctions setBorderButton:self.btnManageDivision];
    [FormFunctions setBorderButton:self.btnBackuptoiCloud];
    [FormFunctions setBorderButton:self.btnRestoreFromiCloud];
    
    self.txtNRANumber.text=[self getNRANumber];
    
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
#pragma mark Get NRA Number
//Get the NRA number from the user settings table to display on the UI.
-(NSString *) getNRANumber
{
    NSString *sAns = @"0";
    NSString *errorMsg;
    sqlite3_stmt *statement;
    if (sqlite3_open([dbPathString UTF8String],&MatchDB) == SQLITE_OK) {
        NSString *querySQL = [NSString stringWithFormat:@"select setting_value from user_settings where setting='NRA#'"];
        int ret = sqlite3_prepare_v2(MatchDB,[querySQL UTF8String],-1,&statement,NULL);
        if (ret == SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                sAns = [[NSString alloc] initWithUTF8String:(const char *)sqlite3_column_text(statement,0)];
            }
            sqlite3_close(MatchDB);
        } else {
            errorMsg = [NSString stringWithFormat:@"Error while creating select statement for getMatchIDbyName . '%s'", sqlite3_errmsg(MatchDB)];
        }
        sqlite3_finalize(statement);
    }
    
    return sAns;
}

-(void) updateNRANumber
{
    NSString *errorMsg;
    NSString *SQL = [NSString stringWithFormat:@"update user_settings set setting_value='%@' where setting='NRA#'", self.txtNRANumber.text];
    [BurnSoftDatabase runQuery:SQL DatabasePath:dbPathString MessageHandler:&errorMsg];
    //[FormFunctions checkForError:errorMsg MyTitle:@"Update NRA Number" ViewController:self];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)updateSettings:(id)sender {
    [self updateNRANumber];
}

#pragma mark Backup to iCloud Button
// Action to start the backup to iCloud Drive
- (IBAction)btnBackuptoiCloud:(id)sender {
    DatabaseManagement *myObjDM = [DatabaseManagement new];
    FormFunctions *myObjFF = [FormFunctions new];
    NSString *msg = [NSString new];
    
    BOOL success = [myObjDM backupDatabaseToiCloudByDBName:@MYDBNAME LocalDatabasePath:dbPathString ErrorMessage:&msg];
    if (success){
        msg = [NSString stringWithFormat:@"Databae Backup was successful!"];
        [myObjFF sendMessage:msg MyTitle:@"Success!" ViewController:self];
    } else {
        [myObjFF sendMessage:msg MyTitle:@"ERROR!" ViewController:self];
    }
    [DatabaseManagement startiCloudSync];
    
    myObjDM = nil;
    myObjFF = nil;
}

#pragma mark Restore from iCloud Button
// Action to start the restore from iCloud Drive
- (IBAction)btnRestoreFromiCloud:(id)sender {
    [DatabaseManagement startiCloudSync];
    DatabaseManagement *myObjDM = [DatabaseManagement new];
    FormFunctions *myObjFF = [FormFunctions new];
    NSString *msg = [NSString new];
    BOOL success =[myObjDM restoreDatabaseFromiCloudByDBName:@MYDBNAME LocalDatabasePath:dbPathString ErrorMessage:&msg];
    if (success){
        msg = [NSString stringWithFormat:@"Databae Restore was successful!"];
        [myObjFF sendMessage:msg MyTitle:@"Success!" ViewController:self];
    } else {
        [myObjFF sendMessage:msg MyTitle:@"ERROR!" ViewController:self];
    }
    
    myObjDM = nil;
    myObjFF = nil;
}

@end
