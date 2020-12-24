//
//  iOSViewApp.m
//  iOSUITests
//
//  Created by burnsoft on 12/24/20.
//  Copyright © 2020 burnsoft. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface iOSViewApp : XCTestCase

@end

@implementation iOSViewApp

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    [[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

-(void) testViewCourseOfFire
{
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    XCUIElementQuery *tablesQuery = app.tables;
    [tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"Monthly F-Class Match on 2016-10-15"]/*[[".cells.staticTexts[@\"Monthly F-Class Match on 2016-10-15\"]",".staticTexts[@\"Monthly F-Class Match on 2016-10-15\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [tablesQuery/*@START_MENU_TOKEN@*/.staticTexts[@"300 Yards Rapid Fire (Standing to Prone)"]/*[[".cells.staticTexts[@\"300 Yards Rapid Fire (Standing to Prone)\"]",".staticTexts[@\"300 Yards Rapid Fire (Standing to Prone)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    
    XCUIElement *courseOfFireButton = app.navigationBars[@"Details"].buttons[@"Course of Fire"];
    [courseOfFireButton tap];
    [[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"String 1: 81 String 2: 85 Total: 166.0"].staticTexts[@"500 Yards Slow Fire ( prone )"] tap];
    [courseOfFireButton tap];
    [[tablesQuery.cells containingType:XCUIElementTypeStaticText identifier:@"String 1: 59 String 2: 74 Total: 133.0"].staticTexts[@"500 Yards Slow Fire ( prone )"] tap];
    [courseOfFireButton tap];
    [app.tabBars[@"Tab Bar"].buttons[@"Match Lists"] tap];
    
    
}

-(void) testSettings
{
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    [app.tabBars[@"Tab Bar"].buttons[@"Settings"] tap];
    
    XCUIApplication *app2 = app;
    [app2/*@START_MENU_TOKEN@*/.staticTexts[@"  Use iTunes File Sharing for Backup & Restore  "]/*[[".buttons[@\"  Use iTunes File Sharing for Backup & Restore  \"].staticTexts[@\"  Use iTunes File Sharing for Backup & Restore  \"]",".staticTexts[@\"  Use iTunes File Sharing for Backup & Restore  \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [app.navigationBars[@"Settings"].buttons[@"Settings"] tap];
    [app2/*@START_MENU_TOKEN@*/.staticTexts[@"  Add, Edit or Delete Divisions  "]/*[[".buttons[@\"  Add, Edit or Delete Divisions  \"].staticTexts[@\"  Add, Edit or Delete Divisions  \"]",".staticTexts[@\"  Add, Edit or Delete Divisions  \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [[app.tables.cells containingType:XCUIElementTypeStaticText identifier:@"F-Open"].element tap];
    [app.alerts[@"Division"].scrollViews.otherElements.buttons[@"Cancel"] tap];
    [app.navigationBars[@"Manage Divisions"].buttons[@"Settings"] tap];
    [app2/*@START_MENU_TOKEN@*/.staticTexts[@"  Add, Edit or Delete Course of Fire  "]/*[[".buttons[@\"  Add, Edit or Delete Course of Fire  \"].staticTexts[@\"  Add, Edit or Delete Course of Fire  \"]",".staticTexts[@\"  Add, Edit or Delete Course of Fire  \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [app2.tables/*@START_MENU_TOKEN@*/.staticTexts[@"100 Yard Rapid Fire (standing to sitting)"]/*[[".cells.staticTexts[@\"100 Yard Rapid Fire (standing to sitting)\"]",".staticTexts[@\"100 Yard Rapid Fire (standing to sitting)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    /*@START_MENU_TOKEN@*/[app.alerts[@"Course of Fire"].scrollViews.otherElements.buttons[@"Cancel"] pressForDuration:0.5];/*[["app.alerts[@\"Course of Fire\"].scrollViews.otherElements.buttons[@\"Cancel\"]","["," tap];"," pressForDuration:0.5];"],[[[-1,0,1]],[[1,3],[1,2]]],[0,0]]@END_MENU_TOKEN@*/
    [app.navigationBars[@"Manage Course of Fire"].buttons[@"Settings"] tap];
    
    XCUIElement *staticText = app.staticTexts[@"1.4.2"];
    /*@START_MENU_TOKEN@*/[staticText pressForDuration:0.8];/*[["staticText","["," tap];"," pressForDuration:0.8];"],[[[-1,0,1]],[[1,3],[1,2]]],[0,0]]@END_MENU_TOKEN@*/
    [staticText tap];
    
    
}

@end
