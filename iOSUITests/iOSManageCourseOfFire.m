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
    
    unsigned short len = [MatchName length];
    char buffer[len];

    [MatchName getCharacters:buffer range:NSMakeRange(0, len)];
    
    for(int i = 0; i < len; ++i) {
       char current = buffer[i];
        NSString *myKey = [[NSString alloc] stringWithUTF8String:&current];
        if ([myKey length] > 0)
        {
            //XCUIElement *autoKey = [XCUIElement alloc];
            [app.keys[myKey] tap];
            //autoKey = app.keys[myKey];
            //[autoKey tap];
        }
    }
    
//    XCUIElement *uKey = app/*@START_MENU_TOKEN@*/.keys[@"U"]/*[[".keyboards.keys[@\"U\"]",".keys[@\"U\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
//    [uKey tap];
//
//    XCUIElement *nKey = app/*@START_MENU_TOKEN@*/.keys[@"n"]/*[[".keyboards.keys[@\"n\"]",".keys[@\"n\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
//    [nKey tap];
//
//    XCUIElement *iKey = app/*@START_MENU_TOKEN@*/.keys[@"i"]/*[[".keyboards.keys[@\"i\"]",".keys[@\"i\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
//    [iKey tap];
//
//    XCUIElement *tKey = app/*@START_MENU_TOKEN@*/.keys[@"t"]/*[[".keyboards.keys[@\"t\"]",".keys[@\"t\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
//    [tKey tap];
//
//    XCUIElement *spaceKey = app/*@START_MENU_TOKEN@*/.keys[@"space"]/*[[".keyboards.keys[@\"space\"]",".keys[@\"space\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
//    [spaceKey tap];
//
//    XCUIElement *tKey2 = app/*@START_MENU_TOKEN@*/.keys[@"T"]/*[[".keyboards.keys[@\"T\"]",".keys[@\"T\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
//    [tKey2 tap];
//
//    XCUIElement *eKey = app/*@START_MENU_TOKEN@*/.keys[@"e"]/*[[".keyboards.keys[@\"e\"]",".keys[@\"e\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
//    [eKey tap];
//
//    XCUIElement *sKey = app/*@START_MENU_TOKEN@*/.keys[@"s"]/*[[".keyboards.keys[@\"s\"]",".keys[@\"s\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/;
//    [sKey tap];
//    [tKey tap];
    
    
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
