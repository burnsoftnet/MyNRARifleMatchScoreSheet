//
//  iOSManageCourseOfFire.m
//  iOSUITests
//
//  Created by burnsoft on 12/24/20.
//  Copyright © 2020 burnsoft. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface iOSManageCourseOfFire : XCTestCase

@end

@implementation iOSManageCourseOfFire
{
    NSString *MatchName;
    NSString *MatchOnDate;
}
- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    
    MatchName = @"Unit Test Match";
    MatchOnDate = @"2020-12-24";
    
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    //[[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAdd {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    [app.navigationBars[@"Match Lists"].buttons[@"Add"] tap];
    [app.textFields[@"Monthly / CMP / etc."] tap];
    
    NSUInteger len = [MatchName length];
    unichar buffer[len+1];

    [MatchName getCharacters:buffer range:NSMakeRange(0, len)];

    NSLog(@"getCharacters:range: with unichar buffer");
    for(int i = 0; i < len; i++) {
        NSString *newValue = [NSString stringWithFormat:@"%C", buffer[i]];

        if ([newValue length] > 0)
        {
            if ([newValue isEqual:@" "])
            {
                newValue = @"space";
            }
            [app.keys[newValue] tap];
        }
    }
    
    [app.textFields[@"Service Rifle/ F-Class etc."] tap];
    [app/*@START_MENU_TOKEN@*/.pickerWheels[@"Any"]/*[[".pickers.pickerWheels[@\"Any\"]",".pickerWheels[@\"Any\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ swipeUp];
    
    XCUIElement *doneButton = app.toolbars[@"Toolbar"].buttons[@"Done"];
    [doneButton tap];
    [app.textFields[@"Date of Match"] tap];
    [doneButton tap];
    [app.textFields[@"Some Place, Some State"] tap];
    
    XCUIElement *kKey = app/*@START_MENU_TOKEN@*/.keys[@"K"]/*[[".keyboards.keys[@\"K\"]",".keys[@\"K\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [kKey tap];
    
    XCUIElement *yKey = app/*@START_MENU_TOKEN@*/.keys[@"y"]/*[[".keyboards.keys[@\"y\"]",".keys[@\"y\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [yKey tap];
    
    XCUIElement *element = [[[[[[[[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element;
    [[[[element childrenMatchingType:XCUIElementTypeTextField] matchingIdentifier:@"1, 2, 3, etc"] elementBoundByIndex:0] tap];
    
    XCUIElement *key = app/*@START_MENU_TOKEN@*/.keys[@"1"]/*[[".keyboards.keys[@\"1\"]",".keys[@\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [key tap];
    [key tap];
    
    [[[[element childrenMatchingType:XCUIElementTypeTextField] matchingIdentifier:@"1, 2, 3, etc"] elementBoundByIndex:1] tap];
    [key tap];
    [key tap];
    
    [app/*@START_MENU_TOKEN@*/.staticTexts[@"  Apply  "]/*[[".buttons[@\"  Apply  \"].staticTexts[@\"  Apply  \"]",".staticTexts[@\"  Apply  \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    
    
}

-(void)testAddCOF {
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    [app.tables/*@START_MENU_TOKEN@*/.staticTexts[@"Unit Test Match on 2020-12-24"]/*[[".cells.staticTexts[@\"Unit Test Match on 2020-12-24\"]",".staticTexts[@\"Unit Test Match on 2020-12-24\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [app.navigationBars[@"Course of Fire"].buttons[@"Add"] tap];
    
    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
    XCUIElementQuery *courseOfFireElementsQuery = [scrollViewsQuery.otherElements containingType:XCUIElementTypeStaticText identifier:@"Course of Fire:"];
    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:0] tap];
    
    [app/*@START_MENU_TOKEN@*/.pickerWheels[@"100 Yards Rapid Fire (Standing to Prone)"]/*[[".pickers.pickerWheels[@\"100 Yards Rapid Fire (Standing to Prone)\"]",".pickerWheels[@\"100 Yards Rapid Fire (Standing to Prone)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ swipeUp];
    [app.toolbars[@"Toolbar"].buttons[@"Done"] tap];
    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:1] tap];
    
    XCUIElement *key9 = app/*@START_MENU_TOKEN@*/.keys[@"9"]/*[[".keyboards.keys[@\"9\"]",".keys[@\"9\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:2] tap];
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:3] tap];
    
    XCUIElement *key1 = app/*@START_MENU_TOKEN@*/.keys[@"1"]/*[[".keyboards.keys[@\"1\"]",".keys[@\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [key1 tap];

    
    XCUIElement *key0 = app/*@START_MENU_TOKEN@*/.keys[@"0"]/*[[".keyboards.keys[@\"0\"]",".keys[@\"0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [key0 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:5] tap];
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:4] tap];
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:6] tap];
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:8] tap];
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:7] tap];
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:9] tap];
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:10] tap];
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:11] tap];
    [key1 tap];
    [key0 tap];
    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:12] tap];
    [key1 tap];
    [key0 tap];
    
    XCUIElement *courseOfFireElement = [scrollViewsQuery.otherElements containingType:XCUIElementTypeStaticText identifier:@"Course of Fire:"].element;
    [courseOfFireElement swipeUp];
    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:13] tap];
    [key1 tap];
    [key0 tap];
    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:14] tap];
    [key1 tap];
    [key0 tap];
    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:15] tap];
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:16] tap];
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:17] tap];
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:18] tap];
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:19] tap];
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:20] tap];
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:21] tap];
    [key9 tap];

    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:22] tap];
    [key9 tap];

    [courseOfFireElement swipeUp];
    
    XCUIElementQuery *elementsQuery = scrollViewsQuery.otherElements;
    /*@START_MENU_TOKEN@*/[elementsQuery.staticTexts[@"93"] pressForDuration:1.1];/*[["elementsQuery.staticTexts[@\"93\"]","["," tap];"," pressForDuration:1.1];"],[[[-1,0,1]],[[1,3],[1,2]]],[0,0]]@END_MENU_TOKEN@*/
    /*@START_MENU_TOKEN@*/[elementsQuery.staticTexts[@"92"] pressForDuration:0.6];/*[["elementsQuery.staticTexts[@\"92\"]","["," tap];"," pressForDuration:0.6];"],[[[-1,0,1]],[[1,3],[1,2]]],[0,0]]@END_MENU_TOKEN@*/
    /*@START_MENU_TOKEN@*/[elementsQuery.staticTexts[@"185"] pressForDuration:0.6];/*[["elementsQuery.staticTexts[@\"185\"]","["," tap];"," pressForDuration:0.6];"],[[[-1,0,1]],[[1,3],[1,2]]],[0,0]]@END_MENU_TOKEN@*/
    [app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.staticTexts[@"  Apply  "]/*[[".buttons[@\"  Apply  \"].staticTexts[@\"  Apply  \"]",".staticTexts[@\"  Apply  \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    
}

-(void)testAddCOFMathTest {
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];

    [app.tables/*@START_MENU_TOKEN@*/.staticTexts[@"Unit Test Match on 2020-12-24"]/*[[".cells.staticTexts[@\"Unit Test Match on 2020-12-24\"]",".staticTexts[@\"Unit Test Match on 2020-12-24\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [app.navigationBars[@"Course of Fire"].buttons[@"Add"] tap];
    
    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
    XCUIElementQuery *courseOfFireElementsQuery = [scrollViewsQuery.otherElements containingType:XCUIElementTypeStaticText identifier:@"Course of Fire:"];
    [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:0] tap];
    
    [app/*@START_MENU_TOKEN@*/.pickerWheels[@"100 Yards Rapid Fire (Standing to Prone)"]/*[[".pickers.pickerWheels[@\"100 Yards Rapid Fire (Standing to Prone)\"]",".pickerWheels[@\"100 Yards Rapid Fire (Standing to Prone)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ swipeUp];
    [app.toolbars[@"Toolbar"].buttons[@"Done"] tap];
    
    //XCUIElement *key9 = app.keys[@"9"];
    XCUIElement *key1 = app/*@START_MENU_TOKEN@*/.keys[@"1"]/*[[".keyboards.keys[@\"1\"]",".keys[@\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    XCUIElement *key0 = app.keys[@"0"];
    
    XCUIElement *courseOfFireElement = [scrollViewsQuery.otherElements containingType:XCUIElementTypeStaticText identifier:@"Course of Fire:"].element;
    
    for(int i = 1; i < 23; i++) {
        [[[courseOfFireElementsQuery childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:i] tap];
        [key1 tap];
        [key0 tap];
        if (i == 12)
        {
            [courseOfFireElement swipeUp];
        }
    }
    
    [courseOfFireElement tap];
    [courseOfFireElement swipeUp];
    
    //TODO: Fix this check below
    //XCUIElementQuery *elementsQuery = scrollViewsQuery.otherElements;
//    [elementsQuery.staticTexts[@"100"]];
//    [elementsQuery.staticTexts[@"100"] pressForDuration:0.6];
//    [elementsQuery.staticTexts[@"200"] pressForDuration:0.6];
    [app.scrollViews.otherElements/*@START_MENU_TOKEN@*/.staticTexts[@"  Apply  "]/*[[".buttons[@\"  Apply  \"].staticTexts[@\"  Apply  \"]",".staticTexts[@\"  Apply  \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    
    
    
//    XCUIApplication *app = [[XCUIApplication alloc] init];
//    [app.tables/*@START_MENU_TOKEN@*/.staticTexts[@"Unit Test Match on 2020-12-24"]/*[[".cells.staticTexts[@\"Unit Test Match on 2020-12-24\"]",".staticTexts[@\"Unit Test Match on 2020-12-24\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
//    [app.navigationBars[@"Course of Fire"].buttons[@"Add"] tap];
//
//    XCUIElementQuery *scrollViewsQuery = app.scrollViews;
//    [[[[scrollViewsQuery.otherElements containingType:XCUIElementTypeStaticText identifier:@"Course of Fire:"] childrenMatchingType:XCUIElementTypeTextField] elementBoundByIndex:0] tap];
//    [app/*@START_MENU_TOKEN@*/.pickerWheels[@"100 Yards Rapid Fire (Standing to Prone)"]/*[[".pickers.pickerWheels[@\"100 Yards Rapid Fire (Standing to Prone)\"]",".pickerWheels[@\"100 Yards Rapid Fire (Standing to Prone)\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ swipeUp];
//
//    XCUIElement *courseOfFireElement = [scrollViewsQuery.otherElements containingType:XCUIElementTypeStaticText identifier:@"Course of Fire:"].element;
//    [courseOfFireElement tap];
//    [courseOfFireElement swipeUp];
//    [app.toolbars[@"Toolbar"].buttons[@"Done"] tap];
//    [courseOfFireElement swipeUp];
//    [courseOfFireElement swipeUp];
    
}

-(void)testDeleteMatch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    XCUIElementQuery *tablesQuery = app.tables;
    NSString *tableName = [NSString stringWithFormat:@"%@ on %@",MatchName, MatchOnDate];
    XCUIElement *selectedMatchToDelete = tablesQuery.staticTexts[tableName];
    
    [selectedMatchToDelete swipeLeft];
    //Above functions work fine, need to have the delete button activate.
    //TODO: Get Delete button working.
    
    //XCUIElement *test = tablesQuery.staticTexts[tableName].menuButtons[@"Delete"];
//    XCUIElement *myAss = selectedMatchToDelete.buttons[@"Delete"];
//    [myAss tap];
    NSLog(@"Break point holder");
}

-(void)testScratch {
    //[[[XCUIApplication alloc] init]/*@START_MENU_TOKEN@*/.windows[@"SceneWindow"].buttons[@"trailing1"]/*[[".windows[@\"My NRA Rifle Match Score Sheet\"]",".groups",".buttons[@\"Delete\"]",".buttons[@\"trailing1\"]",".windows[@\"SceneWindow\"]"],[[[-1,4,1],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0,0]]@END_MENU_TOKEN@*/ click];
    
}
@end
