//
//  CourseOfFire_ViewController.m
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/9/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import "CourseOfFire_ViewController.h"

@interface CourseOfFire_ViewController ()

@end

@implementation CourseOfFire_ViewController
{
    sqlite3 *MatchDB;
    NSString *dbPathString;
    NSString *matchListCOFList;
}
@synthesize pvCourseOfFire;

#pragma mark View Did Load
- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupGlobalVars];
    [self loadData];

    [self startPicker];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapReceived:)];
    [tapGestureRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapGestureRecognizer];
}
-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    //Dissmiss the keyboard when the view is selected
    [self.txtS1 resignFirstResponder];
    [self.txtS2 resignFirstResponder];
    
    [self.txtR1 resignFirstResponder];
    [self.txtR2 resignFirstResponder];
    [self.txtR3 resignFirstResponder];
    [self.txtR4 resignFirstResponder];
    [self.txtR5 resignFirstResponder];
    [self.txtR6 resignFirstResponder];
    [self.txtR7 resignFirstResponder];
    [self.txtR8 resignFirstResponder];
    [self.txtR9 resignFirstResponder];
    [self.txtR10 resignFirstResponder];
    [self.txtR11 resignFirstResponder];
    [self.txtR12 resignFirstResponder];
    [self.txtR13 resignFirstResponder];
    [self.txtR14 resignFirstResponder];
    [self.txtR15 resignFirstResponder];
    [self.txtR16 resignFirstResponder];
    [self.txtR17 resignFirstResponder];
    [self.txtR18 resignFirstResponder];
    [self.txtR19 resignFirstResponder];
    [self.txtR20 resignFirstResponder];
}

-(void) startPicker
{
    // Calculate the screen's width.
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float pickerWidth = screenWidth * 3 / 4;
    
    // Calculate the starting x coordinate.
    float xPoint = screenWidth / 2 - pickerWidth / 2;
    
    // Init the picker view.
    pvCourseOfFire = [[UIPickerView alloc] init];
    [pvCourseOfFire setDataSource:self];
    [pvCourseOfFire setDelegate:self];
    
    // Set the picker's frame. We set the y coordinate to 50px.
    [pvCourseOfFire setFrame: CGRectMake(xPoint, 50.0f, pickerWidth, 200.0f)];
    
    // Before we add the picker view to our view, let's do a couple more
    // things. First, let the selection indicator (that line inside the
    // picker view that highlights your selection) to be shown.
    pvCourseOfFire.showsSelectionIndicator = YES;
    
    // Allow us to pre-select the third option in the pickerView.
    [pvCourseOfFire selectRow:2 inComponent:0 animated:YES];
    
    // OK, we are ready. Add the picker in our view.
    //[self.view addSubview: pvCourseOfFire];

    [self.txtCourseOfFire setInputView:pvCourseOfFire];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(SelectCourseOfFireDataSource)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.txtCourseOfFire setInputAccessoryView:toolBar];
}

-(void) SelectCourseOfFireDataSource
{
    [self.txtCourseOfFire resignFirstResponder];
}


#pragma mark Did Recieve Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Setup Global Variables
// Setup the global variablies like the database path
-(void) setupGlobalVars
{
    BurnSoftDatabase *myPath = [BurnSoftDatabase new];
    dbPathString = [myPath getDatabasePath:@MYDBNAME];
    
    [FormFunctions doBuggermeMessage:dbPathString FromSubFunction:@"CourseOfFire_ViewController.setupGlobalVars.DatabasePath"];
    
    [FormFunctions setBorderButton:self.btnApply];
    
    myPath = nil;
}
#pragma mark Set The Hit Factory Value
//Used when Loading data, pass the value that is stored in the database, if it is an x it will flip the switch on and set the text value to 10
//otherwise it will set the textbox to the value and turn the switch off.
-(void) SetHitFactoryByValue:(NSString *) sValue TextBox:(UITextField *) myBox XSwitch:(UISwitch *) mySwitch
{
    if ([sValue isEqualToString:@"x"])
    {
        [mySwitch setOn:YES];
        [myBox setText:@"10"];
    } else {
        [mySwitch setOn:NO];
        [myBox setText:sValue];
    }
}
#pragma mark Get Value from TextBox or Switch
//Get the value from the textbox unless the value is an x then return x
-(NSString *) getValueFromTextBox:(UITextField *) myBox xSwitch:(UISwitch *) mySwitch
{
    NSString *sAns = myBox.text;
    if ([mySwitch isOn])
    {
        sAns = @"x";
    } else
    {
        if ([sAns isEqualToString:@""])
        {
            sAns = @"0";
        }
    }
    
    return sAns;
}

-(NSString *) AddValueFromTextBox:(UITextField *) myBox xSwitch:(UISwitch *) mySwitch AddSwitch:(NSString **) addswitch
{
    NSString *sAns = myBox.text;
    *addswitch = @"0";
    if ([mySwitch isOn])
    {
        sAns = @"10";
        *addswitch = @"1";
        [myBox setText:@"10"];
    }
    return sAns;
}

#pragma mark Load Data
//If this is not a new form, it will run this sub to load the data from the database based on the Course Of Fire ID ( COFID )
-(void) loadData
{
    NSString *errorMsg;
    
    MatchListCOF *myObj = [MatchListCOF new];
    _CourseOfFireDataSource = [myObj getAllMatchCourseOfFireTypesByDatabasePath:dbPathString ErrorMessage:&errorMsg];

    if (!_isNew)
    {
        sqlite3_stmt * statement;
        if (sqlite3_open([dbPathString UTF8String],&MatchDB) == SQLITE_OK) {
            NSString *querySQL = [NSString stringWithFormat:@"SELECT ID, MCOFID,cof,s1,s2,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,total1,total2,endtotal,x_count_1,x_count_2,MLCID from view_match_list_cof_details where ID=%@",self.COFID];
            int ret = sqlite3_prepare_v2(MatchDB, [querySQL UTF8String], -1, &statement, NULL);
            int sqlColumn = 0;
            
            if (ret == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    sqlColumn = 1;
                    //NSString *courseOfFireID = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, sqlColumn)];
                    
                    sqlColumn = 2;
                    NSString *courseOfFire = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, sqlColumn)];
                    self.txtCourseOfFire.text = courseOfFire;
                    
                    //sighter 1
                    sqlColumn = 3;
                    //NSString *TargetValue = [[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)];
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtS1 XSwitch:self.swXS1];
                    
                    //sighter 2
                    sqlColumn = 4;
                    //TargetValue = [[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)];
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtS2 XSwitch:self.swXS2];
                    
                    //record 1
                    sqlColumn = 5;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR1 XSwitch:self.swXR1];
                    
                    //record 2
                    sqlColumn = 6;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR2 XSwitch:self.swXR2];
                    
                    //record 3
                    sqlColumn = 7;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR3 XSwitch:self.swXR3];
                    
                    //record 4
                    sqlColumn = 8;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR4 XSwitch:self.swXR4];
                    
                    //record 5
                    sqlColumn = 9;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR5 XSwitch:self.swXR5];
                    
                    //record 6
                    sqlColumn = 10;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR6 XSwitch:self.swXR6];
                    
                    //record 7
                    sqlColumn = 11;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR7 XSwitch:self.swXR7];
                    
                    //record 8
                    sqlColumn = 12;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR8 XSwitch:self.swXR8];
                    
                    //record 9
                    sqlColumn = 13;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR9 XSwitch:self.swXR9];
                    
                    //record 10
                    sqlColumn = 14;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR10 XSwitch:self.swXR10];
                    
                    //record 11
                    sqlColumn = 15;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR11 XSwitch:self.swXR11];
                    
                    //record 12
                    sqlColumn = 16;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR12 XSwitch:self.swXR12];
                    
                    //record 13
                    sqlColumn = 17;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR13 XSwitch:self.swXR13];
                    
                    //record 14
                    sqlColumn = 18;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR14 XSwitch:self.swXR14];
                    
                    //record 15
                    sqlColumn = 19;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR15 XSwitch:self.swXR15];
                    
                    //record 16
                    sqlColumn = 20;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR16 XSwitch:self.swXR16];
                    
                    //record 17
                    sqlColumn = 21;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR17 XSwitch:self.swXR17];
                    
                    //record 18
                    sqlColumn = 22;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR18 XSwitch:self.swXR18];
                    
                    //record 19
                    sqlColumn = 23;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR19 XSwitch:self.swXR19];
                    
                    //record 20
                    sqlColumn = 24;
                    [self SetHitFactoryByValue:[[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)] TextBox:self.txtR20 XSwitch:self.swXR20];
                    //String 1 Total
                    sqlColumn = 25;
                    _lblString1Total.text = [[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)];
                    
                    //String 2 Total;
                    sqlColumn = 26;
                    _lblString2Total.text = [[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)];
                    
                    //Total Score
                    sqlColumn = 27;
                    _lblCOFTotal.text = [[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)];
                    
                    //X total string1
                    sqlColumn = 28;
                    _lblXTotal.text = [[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)];
                    
                    //X total String2
                    sqlColumn = 29;
                    _lblXTotal2.text = [[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)];
                    
                    //MLCID or Match List COF List ID
                    sqlColumn = 30;
                    matchListCOFList = [[NSString alloc] initWithUTF8String: (const char*)sqlite3_column_text(statement, sqlColumn)];
                }
                sqlite3_finalize(statement);
            }
        }
    }
    myObj = nil;
}

//Add up all the fields to produce the final results
- (void) AddallFields
{
    
    NSString *switchvalue = [NSString new];
    NSString *xtotal_string1 = [NSString new];
    NSString *xtotal_string2 = [NSString new];
    NSString *string1total = [NSString new];
    NSString *string2total = [NSString new];
    
    [self AddValueFromTextBox:self.txtS1 xSwitch:self.swXS1 AddSwitch:&switchvalue];
    [self AddValueFromTextBox:self.txtS2 xSwitch:self.swXS2 AddSwitch:&switchvalue];
    switchvalue = @"0";
    xtotal_string1 = @"0";
    xtotal_string2 = @"0";
    
    NSString *r1 = [self AddValueFromTextBox:self.txtR1 xSwitch:self.swXR1 AddSwitch:&switchvalue];
    string1total = [BurnSoftMath AddTwoItemsAsIntegerString:string1total :r1];
    xtotal_string1 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string1 :switchvalue];
    
    NSString *r2 = [self AddValueFromTextBox:self.txtR2 xSwitch:self.swXR2 AddSwitch:&switchvalue];
    string1total = [BurnSoftMath AddTwoItemsAsIntegerString:string1total :r2];
    xtotal_string1 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string1 :switchvalue];
    
    NSString *r3 = [self AddValueFromTextBox:self.txtR3 xSwitch:self.swXR3 AddSwitch:&switchvalue];
    string1total = [BurnSoftMath AddTwoItemsAsIntegerString:string1total :r3];
    xtotal_string1 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string1 :switchvalue];
    
    NSString *r4 = [self AddValueFromTextBox:self.txtR4 xSwitch:self.swXR4 AddSwitch:&switchvalue];
    string1total = [BurnSoftMath AddTwoItemsAsIntegerString:string1total :r4];
    xtotal_string1 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string1 :switchvalue];
    
    NSString *r5 = [self AddValueFromTextBox:self.txtR5 xSwitch:self.swXR5 AddSwitch:&switchvalue];
    string1total = [BurnSoftMath AddTwoItemsAsIntegerString:string1total :r5];
    xtotal_string1 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string1 :switchvalue];
    
    NSString *r6 = [self AddValueFromTextBox:self.txtR6 xSwitch:self.swXR6 AddSwitch:&switchvalue];
    string1total = [BurnSoftMath AddTwoItemsAsIntegerString:string1total :r6];
    xtotal_string1 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string1 :switchvalue];
    
    NSString *r7 = [self AddValueFromTextBox:self.txtR7 xSwitch:self.swXR7 AddSwitch:&switchvalue];
    string1total = [BurnSoftMath AddTwoItemsAsIntegerString:string1total :r7];
    xtotal_string1 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string1 :switchvalue];
    
    NSString *r8 = [self AddValueFromTextBox:self.txtR8 xSwitch:self.swXR8 AddSwitch:&switchvalue];
    string1total = [BurnSoftMath AddTwoItemsAsIntegerString:string1total :r8];
    xtotal_string1 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string1 :switchvalue];
    
    NSString *r9 = [self AddValueFromTextBox:self.txtR9 xSwitch:self.swXR9 AddSwitch:&switchvalue];
    string1total = [BurnSoftMath AddTwoItemsAsIntegerString:string1total :r9];
    xtotal_string1 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string1 :switchvalue];
    
    NSString *r10 = [self AddValueFromTextBox:self.txtR10 xSwitch:self.swXR10 AddSwitch:&switchvalue];
    string1total = [BurnSoftMath AddTwoItemsAsIntegerString:string1total :r10];
    xtotal_string1 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string1 :switchvalue];

    self.lblXTotal.text = xtotal_string1;
    self.lblString1Total.text = string1total;
    switchvalue = @"0";
    
    NSString *r11 = [self AddValueFromTextBox:self.txtR11 xSwitch:self.swXR11 AddSwitch:&switchvalue];
    string2total = [BurnSoftMath AddTwoItemsAsIntegerString:string2total :r11];
    xtotal_string2 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string2 :switchvalue];
    
    NSString *r12 = [self AddValueFromTextBox:self.txtR12 xSwitch:self.swXR12 AddSwitch:&switchvalue];
    string2total = [BurnSoftMath AddTwoItemsAsIntegerString:string2total :r12];
    xtotal_string2 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string2 :switchvalue];
    
    NSString *r13 = [self AddValueFromTextBox:self.txtR13 xSwitch:self.swXR13 AddSwitch:&switchvalue];
    string2total = [BurnSoftMath AddTwoItemsAsIntegerString:string2total :r13];
    xtotal_string2 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string2 :switchvalue];
    
    NSString *r14 = [self AddValueFromTextBox:self.txtR14 xSwitch:self.swXR14 AddSwitch:&switchvalue];
    string2total = [BurnSoftMath AddTwoItemsAsIntegerString:string2total :r14];
    xtotal_string2 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string2 :switchvalue];
    
    NSString *r15 = [self AddValueFromTextBox:self.txtR15 xSwitch:self.swXR15 AddSwitch:&switchvalue];
    string2total = [BurnSoftMath AddTwoItemsAsIntegerString:string2total :r15];
    xtotal_string2 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string2 :switchvalue];
    
    NSString *r16 = [self AddValueFromTextBox:self.txtR16 xSwitch:self.swXR16 AddSwitch:&switchvalue];
    string2total = [BurnSoftMath AddTwoItemsAsIntegerString:string2total :r16];
    xtotal_string2 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string2 :switchvalue];
    
    NSString *r17 = [self AddValueFromTextBox:self.txtR17 xSwitch:self.swXR17 AddSwitch:&switchvalue];
    string2total = [BurnSoftMath AddTwoItemsAsIntegerString:string2total :r17];
    xtotal_string2 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string2 :switchvalue];
    
    NSString *r18 = [self AddValueFromTextBox:self.txtR18 xSwitch:self.swXR18 AddSwitch:&switchvalue];
    string2total = [BurnSoftMath AddTwoItemsAsIntegerString:string2total :r18];
    xtotal_string2 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string2 :switchvalue];
    
    NSString *r19 = [self AddValueFromTextBox:self.txtR19 xSwitch:self.swXR19 AddSwitch:&switchvalue];
    string2total = [BurnSoftMath AddTwoItemsAsIntegerString:string2total :r19];
    xtotal_string2 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string2 :switchvalue];
    
    NSString *r20 = [self AddValueFromTextBox:self.txtR20 xSwitch:self.swXR20 AddSwitch:&switchvalue];
    string2total = [BurnSoftMath AddTwoItemsAsIntegerString:string2total :r20];
    xtotal_string2 = [BurnSoftMath AddTwoItemsAsIntegerString:xtotal_string2 :switchvalue];
    
    self.lblXTotal2.text = xtotal_string2;
    self.lblString2Total.text = string2total;
    
    self.lblCOFTotal.text = [BurnSoftMath AddTwoItemsAsIntegerString:string1total :string2total];
}
- (IBAction)btnUpdateStatus:(id)sender
{
     [self AddallFields];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark Button Apply
//Called Applied because it can be used in both adding new or updating existing.
- (IBAction)btnApply:(id)sender {
    MatchListCOF *myObj = [MatchListCOF new];
    NSString *errorMessage;
    [self AddallFields];
    
    NSString *CourseOfFire = self.txtCourseOfFire.text;
    NSString *MCOFID = [myObj getCourseOfFireIDByName:CourseOfFire DatabasePath:dbPathString ErrorMessage:&errorMessage];
    
    NSString *s1 = [self getValueFromTextBox:self.txtS1 xSwitch:self.swXS1];
    NSString *s2 = [self getValueFromTextBox:self.txtS2 xSwitch:self.swXS2];
    
    NSString *r1 = [self getValueFromTextBox:self.txtR1 xSwitch:self.swXR1];
    NSString *r2 = [self getValueFromTextBox:self.txtR2 xSwitch:self.swXR2];
    NSString *r3 = [self getValueFromTextBox:self.txtR3 xSwitch:self.swXR3];
    NSString *r4 = [self getValueFromTextBox:self.txtR4 xSwitch:self.swXR4];
    NSString *r5 = [self getValueFromTextBox:self.txtR5 xSwitch:self.swXR5];
    NSString *r6 = [self getValueFromTextBox:self.txtR6 xSwitch:self.swXR6];
    NSString *r7 = [self getValueFromTextBox:self.txtR7 xSwitch:self.swXR7];
    NSString *r8 = [self getValueFromTextBox:self.txtR8 xSwitch:self.swXR8];
    NSString *r9 = [self getValueFromTextBox:self.txtR9 xSwitch:self.swXR9];
    NSString *r10 = [self getValueFromTextBox:self.txtR10 xSwitch:self.swXR10];
    NSString *r11 = [self getValueFromTextBox:self.txtR11 xSwitch:self.swXR11];
    NSString *r12 = [self getValueFromTextBox:self.txtR12 xSwitch:self.swXR12];
    NSString *r13 = [self getValueFromTextBox:self.txtR13 xSwitch:self.swXR13];
    NSString *r14 = [self getValueFromTextBox:self.txtR14 xSwitch:self.swXR14];
    NSString *r15 = [self getValueFromTextBox:self.txtR15 xSwitch:self.swXR15];
    NSString *r16 = [self getValueFromTextBox:self.txtR16 xSwitch:self.swXR16];
    NSString *r17 = [self getValueFromTextBox:self.txtR17 xSwitch:self.swXR17];
    NSString *r18 = [self getValueFromTextBox:self.txtR18 xSwitch:self.swXR18];
    NSString *r19 = [self getValueFromTextBox:self.txtR19 xSwitch:self.swXR19];
    NSString *r20 = [self getValueFromTextBox:self.txtR20 xSwitch:self.swXR20];
    
    NSString *total1 = _lblString1Total.text;
    NSString *total2 = _lblString2Total.text;
    NSString *endtotal = _lblCOFTotal.text;
    NSString *X_Total1 = _lblXTotal.text;
    NSString *X_Total2 = _lblXTotal2.text;
    NSString *X_Total = [BurnSoftMath AddTwoItemsAsIntegerString:X_Total1 :X_Total2];
    NSString *MLCID = [NSString new];
    
    
    NSString *SQLquery = [NSString new];
    
    if (self.isNew)
    {
        MLCID = [myObj InsertCourseOfFireIDfromListByMatchID:self.MID COFID:MCOFID DatabasePath:dbPathString ErrorMessage:&errorMessage];
        
        SQLquery = [NSString stringWithFormat:@"INSERT INTO match_list_cof_details(MLCID,MLID,MCOFID,s1,s2,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,total1,total2,endtotal,x_count_1,x_count_2,xtotal) VALUES(%@,%@,%@,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%@,%@,%@,%@,%@,%@);",MLCID,self.MID,MCOFID,s1,s2,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,total1,total2,endtotal,X_Total1,X_Total2,X_Total];
    } else {
        //MLCID = [myObj getCourseOfFireIDfromListByMatchID:self.MID COFID:MCOFID DatabasePath:dbPathString ErrorMessage:&errorMessage];
        MLCID = matchListCOFList;
        SQLquery = [NSString stringWithFormat:@"update match_list_cof set MCOFID=%@ where ID=%@",MCOFID ,matchListCOFList];
        [BurnSoftDatabase runQuery:SQLquery DatabasePath:dbPathString MessageHandler:&errorMessage];
        
        SQLquery = [NSString stringWithFormat:@"UPDATE match_list_cof_details set MLCID=%@,MLID=%@,MCOFID=%@,s1='%@',s2='%@',r1='%@',r2='%@',r3='%@',r4='%@',r5='%@',r6='%@',r7='%@',r8='%@',r9='%@',r10='%@',r11='%@',r12='%@',r13='%@',r14='%@',r15='%@',r16='%@',r17='%@',r18='%@',r19='%@',r20='%@',total1=%@,total2=%@,endtotal=%@,x_count_1=%@,x_count_2=%@,xtotal=%@ where ID=%@;",MLCID,self.MID,MCOFID,s1,s2,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r20,total1,total2,endtotal,X_Total1,X_Total2,X_Total,self.COFID];
    }
   if (![BurnSoftDatabase runQuery:SQLquery DatabasePath:dbPathString MessageHandler:&errorMessage])
   {
       [FormFunctions checkForError:errorMessage MyTitle:@"Error Creating new Course of Fire" ViewController:self];
   } else {
       UINavigationController *navController = self.navigationController;
       [navController popViewControllerAnimated:NO];
       //[navController popViewControllerAnimated:YES];
   }
    
}

// Number of components.
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

// Total rows in our component.
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_CourseOfFireDataSource count];
}

// Display each row's data.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [_CourseOfFireDataSource objectAtIndex: row];
}

// Do something with the selected row.
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.txtCourseOfFire.text =[_CourseOfFireDataSource objectAtIndex: row];
    //NSLog(@"You selected this: %@", [_CourseOfFireDataSource objectAtIndex: row]);
}
@end
