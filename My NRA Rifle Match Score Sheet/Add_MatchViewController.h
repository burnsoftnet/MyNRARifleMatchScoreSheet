//
//  Add_MatchViewController.h
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/7/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "MYSettings.h"
#import "FormFunctions.h"
#import "BurnSoftDatabase.h"
#import "MatchLists.h"

@interface Add_MatchViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate,UITextFieldDelegate>
{
    UIDatePicker *datePicker;
    UIPickerView *pvClass;
}

@property (strong, nonatomic) NSString *MID; //Match ID ( match_list_cof_details.MLID )
@property (nonatomic) BOOL isNew; //To determin if we need to load data or not.
@property (weak, nonatomic) IBOutlet UIButton *btnAddMatch;

@property (nonatomic, retain) UIPickerView *pvClass;

@property (strong,nonatomic) NSArray *pickerDataSource;
@property (weak, nonatomic) IBOutlet UIPickerView *pvClassPicker;
@property (weak, nonatomic) IBOutlet UITextField *txtMatchName;
@property (weak, nonatomic) IBOutlet UITextField *txtClass;
@property (weak, nonatomic) IBOutlet UITextField *txtDate;
@property (weak, nonatomic) IBOutlet UITextField *txtLocation;
@property (weak, nonatomic) IBOutlet UITextField *txtRelay;
@property (weak, nonatomic) IBOutlet UITextField *txtTarget;
@property (weak, nonatomic) IBOutlet UIDatePicker *dpMatchOfDate;

- (IBAction)btnAddMatch:(id)sender;



@end
