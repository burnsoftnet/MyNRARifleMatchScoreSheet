//
//  LIST_Match_COF.h
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/7/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySettings.h"
#import "FormFunctions.h"
#import "BurnSoftDatabase.h"
#import "MatchListCOF.h"
#import "CourseOfFire_ViewController.h"


@interface LIST_Match_COF : UITableViewController
- (IBAction)refresh:(UIRefreshControl *)sender;   //refresh action for the myTableView
@property (weak, nonatomic) IBOutlet UITableView *myTableView; //Outlet for the UITableView
@property (strong, nonatomic) NSString *MID; //Match ID Container

@end
