//
//  Add_MatchViewController.m
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/7/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import "Add_MatchViewController.h"

@interface Add_MatchViewController ()
{
    sqlite3 *MatchDB;
    NSString *dbPathString;
    NSString *MatchClass;
    NSMutableArray *ClassPickerData;
}
@end

@implementation Add_MatchViewController

@synthesize pvClass;

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
    [self initDatePicker];
    [self initClassPicker];
    
}

-(void) initClassPicker
{
    // Calculate the screen's width.
    float screenWidth = [UIScreen mainScreen].bounds.size.width;
    float pickerWidth = screenWidth * 3 / 4;
    
    // Calculate the starting x coordinate.
    float xPoint = screenWidth / 2 - pickerWidth / 2;
    
    // Init the picker view.
    pvClass = [[UIPickerView alloc] init];
    [pvClass setDataSource:self];
    [pvClass setDelegate:self];
    
    // Set the picker's frame. We set the y coordinate to 50px.
    [pvClass setFrame: CGRectMake(xPoint, 50.0f, pickerWidth, 200.0f)];
    
    // Before we add the picker view to our view, let's do a couple more
    // things. First, let the selection indicator (that line inside the
    // picker view that highlights your selection) to be shown.
    pvClass.showsSelectionIndicator = YES;
    
    // Allow us to pre-select the third option in the pickerView.
    [pvClass selectRow:2 inComponent:0 animated:YES];
    
    // OK, we are ready. Add the picker in our view.
    //[self.view addSubview: pvCourseOfFire];
    
    [self.txtClass setInputView:pvClass];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(SelectMatchClass)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.txtClass setInputAccessoryView:toolBar];

}

-(void) SelectMatchClass
{
    
    if ([self.txtClass.text isEqualToString:@""])
    {
         self.txtClass.text = _pickerDataSource[0];
    }
     [self.txtClass resignFirstResponder];
}

-(void) initDatePicker
{
    datePicker = [[UIDatePicker alloc]init];
    datePicker.datePickerMode=UIDatePickerModeDate;
    [self.txtDate setInputView:datePicker];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    [toolBar setTintColor:[UIColor grayColor]];
    UIBarButtonItem *doneBtn=[[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(ShowSelectedDate)];
    UIBarButtonItem *space=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [toolBar setItems:[NSArray arrayWithObjects:space,doneBtn, nil]];
    [self.txtDate setInputAccessoryView:toolBar];
}

-(void)ShowSelectedDate
{   NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    self.txtDate.text=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datePicker.date]];
    [self.txtDate resignFirstResponder];
}

#pragma mark View will reappear
//Sub when the form reloads
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
    [[self pvClassPicker] setDelegate:self];
    [[self pvClassPicker] setDataSource:self];
    //self.txtClass.inputView = _pvClassPicker;
    //if (_pvClassPicker) _pvClassPicker.hidden = !_pvClassPicker.hidden;
    
}

#pragma mark Make Keyboard Dissapear
//Dissmiss the keyboard when the view is selected
-(void)tapReceived:(UITapGestureRecognizer *)tapGestureRecognizer
{
    //[self.txtClass resignFirstResponder];
    [self.txtDate resignFirstResponder];
    [self.txtRelay resignFirstResponder];
    [self.txtTarget resignFirstResponder];
    [self.txtLocation resignFirstResponder];
    [self.txtMatchName resignFirstResponder];
    [self.pvClassPicker resignFirstResponder];
    
}

#pragma mark Did Recieve Memory Warning
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Refresh Table Data
// when you swipe down on the table, it will reload the data
- (IBAction)refresh:(UIRefreshControl *)sender {
    //[self.myTableView reloadData];
    [self loadData];
    [sender endRefreshing];
}

#pragma mark Reload Data
//  Reload the data as is the for first appeared
-(void) reloadData {
    [self setupGlobalVars];
    [self loadData];
}

#pragma mark Setup Global Variables
// Setup the global variablies like the database path
-(void) setupGlobalVars
{
    BurnSoftDatabase *myPath = [BurnSoftDatabase new];
    dbPathString = [myPath getDatabasePath:@MYDBNAME];
    
    [FormFunctions doBuggermeMessage:dbPathString FromSubFunction:@"Add_MatchViewController.setupGlobalVars.DatabasePath"];
    
    [FormFunctions setBorderButton:self.btnAddMatch];
    
    myPath = nil;
}

#pragma mark Load Data from Database
-(void) loadData
{
    NSString *errorMsg = [NSString new];
    
    MatchLists *objML = [MatchLists new];
    _pickerDataSource = [objML getAllMatchClassTypesByDatabasePath:dbPathString ErrorMessage:&errorMsg];
    
    //[self.pvClassPicker selectRow:2 inComponent:0 animated:YES];
    if (!_isNew)
    {
        sqlite3_stmt * statement;
        if (sqlite3_open([dbPathString UTF8String],&MatchDB) == SQLITE_OK) {
            NSString *querySQL = [NSString stringWithFormat:@"SELECT dt,name,location,target,relay,MCID from match_list where ID=%@",self.MID];
            int ret = sqlite3_prepare_v2(MatchDB, [querySQL UTF8String], -1, &statement, NULL);
            int sqlColumn = 0;
            
            if (ret == SQLITE_OK) {
                while (sqlite3_step(statement) == SQLITE_ROW)
                {
                    sqlColumn = 0;
                    self.txtDate.text = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, sqlColumn)];
                    
                    sqlColumn = 1;
                    self.txtMatchName.text = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, sqlColumn)];
                    
                    sqlColumn = 2;
                    self.txtLocation.text = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, sqlColumn)];
                    
                    sqlColumn = 3;
                    self.txtTarget.text = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, sqlColumn)];
                    
                    sqlColumn = 4;
                    self.txtRelay.text = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, sqlColumn)];
                    
                    sqlColumn = 5;
                    NSString *matchDivisionID = [[NSString alloc] initWithUTF8String:(const char*)sqlite3_column_text(statement, sqlColumn)];
                    self.txtClass.text = [objML getMatchClassNameByID:matchDivisionID DatabasePath:dbPathString ErrorMessage:&errorMsg];
                }
                sqlite3_finalize(statement);
            }
        }
    }
}

#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component

{
    return _pickerDataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return _pickerDataSource[row];
}

#pragma mark PickerView Delegate

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.txtClass.text = _pickerDataSource[row];
    
    //_txtClass.text = resultString;
    //if (_pvClassPicker) _pvClassPicker.hidden = !_pvClassPicker.hidden;
}

- (void)onDatePickerValueChanged:(UIDatePicker *)datePicker
{
    self.txtDate.text = [NSString stringWithFormat:@"%@", _dpMatchOfDate.date];
}

- (IBAction)btnAddMatch:(id)sender
{
    MatchLists *myObj = [MatchLists new];
    NSString *matchName = self.txtMatchName.text;
    NSString *location = self.txtLocation.text;
    NSString *relay = self.txtRelay.text;
    NSString *target = self.txtTarget.text;
    NSString *errorMsg = [NSString new];
    NSString *dateofMatch = self.txtDate.text;
    NSString *class = self.txtClass.text;
    
    NSString *MCID = [myObj getMatchClassIDByName:class DatabasePath:dbPathString ErrorMessage:&errorMsg];;
    if (_isNew)
    {
        if ([myObj InsertNewMatchbyName:matchName MatchClassID:MCID Location:location Relay:relay Target:target DateOfMatch:dateofMatch DatabasePath:dbPathString ErrorMessage:&errorMsg]) {
            UINavigationController *navController = self.navigationController;
            [navController popViewControllerAnimated:NO];
            [navController popViewControllerAnimated:YES];
        } else {
            [FormFunctions checkForError:errorMsg MyTitle:@"Adding Match Error" ViewController:self];
        }
   
    } else {
        if ([myObj updateMatchbyID:self.MID MatchName:matchName MatchClassID:MCID Location:location Relay:relay Target:target DateOfMatch:dateofMatch DatabasePath:dbPathString ErrorMessage:&errorMsg]) {
            UINavigationController *navController = self.navigationController;
            [navController popViewControllerAnimated:NO];
            [navController popViewControllerAnimated:YES];
        } else {
            [FormFunctions checkForError:errorMsg MyTitle:@"Adding Match Error" ViewController:self];
        }

    }
    myObj = nil;
}
@end
