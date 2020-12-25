//
//  iOSUISettings.m
//  iOSUITests
//
//  Created by burnsoft on 12/24/20.
//  Copyright © 2020 burnsoft. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "General.h"

@interface iOSUISettings : XCTestCase

@end

@implementation iOSUISettings
{
    NSString *DivisionName;
    NSString *COFName;
}
- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    DivisionName=@"Unit Test";
    COFName=@"COF Unit Test";
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
   //[[[XCUIApplication alloc] init] launch];

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testAddInformation {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    XCUIElement *tabBar = app.tabBars[@"Tab Bar"];
    [tabBar.buttons[@"Settings"] tap];
    [app.textFields[@"1234567"] tap];
    //[app/*@START_MENU_TOKEN@*/.buttons[@"Clear text"]/*[[".textFields[@\"MM\/YYYY or LIFE\"].buttons[@\"Clear text\"]",".buttons[@\"Clear text\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    
    XCUIElement *key5 = app/*@START_MENU_TOKEN@*/.keys[@"5"]/*[[".keyboards.keys[@\"5\"]",".keys[@\"5\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    XCUIElement *key6 = app.keys[@"6"];
    XCUIElement *key9 = app.keys[@"9"];
    XCUIElement *key8 = app.keys[@"8"];
    XCUIElement *key4 = app/*@START_MENU_TOKEN@*/.keys[@"4"]/*[[".keyboards.keys[@\"4\"]",".keys[@\"4\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    XCUIElement *key7 = app.keys[@"7"];
    XCUIElement *key3 = app/*@START_MENU_TOKEN@*/.keys[@"3"]/*[[".keyboards.keys[@\"3\"]",".keys[@\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    XCUIElement *key1 = app/*@START_MENU_TOKEN@*/.keys[@"1"]/*[[".keyboards.keys[@\"1\"]",".keys[@\"1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    XCUIElement *key2 = app.keys[@"2"];
    XCUIElement *key0 = app/*@START_MENU_TOKEN@*/.keys[@"0"]/*[[".keyboards.keys[@\"0\"]",".keys[@\"0\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    XCUIElement *keyForwardSlash = app/*@START_MENU_TOKEN@*/.keys[@"/"]/*[[".keyboards.keys[@\"\/\"]",".keys[@\"\/\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    
    
    [key5 tap];
    [key6 tap];
    [key9 tap];
    [key8 tap];
    [key3 tap];
    [key4 tap];
    [key5 tap];
    [key7 tap];
    [key6 tap];
    
    
    XCUIElement *mmYyyyOrLifeTextField = app.textFields[@"MM/YYYY or LIFE"];
    [mmYyyyOrLifeTextField tap];
    
    [key1 tap];
    [key7 tap];
    
    [keyForwardSlash tap];
    [key7 tap];
    
    [key2 tap];
    [key0 tap];
    [key5 tap];
    [key0 tap];
    

    [[[[[[[[[[[[app childrenMatchingType:XCUIElementTypeWindow] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element childrenMatchingType:XCUIElementTypeOther].element tap];
    [tabBar.buttons[@"Match Lists"] tap];
    
}

- (void)testAddiTunesBackup {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    XCUIElement *tabBar = app.tabBars[@"Tab Bar"];
    [tabBar.buttons[@"Settings"] tap];
    [app/*@START_MENU_TOKEN@*/.staticTexts[@"  Use iTunes File Sharing for Backup & Restore  "]/*[[".buttons[@\"  Use iTunes File Sharing for Backup & Restore  \"].staticTexts[@\"  Use iTunes File Sharing for Backup & Restore  \"]",".staticTexts[@\"  Use iTunes File Sharing for Backup & Restore  \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [app/*@START_MENU_TOKEN@*/.staticTexts[@"  Run Backup  "]/*[[".buttons[@\"  Run Backup  \"].staticTexts[@\"  Run Backup  \"]",".staticTexts[@\"  Run Backup  \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    [app.alerts[@"Success!"].scrollViews.otherElements.buttons[@"OK"] tap];
    [app.navigationBars[@"Settings"].buttons[@"Settings"] tap];
    [tabBar.buttons[@"Match Lists"] tap];
    
}

- (void)testAddDivision {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    XCUIElement *tabBar = app.tabBars[@"Tab Bar"];
    [tabBar.buttons[@"Settings"] tap];
    [app/*@START_MENU_TOKEN@*/.staticTexts[@"  Add, Edit or Delete Divisions  "]/*[[".buttons[@\"  Add, Edit or Delete Divisions  \"].staticTexts[@\"  Add, Edit or Delete Divisions  \"]",".staticTexts[@\"  Add, Edit or Delete Divisions  \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    XCUIElement *manageDivisionsNavigationBar = app.navigationBars[@"Manage Divisions"];
    [manageDivisionsNavigationBar.buttons[@"Add"] tap];
    XCUIElementQuery *elementsQuery = app.alerts[@"Divisions"].scrollViews.otherElements;
    
    //Start code section for string diesect and send
    NSUInteger len = [DivisionName length];
    unichar buffer[len+1];

    [DivisionName getCharacters:buffer range:NSMakeRange(0, len)];

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
    //END String disect
    
    [elementsQuery.buttons[@"ADD"] tap];
    [manageDivisionsNavigationBar.buttons[@"Settings"] tap];
    [tabBar.buttons[@"Match Lists"] tap];
    
}

//- (void)sendTextToKeyBoard:(XCUIApplication *) app :(NSString *) value
//{
//    //Start code section for string diesect and send
//    NSUInteger len = [value length];
//    unichar buffer[len+1];
//
//    [value getCharacters:buffer range:NSMakeRange(0, len)];
//
//    NSLog(@"getCharacters:range: with unichar buffer");
//    for(int i = 0; i < len; i++) {
//        NSString *newValue = [NSString stringWithFormat:@"%C", buffer[i]];
//
//        if ([newValue length] > 0)
//        {
//            if ([newValue isEqual:@" "])
//            {
//                newValue = @"space";
//            }
//            [app.keys[newValue] tap];
//        }
//    }
//}

- (void)testAddCourseOfFire {
    
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    XCUIElement *tabBar = app.tabBars[@"Tab Bar"];
    [tabBar.buttons[@"Settings"] tap];
    [app/*@START_MENU_TOKEN@*/.staticTexts[@"  Add, Edit or Delete Course of Fire  "]/*[[".buttons[@\"  Add, Edit or Delete Course of Fire  \"].staticTexts[@\"  Add, Edit or Delete Course of Fire  \"]",".staticTexts[@\"  Add, Edit or Delete Course of Fire  \"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/ tap];
    
    XCUIElement *manageCourseOfFireNavigationBar = app.navigationBars[@"Manage Course of Fire"];
    [manageCourseOfFireNavigationBar.buttons[@"Add"] tap];
    //[General sendTextToKeyBoard:app :COFName];
    
    
    XCUIElement *cKey = app/*@START_MENU_TOKEN@*/.keys[@"c"]/*[[".keyboards.keys[@\"c\"]",".keys[@\"c\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [cKey tap];

    XCUIElement *oKey = app/*@START_MENU_TOKEN@*/.keys[@"o"]/*[[".keyboards.keys[@\"o\"]",".keys[@\"o\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [oKey tap];

    XCUIElement *fKey = app/*@START_MENU_TOKEN@*/.keys[@"f"]/*[[".keyboards.keys[@\"f\"]",".keys[@\"f\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
    [fKey tap];
    
    /*@START_MENU_TOKEN@*/[app.alerts[@"Course of Fire"].scrollViews.otherElements.buttons[@"ADD"] pressForDuration:0.6];/*[["app.alerts[@\"Course of Fire\"].scrollViews.otherElements.buttons[@\"ADD\"]","["," tap];"," pressForDuration:0.6];"],[[[-1,0,1]],[[1,3],[1,2]]],[0,0]]@END_MENU_TOKEN@*/
    [manageCourseOfFireNavigationBar.buttons[@"Settings"] tap];
    [tabBar.buttons[@"Match Lists"] tap];
    
    
}

@end
