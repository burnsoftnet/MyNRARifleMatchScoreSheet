//
//  MainStartViewController.m
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/6/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import "MainStartViewController.h"

@interface MainStartViewController ()

@end

@implementation MainStartViewController

/*!
    @brief - Main Application Startup
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSString *errorMsg;
    //Database Functions copy the database from the applications directory is it doesn't exists in the App documents folder.
    BurnSoftDatabase *myObj = [BurnSoftDatabase new];
    [myObj copyDbIfNeeded:@MYDBNAME MessageHandler:&errorMsg];
    [FormFunctions doBuggermeMessage:[NSString stringWithFormat:@"Error Occured: %@",errorMsg] FromSubFunction:@"MainStartViewController.viewDidLoad"];
    
    //Check the database version to see if it needs to be upgraded.
    DBUpgrade *myDB = [DBUpgrade new];
    [myDB checkDBVersionAgainstExpectedVersion];
    
    //Start iCloud sync for backups
    [DatabaseManagement startiCloudSync];
    
    myObj = nil;
    myDB = nil;

}
/*!
    @brief - Main Application memory wraning handler
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
