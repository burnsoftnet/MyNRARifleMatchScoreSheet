//
//  LIST_Matches.h
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/5/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MySettings.h"
#import "FormFunctions.h"
#import "BurnSoftDatabase.h"
#import "MatchLists.h"
#import "LIST_Match_COF.h"
#import "Add_MatchViewController.h"

static BOOL USEGROUPING = YES;

@interface LIST_Matches : UITableViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)refresh:(UIRefreshControl *)sender; //refresh action for the myTableView
@property (weak, nonatomic) IBOutlet UITableView *myTableView; //Outlet for the UITableView

@end
