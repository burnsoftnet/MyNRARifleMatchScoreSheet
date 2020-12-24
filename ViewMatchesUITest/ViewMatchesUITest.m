//
//  ViewMatchesUITest.m
//  ViewMatchesUITest
//
//  Created by burnsoft on 12/24/20.
//  Copyright © 2020 burnsoft. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface ViewMatchesUITest : XCTestCase

@end

@implementation ViewMatchesUITest

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testRunApp {
    // UI tests must launch the application that they test.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
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

- (void)testLaunchPerformance {
    if (@available(macOS 10.15, iOS 13.0, tvOS 13.0, *)) {
        // This measures how long it takes to launch your application.
        [self measureWithMetrics:@[[[XCTApplicationLaunchMetric alloc] init]] block:^{
            [[[XCUIApplication alloc] init] launch];
        }];
    }
}

@end
