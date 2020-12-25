//
//  iOSUISettings.m
//  iOSUITests
//
//  Created by burnsoft on 12/24/20.
//  Copyright © 2020 burnsoft. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface iOSUISettings : XCTestCase

@end

@implementation iOSUISettings

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

- (void)testAddInformation {
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    [app.tabBars[@"Tab Bar"].buttons[@"Settings"] tap];
    [app.textFields[@"1234567"] tap];
    
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
    
    
}

- (void)testAddiTunesBackup {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testAddDivision {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testAddCourseOfFire {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

@end
