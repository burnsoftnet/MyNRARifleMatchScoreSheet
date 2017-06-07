//
//  Settings.h
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/5/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "BurnSoftDatabase.h"
#import "MySettings.h"
#import "FormFunctions.h"
#import "DatabaseManagement.h"

@interface Settings : UIViewController <UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtNRANumber;
@property (weak, nonatomic) IBOutlet UILabel *lblAppVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblDBVersion;
@property (weak, nonatomic) IBOutlet UIButton *btniTunesBackup;
@property (weak, nonatomic) IBOutlet UIButton *btnManageDivision;
@property (weak, nonatomic) IBOutlet UIButton *btnManageCOF;
@property (weak, nonatomic) IBOutlet UIButton *btnBackuptoiCloud;
@property (weak, nonatomic) IBOutlet UIButton *btnRestoreFromiCloud;


- (IBAction)updateSettings:(id)sender;
- (IBAction)btnBackuptoiCloud:(id)sender;
- (IBAction)btnRestoreFromiCloud:(id)sender;

@end
