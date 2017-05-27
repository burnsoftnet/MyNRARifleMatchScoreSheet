//
//  ManageCOFTableViewController.m
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/27/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import "ManageCOFTableViewController.h"

@interface ManageCOFTableViewController ()

@end

@implementation ManageCOFTableViewController
{
    NSString *dbPathString;
    NSMutableArray *myMatchCOF;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupGlobalVars];
    [[self myTableView]setDelegate:self];
    [[self myTableView]setDataSource:self];
    [self loadData];
    
    //Create an Add Button in Nav Bat
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(AddCOF)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Initialize Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    // Configure View Controller
    [self setRefreshControl:refreshControl];
}

#pragma mark Refresh Table Data
// when you swipe down on the table, it will reload the data
- (IBAction)refresh:(UIRefreshControl *)sender {
    [self.myTableView reloadData];
    [self loadData];
    [sender endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [FormFunctions doBuggermeMessage:dbPathString FromSubFunction:@"ManageCOFTableViewController.setupGlobalVars.DatabasePath"];
    myMatchCOF = [NSMutableArray new];
    
    myPath = nil;
}

#pragma mark Load Data from Database
-(void) loadData
{
    [myMatchCOF removeAllObjects];
    
    ManageCOF *objMatch = [ManageCOF new];
    NSString *errorMsg = [NSString new];
    
    myMatchCOF = [objMatch getAllCourseOfFireByDatabasePath:dbPathString ErrorMessage:&errorMsg];
    [FormFunctions checkForError:errorMsg MyTitle:@"LoadData:" ViewController:self];
    
    [[self myTableView] reloadData];
}

#pragma mark Add New Match
//add the details of a new match
-(void) AddCOF
{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Course of Fire"
                                                                              message: @"Add Course of Fire"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
    }];
    /*
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"password";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.secureTextEntry = YES;
    }];
     */
    [alertController addAction:[UIAlertAction actionWithTitle:@"ADD" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        //UITextField * passwordfiled = textfields[1];
        NSString *errorMsg;
        if ([ManageCOF addCOFName:namefield.text DatabasePath:dbPathString ErrorMessage:&errorMsg])
        {
            [self reloadData];
        } else {
            [FormFunctions checkForError:errorMsg MyTitle:@"Error Adding" ViewController:self];
        }
        
        //NSLog(@"%@",namefield.text);
        
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [myMatchCOF count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    ManageCOF *displayMatches = [myMatchCOF objectAtIndex:indexPath.row];
    
    cell.tag = displayMatches.COFID;
    cell.textLabel.text = displayMatches.cof_name;
    
    return cell;
}

#pragma mark Table set Edit Mode
// Set if you can edit the table by swiping left to view options.
-(BOOL)tableView:(UITableView *) tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark Table Edit actions
//actions to take when a row has been selected for editing.
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
    
        NSString *errorMsg;
        ManageCOF *displayMatches = [myMatchCOF objectAtIndex:indexPath.row];
        NSString *cofID = [NSString stringWithFormat:@"%d",displayMatches.COFID];
        ManageCOF *myObj = [ManageCOF new];
        NSString *cofName = [myObj getCourseOfFirebyID:cofID DatabasePath:dbPathString ErrorMessage:&errorMsg];
        NSString *sql = [NSString stringWithFormat:@"select * from match_list_cof_details where MCOFID=%@",cofID];
        if (![BurnSoftDatabase dataExistsbyQuery:sql DatabasePath:dbPathString MessageHandler:&errorMsg])
        {
            if ([ManageCOF DeleteCOFByID:cofID DatabasePath:dbPathString ErrorMessage:&errorMsg])
            {
                [self reloadData];
            } else {
                [FormFunctions checkForError:errorMsg MyTitle:@"Error Deleting COF" ViewController:self];
            }
        } else {
            [FormFunctions sendMessage:[NSString stringWithFormat:@"Can't Delete %@, Course of Fire is in Use!",cofName] MyTitle:@"Can't Delete!" ViewController:self];
        }
        
    }];
    deleteAction.backgroundColor = [UIColor redColor];
    return  @[deleteAction];
}

#pragma mark Table Row Selected
//actions to take when a row has been selected.
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellTag = [NSString stringWithFormat:@"%ld",(long)cell.tag];
    NSString *errorMsg;
    NSString *cofID = cellTag;
    ManageCOF *myObj = [ManageCOF new];
    NSString *cofName = [myObj getCourseOfFirebyID:cofID DatabasePath:dbPathString ErrorMessage:&errorMsg];
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle: @"Course of Fire"
                                                                              message: @"Edit Course of Fire"
                                                                       preferredStyle:UIAlertControllerStyleAlert];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"name";
        textField.textColor = [UIColor blueColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.text = cofName;
    }];
     
    [alertController addAction:[UIAlertAction actionWithTitle:@"Update" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSArray * textfields = alertController.textFields;
        UITextField * namefield = textfields[0];
        NSString *errorMsg;
        if ([ManageCOF  updateCOFName:namefield.text CourseOfFireID:cofID DatabasePath:dbPathString ErrorMessage:&errorMsg])
        {
            [self reloadData];
        } else {
            [FormFunctions checkForError:errorMsg MyTitle:@"Error Editing" ViewController:self];
        }
    }]
     ];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){}]];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


@end
