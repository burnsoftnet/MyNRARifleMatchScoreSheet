//
//  LIST_Matches.m
//  My NRA Rifle Match Score Sheet
//
//  Created by burnsoft on 5/5/17.
//  Copyright © 2017 burnsoft. All rights reserved.
//

#import "LIST_Matches.h"

@interface LIST_Matches ()
{
    NSString *dbPathString;
    NSMutableArray *myMatchListings;
    NSArray *myMatchClasses;
    NSString *SelectedCellID;
    NSInteger LastSection;
    BOOL isRowHidden;
    NSInteger ArrayCount;
    
    NSMutableDictionary *DictionaryMatchClass;
}
@end

@implementation LIST_Matches

#pragma mark View Did Load
/*!
    @brief load settings and data when the form loads
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupGlobalVars];
    [[self myTableView]setDelegate:self];
    [[self myTableView]setDataSource:self];
    [self loadData];
    
    //Create an Add Button in Nav Bat
    //UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(AddMatch)];
    //self.navigationItem.rightBarButtonItem = addButton;
    //[self AddNavButton];
    
    // Initialize Refresh Control
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    
    // Configure Refresh Control
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    
    // Configure View Controller
    [self setRefreshControl:refreshControl];
}
/*!
 @brief Add navigation button to the top to allow an add button
 */
-(void) AddNavButton
{
    if ([MYSettings IsLiteVersion])
    {
        NSInteger MatchCount = [myMatchListings count];
        
        if (MatchCount <= (LITE_LIMIT-1))
        {
            //Create an Add Button in Nav Bat
            UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(AddMatch)];
            self.navigationItem.rightBarButtonItem = addButton;
        } else {
            self.navigationItem.rightBarButtonItem = nil;
            [FormFunctions AlertonLimitForViewController:self];
        }
    } else {
        //Create an Add Button in Nav Bat
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(AddMatch)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
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
    [self AddNavButton];
}
#pragma mark Add New Match
/*!
 @brief dd the details of a new match
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
    [self AddNavButton];
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
 @brief Load the database from the database into a MSMutabeArray to be used in the table
 */
-(void) loadData
{
    ArrayCount = 0;
    DictionaryMatchClass = [NSMutableDictionary dictionary];
    [myMatchListings removeAllObjects];
    MatchLists *objMatch = [MatchLists new];
    NSString *errorMsg = [NSString new];
    
    myMatchListings = [objMatch getAllMatchListsByDatabasePath:dbPathString ErrorMessage:&errorMsg];
    [FormFunctions checkForError:errorMsg MyTitle:@"LoadData:" ViewController:self];
    
    myMatchClasses = [objMatch getDistinctMatchClassesByDatabasePath:dbPathString ErrorMessage:&errorMsg];
    [FormFunctions checkForError:errorMsg MyTitle:@"Error Load Data Match Class:" ViewController:self];

    [self setupDictionary];
    
    myMatchClasses = [[DictionaryMatchClass allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    
    [[self myTableView] reloadData];
}
/*!
 @brief Setup the Match Classes
 */
-(void)setupDictionary
{
    NSString *errorMsg;
    [DictionaryMatchClass removeAllObjects];
    for (int x = 0; x < [myMatchClasses count]; x++) {
        MatchLists *displayMatcheClasses = [myMatchClasses objectAtIndex:x];
        NSString *currentClassName = displayMatcheClasses.matchclass;
        [DictionaryMatchClass setObject:[MatchLists getAllMatchListsByMatchDivision:currentClassName DatabasePath:dbPathString ErrorMessage:&errorMsg] forKey:currentClassName];
    }

}

#pragma mark Prepare for Segue
/*!
 @brief Actions to take before switching to the next window
 */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"segueShowCourseOfFire"]) {
        LIST_Match_COF *destViewController = (LIST_Match_COF *)segue.destinationViewController;
        destViewController.MID = SelectedCellID;
    } else if ([segue.identifier isEqualToString:@"sequeAddNewMatch"]) {
        Add_MatchViewController *destViewController = (Add_MatchViewController *)segue.destinationViewController;
        destViewController.isNew = YES;
    } else if ([segue.identifier isEqualToString:@"segueEditMatch"]) {
        Add_MatchViewController *destViewController = (Add_MatchViewController *)segue.destinationViewController;
        destViewController.MID = SelectedCellID;
        destViewController.isNew = NO;
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
    if (USEGROUPING)
    {
        if ([myMatchClasses count] > 0)
        {
            return [myMatchClasses count];
        } else {
            // Display a message when the table is empty
            UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
            
            messageLabel.text = @"No data is currently available. Please Add a Match.";
            messageLabel.textColor = [UIColor blackColor];
            messageLabel.numberOfLines = 0;
            messageLabel.textAlignment = NSTextAlignmentCenter;
            messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
            [messageLabel sizeToFit];
            
            self.tableView.backgroundView = messageLabel;
            self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            
        }
        return 0;
    } else {
        return 1;
    }
}
/*!
 @brief Get the number of rows for the table section
 */
-(NSInteger)getRowsForSection:(NSInteger)section
{
    NSInteger iRow = 0;
    MatchLists *displayMatchesClasses = [myMatchClasses objectAtIndex:section];
    NSString *mClass = displayMatchesClasses.matchclass;

    for (int x = 0; x < [myMatchListings count]; x++) {
        MatchLists *mList = [myMatchListings objectAtIndex:x];
        NSString *matchlistclass = mList.matchclass;
        if ([matchlistclass isEqualToString:mClass])
        {
            iRow++;
        }
    }
    [FormFunctions doBuggermeMessage:[NSString stringWithFormat:@"%@ has %ld rows",displayMatchesClasses.matchclass,(long)iRow] FromSubFunction:@"list_matches.getRowsForSection"];
    return iRow;
}

#pragma mark Table Set Number of Rows
/*!
 @brief set the number of rows int he table
 */
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (USEGROUPING)
    {
        //return [self getRowsForSection:section];
        NSString *sectionTitle = [myMatchClasses objectAtIndex:section];
        NSArray *sectionDivision = [DictionaryMatchClass objectForKey:sectionTitle];
        return [sectionDivision count];
    } else {
        return [myMatchListings count];
    }
}
/*!
 @brief the title for the header in the section
 */
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (USEGROUPING)
    {
        return [myMatchClasses objectAtIndex:section];
    } else {
        return nil;
    }
}


#pragma mark Table Set Cell Data
/*!
 @brief set the cell data by use of an array
 */
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (USEGROUPING)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }

        NSString *sectionTitle = [myMatchClasses objectAtIndex:indexPath.section];
        NSArray *sectionMatches = [DictionaryMatchClass objectForKey:sectionTitle];
        //NSString *MatchName = [sectionMatches objectAtIndex:indexPath.row];
        MatchLists *displayMatches = [sectionMatches objectAtIndex:indexPath.row];
        
        cell.tag = displayMatches.MID;
        cell.textLabel.text = displayMatches.matchname;
        cell.detailTextLabel.text = displayMatches.matchdetails;
        
        return cell;
    } else {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        MatchLists *displayMatches = [myMatchListings objectAtIndex:indexPath.row];
        
        cell.tag = displayMatches.MID;
        cell.textLabel.text = displayMatches.matchname;
        cell.detailTextLabel.text = displayMatches.matchdetails;
        
        return cell;
    }
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
    [self performSegueWithIdentifier:@"segueShowCourseOfFire" sender:self];
}

#pragma mark Table Edit actions
/*!
 @brief actions to take when a row has been selected for editing.
 *//*
-(NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
   //FormFunctions *myFunctions = [FormFunctions new];
    UITableViewRowAction *editAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Edit" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        Add_MatchViewController *destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sbAddMatch"];
        NSString *sectionTitle = [self->myMatchClasses objectAtIndex:indexPath.section];
        NSArray *sectionMatches = [self->DictionaryMatchClass objectForKey:sectionTitle];
        MatchLists *displayMatches = [sectionMatches objectAtIndex:indexPath.row];
        //MatchLists *displayMatches = [myMatchListings objectAtIndex:indexPath.row];
        NSString *mid = [NSString stringWithFormat:@"%d",displayMatches.MID];
        
        destViewController.MID = mid;
        [self.navigationController pushViewController:destViewController animated:YES];
    }];
    
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Delete"  handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        //insert your deleteAction here
        
        NSString *errorMsg;
        NSString *sectionTitle = [self->myMatchClasses objectAtIndex:indexPath.section];
        NSArray *sectionMatches = [self->DictionaryMatchClass objectForKey:sectionTitle];
        MatchLists *displayMatches = [sectionMatches objectAtIndex:indexPath.row];
        //MatchLists *displayMatches = [myMatchListings objectAtIndex:indexPath.row];
        NSString *mid = [NSString stringWithFormat:@"%d",displayMatches.MID];
        if ([displayMatches deleteMatchListsByID:mid DatabasePath:self->dbPathString ErrorMessage:&errorMsg])
        {
            [self reloadData];
        } else {
            [FormFunctions checkForError:errorMsg MyTitle:@"Error Deleting Match" ViewController:self];
        }
        
    }];
    
    UITableViewRowAction *copyAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Copy" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        NSString *errorMsg;
        NSString *sectionTitle = [self->myMatchClasses objectAtIndex:indexPath.section];
        NSArray *sectionMatches = [self->DictionaryMatchClass objectForKey:sectionTitle];
        MatchLists *displayMatches = [sectionMatches objectAtIndex:indexPath.row];

        NSString *mid = [NSString stringWithFormat:@"%d",displayMatches.MID];

        [displayMatches copyMatchByMatchID:mid DatabasePath:self->dbPathString ErrorMessage:&errorMsg];
        [self reloadData];

    }];

    editAction.backgroundColor = [UIColor blueColor];
    deleteAction.backgroundColor = [UIColor redColor];
    editAction.backgroundColor = [UIColor greenColor];
    
    return  @[editAction,deleteAction,copyAction];
}
    */

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
-(id)getRowActions:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    
    UIContextualAction *deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSString *errorMsg;
        NSString *sectionTitle = [self->myMatchClasses objectAtIndex:indexPath.section];
        NSArray *sectionMatches = [self->DictionaryMatchClass objectForKey:sectionTitle];
        MatchLists *displayMatches = [sectionMatches objectAtIndex:indexPath.row];
        //MatchLists *displayMatches = [myMatchListings objectAtIndex:indexPath.row];
        NSString *mid = [NSString stringWithFormat:@"%d",displayMatches.MID];
        if ([displayMatches deleteMatchListsByID:mid DatabasePath:self->dbPathString ErrorMessage:&errorMsg])
        {
            [self reloadData];
        } else {
            [FormFunctions checkForError:errorMsg MyTitle:@"Error Deleting Match" ViewController:self];
        }
    }];
    
    UIContextualAction *editAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Edit" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        Add_MatchViewController *destViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"sbAddMatch"];
        NSString *sectionTitle = [self->myMatchClasses objectAtIndex:indexPath.section];
        NSArray *sectionMatches = [self->DictionaryMatchClass objectForKey:sectionTitle];
        MatchLists *displayMatches = [sectionMatches objectAtIndex:indexPath.row];

        NSString *mid = [NSString stringWithFormat:@"%d",displayMatches.MID];
        
        destViewController.MID = mid;
        [self.navigationController pushViewController:destViewController animated:YES];
    }];
    
    UIContextualAction *copyAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"Copy" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL)) {
        NSString *errorMsg;
        NSString *sectionTitle = [self->myMatchClasses objectAtIndex:indexPath.section];
        NSArray *sectionMatches = [self->DictionaryMatchClass objectForKey:sectionTitle];
        MatchLists *displayMatches = [sectionMatches objectAtIndex:indexPath.row];

        NSString *mid = [NSString stringWithFormat:@"%d",displayMatches.MID];

        [displayMatches copyMatchByMatchID:mid DatabasePath:self->dbPathString ErrorMessage:&errorMsg];
        [self reloadData];
    }];

    deleteAction.backgroundColor = [FormFunctions setDeleteColor];
    editAction.backgroundColor = [FormFunctions setEditColor];
    copyAction.backgroundColor = [FormFunctions setEditColor];
    
    UISwipeActionsConfiguration *swipeActions = [UISwipeActionsConfiguration configurationWithActions:@[editAction,deleteAction,copyAction]];
       swipeActions.performsFirstActionWithFullSwipe = NO;
       return swipeActions;
}

@end
