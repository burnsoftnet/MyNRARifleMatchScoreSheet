//
//  LIST_Match_COF.m
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/7/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import "LIST_Match_COF.h"

@interface LIST_Match_COF ()
{
    NSString *dbPathString;
    NSMutableArray *myMatchListings;
    NSString *SelectedCellID;
}

@end

@implementation LIST_Match_COF

#pragma mark View Did Load
/*!
    @brief Load settings and data when the form loads, Create an Add Button in Nav Bat, Initialize Refresh Control
        Configure Refresh Control, Configure View Controller
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupGlobalVars];
    [[self myTableView]setDelegate:self];
    [[self myTableView]setDataSource:self];
    [self loadData];
    
    //Create an Add Button in Nav Bat
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(AddMatch)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // Initialize Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    // Configure View Controller
    [self setRefreshControl:refreshControl];
}

#pragma mark View will reappear
/*!
 @brief Sub when the form reloads
 */
- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

#pragma mark Did Recieve Memory Warning
/*!
 @brief Dispose of any resources that can be recreated.
 */
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark Refresh Table Data
/*!
 @brief when you swipe down on the table, it will reload the data
 */
- (IBAction)refresh:(UIRefreshControl *)sender {
    [self.myTableView reloadData];
    [self loadData];
    [sender endRefreshing];
}
#pragma mark Add New Match
/*!
 @brief add the details of a new match
 */
-(void) AddMatch
{
    [self performSegueWithIdentifier:@"sequeAddNewMatch" sender:self];
}

#pragma mark Reload Data
/*!
 @brief Reload the data as is the for first appeared
 */
-(void) reloadData {
    [self setupGlobalVars];
    [self loadData];
}

#pragma mark Setup Global Variables
/*!
 @brief Setup the global variablies like the database path
 */
-(void) setupGlobalVars
{
    BurnSoftDatabase *myPath = [BurnSoftDatabase new];
    dbPathString = [myPath getDatabasePath:@MYDBNAME];
    
    [FormFunctions doBuggermeMessage:dbPathString FromSubFunction:@"LIST_Matches.setupGlobalVars.DatabasePath"];
    myMatchListings = [NSMutableArray new];
    
    myPath = nil;
}

#pragma mark Load Data from Database
/*!
 @brief Load Data from the database into a NSMutableArry to be used in the table
 */
-(void) loadData
{
    [myMatchListings removeAllObjects];
    MatchListCOF *objMatch = [MatchListCOF new];
    NSString *errorMsg = [NSString new];
    
    myMatchListings = [objMatch getAllMatchListCOFByMatchID:_MID DatabasePath:dbPathString ErrorMessage:&errorMsg];
    
    [FormFunctions checkForError:errorMsg MyTitle:@"LoadData:" ViewController:self];
    [[self myTableView] reloadData];
}

 #pragma mark - Navigation
/*!
 @brief In a storyboard-based application, you will often want to do a little preparation before navigation
 */
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     
     if ([segue.identifier isEqualToString:@"segueCOFDetails"]) {
         CourseOfFire_ViewController *destViewController = (CourseOfFire_ViewController *)segue.destinationViewController;
         destViewController.isNew = NO;
         destViewController.MID = self.MID;
         destViewController.COFID = SelectedCellID;
     } else if ([segue.identifier isEqualToString:@"sequeAddNewMatch"]){
         CourseOfFire_ViewController *destViewController = (CourseOfFire_ViewController *)segue.destinationViewController;
         destViewController.isNew = YES;
         destViewController.MID = self.MID;
         destViewController.COFID = 0;
     }
 }

#pragma mark Table set Edit Mode
/*!
 @brief Set if you can edit the table by swiping left to view options.
 */
-(BOOL)tableView:(UITableView *) tableView canEditRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return YES;
}

#pragma mark Table Set Sections
/*!
 @brief set the sections in the table
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

#pragma mark Table Set Number of Rows
/*!
 @brief set the number of rows int he table
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([myMatchListings count] > 0)
    {
        self.tableView.backgroundView = nil;
        return [myMatchListings count];
    } else {
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please Add a Course of Fire.";
        messageLabel.textColor = [UIColor blackColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return 0;
}

#pragma mark Table Set Cell Data
/*!
 @brief set the cell data by use of an array
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    MatchListCOF *displayMatches = [myMatchListings objectAtIndex:indexPath.row];
    cell.tag = displayMatches.COFID;
    cell.textLabel.text = displayMatches.cof_name;
    cell.detailTextLabel.text = displayMatches.scoredetails;
    
    return cell;
}

#pragma mark Table Row Selected
/*!
 @brief actions to take when a row has been selected.
 */
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellTag = [NSString stringWithFormat:@"%ld",(long)cell.tag];
    SelectedCellID = cellTag;
    [self performSegueWithIdentifier:@"segueCOFDetails" sender:self];
}

 #pragma mark Table Edit actions
/*!
 @brief actions to take when a row has been selected for editing.
 *//*
 -(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
 {
     UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
         NSString *errorMsg;
         MatchListCOF *myObj = [MatchListCOF new];
         MatchListCOF *displayMatches = [self->myMatchListings objectAtIndex:indexPath.row];
         NSString *matchListcof = [myObj getCourseOfFireIDByName:displayMatches.cof_name DatabasePath:self->dbPathString ErrorMessage:&errorMsg];
         NSString *cofid = [NSString stringWithFormat:@"%d",displayMatches.COFID];
         
         if ([myObj deleteCMatchourseOfFire:cofid MatchID:self.MID MatchListCOF:matchListcof DatabasePath:self->dbPathString ErrorMessage:&errorMsg])
         {
             [self reloadData];
         } else {
             [FormFunctions checkForError:errorMsg MyTitle:@"Error Deleting COF" ViewController:self];
         }
     }];
     deleteAction.backgroundColor = [UIColor redColor];
     return  @[deleteAction];
 }*/

#pragma mark New Table Handlers on Swipe
/*!
 @discussion This is the new section that is used in iOS 13 or greater to get rid of the warnings.
 @brief  trailing swipe action configuration for table row
 @return return UISwipeActionsConfiguration
 */
-(id)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self getRowActions:tableView indexPath:indexPath];
}

#pragma mark Get Ro Actions
/*!
 @brief  Contains the action to perform when you swipe on the table
 @param indexPath of table
 @return return UISwipeActionConfiguration
 @remark This is the new section that is used in iOS 13 or greater to get rid of the warnings.
 */
-(id)getRowActions:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSString *errorMsg;
        MatchListCOF *myObj = [MatchListCOF new];
        MatchListCOF *displayMatches = [self->myMatchListings objectAtIndex:indexPath.row];
        NSString *matchListcof = [myObj getCourseOfFireIDByName:displayMatches.cof_name DatabasePath:self->dbPathString ErrorMessage:&errorMsg];
        NSString *cofid = [NSString stringWithFormat:@"%d",displayMatches.COFID];
        
        if ([myObj deleteCMatchourseOfFire:cofid MatchID:self.MID MatchListCOF:matchListcof DatabasePath:self->dbPathString ErrorMessage:&errorMsg])
        {
            [self reloadData];
        } else {
            [FormFunctions checkForError:errorMsg MyTitle:@"Error Deleting COF" ViewController:self];
        }
    }];
    
    deleteAction.backgroundColor = [FormFunctions setDeleteColor];
    
    UISwipeActionsConfiguration *swipeActions = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
       swipeActions.performsFirstActionWithFullSwipe = NO;
       return swipeActions;
}



@end
