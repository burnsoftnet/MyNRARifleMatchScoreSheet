//
//  ManageCOFTableViewController.h
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/27/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormFunctions.h"
#import "MYSettings.h"
#import "BurnSoftDatabase.h"
#import "ManageCOF.h"

@interface ManageCOFTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

- (IBAction)refresh:(UIRefreshControl *)sender; //refresh action for the myTableView
@property (weak, nonatomic) IBOutlet UITableView *myTableView; //Outlet for the UITableView

@end
