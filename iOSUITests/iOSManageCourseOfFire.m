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
}
- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    MatchName = @"Unit Test Match";
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

-(void)testDeleteMatch {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [app launch];
    
    XCUIElementQuery *tablesQuery = app.tables;
    XCUIElement *uniitTestOn20201224StaticText = tablesQuery.staticTexts[@"Unit Test on 2020-12-24"];
    [uniitTestOn20201224StaticText swipeLeft];
    
    //[uniitTestOn20201224StaticText.staticTexts[@"Delete"] tap];

}

@end
