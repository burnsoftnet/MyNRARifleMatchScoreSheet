//
//  CourseOfFire_ViewController.h
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/9/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>
#import "BurnSoftDatabase.h"
#import "BurnSoftGeneral.h"
#import "BurnSoftMath.h"
#import "FormFunctions.h"
#import "MYSettings.h"
#import "MatchListCOF.h"

@interface CourseOfFire_ViewController : UIViewController <UIPickerViewDelegate,UIPickerViewDataSource, UIGestureRecognizerDelegate>
{
    UIPickerView *pvCourseOfFire;
}

@property (strong,nonatomic) NSString *COFID; //Course of Fire Details ID ( match_list_cof_details.ID )
@property (strong, nonatomic) NSString *MID; //Match ID ( match_list_cof_details.MLID )
@property (nonatomic) BOOL isNew; //To determin if we need to load data or not.
@property (strong,nonatomic) NSArray *CourseOfFireDataSource; //CourseofFire Data Source

//Form General
- (IBAction)btnApply:(id)sender;
- (IBAction)btnUpdateStatus:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnApply;

@property (nonatomic, retain) UIPickerView *pvCourseOfFire;
@property (weak, nonatomic) IBOutlet UITextField *txtCourseOfFire; //Course of Fire TextBox

//Sighters Input 1-2
@property (weak, nonatomic) IBOutlet UITextField *txtS1;
@property (weak, nonatomic) IBOutlet UITextField *txtS2;
@property (weak, nonatomic) IBOutlet UISwitch *swXS1;
@property (weak, nonatomic) IBOutlet UISwitch *swXS2;

//For Record 1- 20
@property (weak, nonatomic) IBOutlet UITextField *txtR1;
@property (weak, nonatomic) IBOutlet UITextField *txtR2;
@property (weak, nonatomic) IBOutlet UITextField *txtR3;
@property (weak, nonatomic) IBOutlet UITextField *txtR4;
@property (weak, nonatomic) IBOutlet UITextField *txtR5;
@property (weak, nonatomic) IBOutlet UITextField *txtR6;
@property (weak, nonatomic) IBOutlet UITextField *txtR7;
@property (weak, nonatomic) IBOutlet UITextField *txtR8;
@property (weak, nonatomic) IBOutlet UITextField *txtR9;
@property (weak, nonatomic) IBOutlet UITextField *txtR10;
@property (weak, nonatomic) IBOutlet UITextField *txtR11;
@property (weak, nonatomic) IBOutlet UITextField *txtR12;
@property (weak, nonatomic) IBOutlet UITextField *txtR13;
@property (weak, nonatomic) IBOutlet UITextField *txtR14;
@property (weak, nonatomic) IBOutlet UITextField *txtR15;
@property (weak, nonatomic) IBOutlet UITextField *txtR16;
@property (weak, nonatomic) IBOutlet UITextField *txtR17;
@property (weak, nonatomic) IBOutlet UITextField *txtR18;
@property (weak, nonatomic) IBOutlet UITextField *txtR19;
@property (weak, nonatomic) IBOutlet UITextField *txtR20;

@property (weak, nonatomic) IBOutlet UISwitch *swXR1;
@property (weak, nonatomic) IBOutlet UISwitch *swXR2;
@property (weak, nonatomic) IBOutlet UISwitch *swXR3;
@property (weak, nonatomic) IBOutlet UISwitch *swXR4;
@property (weak, nonatomic) IBOutlet UISwitch *swXR5;
@property (weak, nonatomic) IBOutlet UISwitch *swXR6;
@property (weak, nonatomic) IBOutlet UISwitch *swXR7;
@property (weak, nonatomic) IBOutlet UISwitch *swXR8;
@property (weak, nonatomic) IBOutlet UISwitch *swXR9;
@property (weak, nonatomic) IBOutlet UISwitch *swXR10;
@property (weak, nonatomic) IBOutlet UISwitch *swXR11;
@property (weak, nonatomic) IBOutlet UISwitch *swXR12;
@property (weak, nonatomic) IBOutlet UISwitch *swXR13;
@property (weak, nonatomic) IBOutlet UISwitch *swXR14;
@property (weak, nonatomic) IBOutlet UISwitch *swXR15;
@property (weak, nonatomic) IBOutlet UISwitch *swXR16;
@property (weak, nonatomic) IBOutlet UISwitch *swXR17;
@property (weak, nonatomic) IBOutlet UISwitch *swXR18;
@property (weak, nonatomic) IBOutlet UISwitch *swXR19;
@property (weak, nonatomic) IBOutlet UISwitch *swXR20;

//Totals
@property (weak, nonatomic) IBOutlet UILabel *lblString1Total;
@property (weak, nonatomic) IBOutlet UILabel *lblString2Total;
@property (weak, nonatomic) IBOutlet UILabel *lblCOFTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblXTotal;
@property (weak, nonatomic) IBOutlet UILabel *lblXTotal2;

@end
